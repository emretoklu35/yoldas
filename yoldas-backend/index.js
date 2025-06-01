require("dotenv").config();
const express = require("express");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 8080;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
const authRoutes = require("./routes/auth.routes");
const profileRoutes = require("./routes/profile.routes");
const adminRoutes = require("./routes/admin.routes");
const forgotPasswordRoute = require("./routes/forgotPassword.routes");
const resetPasswordRoutes = require("./routes/resetPassword.routes");
const orderRoutes = require("./routes/order.routes");

// ✅ Yeni eklediğimiz route:


app.use("/api/auth", authRoutes);
app.use("/api/profile", profileRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api", forgotPasswordRoute);
app.use("/api", resetPasswordRoutes);
app.use("/api/orders", orderRoutes);

// ✅ Yeni route'u tanımladık:


// Root route
app.get("/", (req, res) => {
  res.send("Yoldaş Backend Running 🚀");
});

// Start server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running at http://0.0.0.0:${PORT}`);
});
