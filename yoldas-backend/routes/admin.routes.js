// admin.routes.js

const express = require("express");
const router = express.Router();
const verifyToken = require("../middlewares/auth.middleware");
const isAdmin = require("../middlewares/isAdmin.middleware");

// Korumalı ve sadece admin rolüne sahip kullanıcıların erişebileceği route
router.get("/dashboard", verifyToken, isAdmin, (req, res) => {
  res.json({
    message: "Welcome to the admin dashboard!",
    user: req.user
  });
});

module.exports = router;
