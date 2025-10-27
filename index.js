import express from 'express';
import mysql from 'mysql2/promise';
import cors from 'cors';
import dotenv from 'dotenv';
import bodyParser from 'body-parser';
import bcrypt from 'bcryptjs';
import GenerateTokens from './utils/GenerateTokens.js';
import jwt from 'jsonwebtoken';
import './middleware/authenticate.js';
import { authenticate } from './middleware/authenticate.js';









dotenv.config();
const app = express();
const port = process.env.PORT || 5001;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));


// MySQL connection
const db = await mysql.createConnection({
    host: 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'ruch004',
    database: process.env.DB_NAME || 'FMS' // your database name
});

console.log('✅ Connected to MySQL database');

// Test route
app.get('/',  (req, res) => {
    res.send('API is running...');
});

// Function to get seats from the database
const get_seats = async () => {
    try {
        const [rows] = await db.query('SELECT * FROM Seat');
        return rows;
    } catch (err) {
        console.error('Error fetching seats:', err);
        throw err;
    }
};

// Route to get all seats
app.get('/api/seats', authenticate, async (req, res) => {
    try {
        const seats = await get_seats();
        console.log('Seats fetched:', seats);
        res.json(seats);
    } catch (err) {
        res.status(500).json({ error: 'Database error' });
    }
});


app.post('/api/search_flights', async (req, res) => {
    const { source, destination, date } = req.body;
    console.log('Search parameters:', { source, destination, date });

    try {
        const [flights] = await db.execute('CALL search_flight(?,?,?)', [source, destination, date]);
        console.log('Flights found:', flights);


        res.send(flights); // Send formatted HTML to browser

    } catch (err) {
        console.error('Error searching flights:', err);
        res.status(500).send('<h1>Database error</h1>');
    }
});

app.get('/api/flight/:id', authenticate, async (req, res) => {
    const flightId = req.params.id;
    try {
        const [rows] = await db.execute('CALL booked_seats(?)', [flightId]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Flight not found' });
        }
        console.log('Flight ID requested:', flightId);
        console.log('booked seat  response:', rows[0]);
        res.json(rows[0]);
    } catch (err) {
        console.error('Error fetching flight details:', err);

        res.status(500).json({ error: 'Database error' });
    }
});

/*
booking data structure:Object
flight: {source: 'Delhi', destination: 'Mumbai', date: '2025-10-12', flightName: 'Indigo'}
seats: (2) [{…}, {…}]
selectedFlight: {flightID: 1, source: 'Delhi', destination: 'Mumbai', date: '2025-10-12', flightName: 'Indigo'}
selectedflight: {flightID: 1, source: 'Delhi', destination: 'Mumbai', date: '2025-10-12', flightName: 'Indigo'}
{flightID: 1, source: 'Delhi', destination: 'Mumbai', date: '2025-10-12', flightName: 'Indigo'}
totalPrice: 16000
user: Array(2)
0
{name: 'Menhaz', age: '21', gender: 'male'}
1
: 
{name: 'Ruchika', age: '21', gender: 'female'}
length
: 
2


*/
app.post("/api/bookings", authenticate, async (req, res) => {
  try {
    const bookingData = req.body;
    const { selectedFlight, seats } = bookingData;

    if (!selectedFlight || !seats || seats.length === 0) {
      return res.status(400).json({ error: "No flight or seats selected" });
    }

    const flightID = selectedFlight.flightID;

    // Start transaction
    await db.beginTransaction();

    try {
      const insertQuery = `
        INSERT INTO seat (FlightID, SeatNumber, Category, Price, Status)
        VALUES (?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE Status = 'Booked'
      `;

      for (const seat of seats) {
        const { label, category, price } = seat;
        await db.query(insertQuery, [flightID, label, category, price, "Booked"]);
      }

      // Commit
      await db.commit();
      res.json({ message: "Seats booked successfully" });
    } catch (err) {
      await db.rollback();
      throw err;
    }
  } catch (error) {
    console.error("Error storing booking data:", error);
    res.status(500).json({ error: "Failed to store booking data" });
  }
});

