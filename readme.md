  ## 🚀 Setup Guide

  ### **Install All Dependencies**

        First, make sure you have **Node.js** installed.
        Then, open your terminal inside the project folder and run: npm install

        💡 This command automatically installs all required modules listed in `package.json`.

        -------------------------------------------------------------------------

  ###  **Modules Used**

        Here are the main Node.js modules used in backend:

            | Module           | Purpose                                                          |
        | ---------------- | ---------------------------------------------------------------- |
        | **express**      | For creating the backend server and APIs                         |
        | **nodemon**      | Auto-restarts the server during development                      |
        | **cors**         | Enables communication between frontend and backend               |
        | **mysql2**       | Connects Node.js with the MySQL database                         |
        | **dotenv**       | Loads environment variables from `.env` file                     |
        | **axios**        | Used for making HTTP requests (e.g., frontend ↔ backend)         |
        | **jsonwebtoken** | For creating and verifying JSON Web Tokens (authentication)      |
        | **bcryptjs**     | For hashing passwords securely                                   |
        | **body-parser**  | Parses incoming request bodies in middleware (JSON, URL-encoded) |


        > ⚙️ You can install any missing module manually using:

        ```bash
        npm install module_name
        ```

        Example:

        ```bash
        npm install express mysql2 dotenv cors axios nodemon
        ```

        ---




  ###  **Environment Configuration**

       Create a file named `.env` in your project root directory and add your MySQL credentials:

      ```bash
      DB_HOST=localhost
      DB_USER=your_mysql_username
      DB_PASSWORD=your_mysql_password
      DB_NAME=your_database_name
      PORT=5001
      ```

      > 🛠 **Important:**
      >
      > * Replace `your_mysql_username` and `your_mysql_password` with your actual MySQL credentials.
      > * Make sure your `.env` file is listed in `.gitignore` (so it’s not uploaded to GitHub).

  ---
  ###  **copy paste database**
        to export :mysqldump -u root -p db_name > db_name.sql(you dont need this)

        to import : mysql -u root -p db_name < db_name.sql( Do this)

        for example: mysqldump -u root -p fms > "D:\Database\db_name.sql"

        With this, you can:
          Backup your database
          Share the database with other admins
          Restore the database on another machine

  ###  **Run the Server**

    Start the development server with:

    ```bash
    npm start
    ```

    > (This uses **nodemon** to automatically restart the server on file changes.)

    If you don’t have a start script set up yet, add this line inside your `package.json`:

    ```json
    "scripts": {
      "start": "nodemon index.js"
    }
    ```

    ---

  ### **That’s it!**

        Now your backend should be running successfully 🎉
        You can test it using:

        ```
        http://localhost:5001
        ```
        ---

