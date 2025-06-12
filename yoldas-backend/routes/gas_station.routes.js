const express = require("express");
const router = express.Router();
const gasStationController = require("../controllers/gas_station.controller");
const verifyToken = require("../middlewares/auth.middleware");

// İstasyon ekle
router.post("/add", verifyToken, gasStationController.addGasStation);

// Yakındaki istasyonları getir
router.get("/nearby", verifyToken, gasStationController.getNearbyGasStations);

// Butun istasyonlari dondur
router.get("/many", gasStationController.findMany)

module.exports = router; 