// Start server
app.listen(port, () => {
    console.log(`🚀 Server running on http://localhost:${port}`);
});

/** * Export the app for testing or further usage
 */


app.post("/api/register", async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  const checkQuery = "SELECT * FROM users WHERE email = ?";

  try {
    // Step 1: Check if email already exists
    const [results] = await db.query(checkQuery, [email]);
    if (results.length > 0) {
      return res.status(409).json({ message: "User with this email already exists" });
    }

    // Step 2: Hash password
    console.log("Registering user:", { name, email });
    const hashedPassword = await bcrypt.hash(password, 10);

    // Step 3: Insert new user
    const insertQuery = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
    await db.query(insertQuery, [name, email, hashedPassword]);
    console.log("User registered successfully:", email);

    // Step 4: Respond success
    res.status(201).json({ message: "User registered successfully" });

  } catch (err) {
    console.error("Database error:", err);
    res.status(500).json({ message: "Database error", error: err.message });
  }
});



///login


app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
    if (!email || !password)
        return res.status(400).json({ message: "Email and password are required" });

    const selectQuery = "SELECT * FROM users WHERE email = ?";

    try {
        // Step 1: Fetch user by email
        const [results] = await db.query(selectQuery, [email]);
        if (results.length === 0)
            return res.status(401).json({ message: "Invalid credentials" });

        const user = results[0];
        console.log('User found:', user);

        // Step 2: Compare password
        const isValid = bcrypt.compareSync(password, user.password);
        if (!isValid)
            return res.status(401).json({ message: "Invalid credentials" });

        // Step 3: Generate JWT

        const { accessToken, refreshToken } = GenerateTokens(user);

        // Delete old refresh tokens
        try{
            const deleteResult = await db.query("DELETE FROM refresh_tokens WHERE user_id = ?", [user.id]);
            console.log('Old refresh tokens deleted:', deleteResult);
        }
        catch(err){
            console.error('Error deleting old refresh tokens:', err);
        }
        //store in database
         const query = "INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 7 DAY))";
        try{
            const result = await db.query(query, [user.id, refreshToken]);
            console.log('Refresh token stored result:', result);
        }catch(err){
            console.error('Error storing refresh token:', err);
        }
        console.log('Refresh token stored in database for user:', user.id);

        // Step 4: Respond with token
        res.json({ Username:user.name, accessToken, refreshToken });

    } catch (err) {
        console.error("Error during login:", err);
        res.status(500).json({ message: "Database error", error: err });
    }
});

//logout
app.post('/api/logout', async (req, res) => {

    const { refreshToken } = req.body;

    console.log('Logout request received with refresh token:', refreshToken);

    if (!refreshToken) return res.status(400).json({ message: "Refresh token required" });

    const query = "DELETE FROM refresh_tokens WHERE token = ?";

    const result = await db.query(query, [refreshToken]);
        console.log('Logout query result:', result);    

    if (result.affectedRows === 0) {
        return res.status(404).json({ message: "Refresh token not found" });
    }
    res.json({ message: "Logged out successfully" });

});


//refresh token
app.post('/api/refresh', async (req, res) => {
    const { refreshToken } = req.body;
    if (!refreshToken)
        return res.status(401).json({ message: "No refresh token provided" });

    try {
        // Step 1: Check if refresh token exists in DB
        const [results] = await db.query("SELECT * FROM refresh_tokens WHERE token = ?", [refreshToken]);
        if (results.length === 0)
            return res.status(403).json({ message: "Invalid refresh token" });

        // Step 2: Verify the refresh token
        jwt.verify(refreshToken, process.env.JWT_SECRET, (err, decoded) => {
            if (err)
                return res.status(403).json({ message: "Expired or invalid refresh token" });

            // Step 3: Generate new access token
            const newAccessToken = jwt.sign(
                { sub: decoded.sub },
                process.env.JWT_SECRET,
                { expiresIn: "15m" }
            );

            // Step 4: Send new token back
            res.json({ accessToken: newAccessToken });
        });

    } catch (err) {
        console.error("Error verifying refresh token:", err);
        res.status(500).json({ message: "Database error", error: err });
    }
});


export default app;