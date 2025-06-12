const express = require("express");
const router = express.Router();
const vehicleController = require("../controllers/vehicles.controller");
const verifyToken = require("../middlewares/auth.middleware");

// Kullanıcının araçlarını getir
router.get("/", verifyToken, vehicleController.getUserVehicles);

// Yeni araç oluştur
router.post("/add", verifyToken, vehicleController.createVehicle);

module.exports = router; 