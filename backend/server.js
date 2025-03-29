const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");
const bodyParser = require("body-parser");
const bcrypt = require("bcryptjs");

const app = express();

const PORT = 5000;
const HOST = "0.0.0.0";  // ✅ Allowing all IP addresses


// ✅ Enable CORS & JSON body parsing
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// ✅ Database Connection
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "", // Add your MySQL password if needed
  database: "flutter_crud",
});

db.connect((err) => {
  if (err) {
    console.error("❌ Database Connection Error:", err);
    throw err;
  }
  console.log("✅ MySQL Connected...");
});

// ✅ User Registration with Bcrypt
app.post("/register", async (req, res) => {
  const { username, email, password } = req.body;

  if (!username || !email || !password) {
    return res.status(400).json({ message: "All fields are required" });
  }

  // Check if email already exists
  const checkQuery = "SELECT * FROM users WHERE email = ?";
  db.query(checkQuery, [email], async (checkErr, checkResult) => {
    if (checkErr) {
      console.error("❌ Database error:", checkErr);
      return res.status(500).json({ message: "Database error" });
    }

    if (checkResult.length > 0) {
      return res.status(409).json({ message: "Email already exists" });
    }

    // ✅ Hash the password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Insert new user
    const insertQuery =
      "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
    db.query(
      insertQuery,
      [username, email, hashedPassword],
      (insertErr, insertResult) => {
        if (insertErr) {
          console.error("❌ Database error:", insertErr);
          return res.status(500).json({ message: "Database error" });
        }

        res.status(201).json({ message: "User registered successfully" });
      }
    );
  });
});

// ✅ User Login with Bcrypt Password Check
app.post("/login", (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Email and password are required" });
  }

  const query = "SELECT * FROM users WHERE email = ?";
  db.query(query, [email], async (err, result) => {
    if (err) {
      console.error("❌ Database error:", err);
      return res.status(500).json({ message: "Database error" });
    }

    if (result.length === 0) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    const user = result[0];

    // ✅ Compare hashed password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    res.json({
      message: "✅ Login successful",
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
      },
    });
  });
});

// ✅ Add User for Admin Use
app.post("/users", async (req, res) => {
    const { name, email, password } = req.body;
  
    if (!name || !email) {
      return res.status(400).json({ message: "All fields are required" });
    }
  
    // ✅ Hash the password for security (optional, if password is needed)
    const hashedPassword = password
      ? await bcrypt.hash(password, 10)
      : null;
  
    db.query(
      "INSERT INTO users (username, email, password) VALUES (?, ?, ?)",
      [name, email, hashedPassword || ""],
      (err, result) => {
        if (err) {
          console.error("❌ Database error:", err);
          return res.status(500).json({ message: "Database error" });
        }
        res.json({ message: "✅ User added successfully", id: result.insertId });
      }
    );
  });
  

// ✅ Fetch All Users
app.get("/users", (req, res) => {
    db.query("SELECT id, username AS name, email FROM users", (err, result) => {
      if (err) {
        console.error("❌ Database error:", err);
        return res.status(500).json({ message: "Database error" });
      }
      res.json(result);
    });
  });
  

// ✅ Update User (Admin Only)
app.put("/users/:id", (req, res) => {
  const { name, email } = req.body;

  if (!name || !email) {
    return res.status(400).json({ message: "All fields are required" });
  }

  db.query(
    "UPDATE users SET username = ?, email = ? WHERE id = ?",
    [name, email, req.params.id],
    (err) => {
      if (err) {
        console.error("❌ Database error:", err);
        return res.status(500).json({ message: "Database error" });
      }
      res.json({ message: "User updated successfully" });
    }
  );
});

// ✅ Delete User
app.delete("/users/:id", (req, res) => {
  db.query("DELETE FROM users WHERE id = ?", [req.params.id], (err) => {
    if (err) {
      console.error("❌ Database error:", err);
      return res.status(500).json({ message: "Database error" });
    }
    res.json({ message: "User deleted successfully" });
  });
});


//Start Server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`✅ Server running at http://${HOST}:${PORT}`);
});
