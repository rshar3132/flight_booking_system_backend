import jwt from "jsonwebtoken";

export const authenticate = (req, res, next) => {
  // Extract the header that axios sends
    const authHeader = req.headers["authorization"];
    console.log("Auth Header:", authHeader);         
    // Format: "Bearer <token>"
    const token = authHeader && authHeader.split(" ")[1];

    if (!token) {
        return res.status(401).json({ message: "No token provided" });
    }

    // Verify the token using your secret
    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
        return res.status(403).json({ message: "Invalid or expired token" });
        }

        // Store user data for later use in the route
        req.user = decoded;
        next(); // continue to the route handler
  });
};
