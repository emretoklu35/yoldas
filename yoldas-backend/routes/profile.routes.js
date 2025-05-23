const express = require("express");
const router = express.Router();
const verifyToken = require("../middlewares/auth.middleware");

// Token doğrulama isteyen korumalı route
router.get("/", verifyToken, (req, res) => {
  res.json({
    message: "Profile data",
    user: req.user
  });
});

module.exports = router;
