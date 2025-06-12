require("dotenv").config();
const express = require("express");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 8080;

// Request logging middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  console.log('Headers:', req.headers);
  console.log('Body:', req.body);
  next();
});

// Middleware
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// Routes
const authRoutes = require("./routes/auth.routes");
const profileRoutes = require("./routes/profile.routes");
const adminRoutes = require("./routes/admin.routes");
const forgotPasswordRoute = require("./routes/forgotPassword.routes");
const resetPasswordRoutes = require("./routes/resetPassword.routes");
const orderRoutes = require("./routes/order.routes");
const gasStationRoutes = require("./routes/gas_station.routes");
const vehicleRoutes = require("./routes/vehicle.routes");

// ✅ Yeni eklediğimiz route:


app.use("/api/auth", authRoutes);
app.use("/api/profile", profileRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api", forgotPasswordRoute);
app.use("/api", resetPasswordRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/gas-stations", gasStationRoutes);
app.use("/api/vehicles", vehicleRoutes);

// ✅ Yeni route'u tanımladık:


// Root route
app.get("/", (req, res) => {
  res.send("Yoldaş Backend Running 🚀");
});

// Start server
app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running at http://0.0.0.0:${PORT}`);
});
