const express = require("express");
const router = express.Router();
const orderController = require("../controllers/order.controller");
const verifyToken = require("../middlewares/auth.middleware");

// Kullanıcının siparişlerini getir
router.get("/", verifyToken, orderController.getUserOrders);

// Yeni sipariş oluştur
router.post("/", verifyToken, orderController.createOrder);

module.exports = router; 