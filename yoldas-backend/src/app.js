const express = require('express');
const cors = require('cors');
const app = express();

// CORS ayarları
app.use(cors({
  origin: '*', // Tüm originlere izin ver
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
  credentials: true
}));

app.use(express.json());

// Routes
const gasStationRoutes = require('./routes/gasStationRoutes');
app.use('/api/gas-stations', gasStationRoutes);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    error: 'Bir hata oluştu',
    details: err.message
  });
});

module.exports = app; 