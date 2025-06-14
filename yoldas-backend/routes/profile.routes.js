const express = require("express");
const router = express.Router();
const profileController = require("../controllers/profile.controller");
const verifyToken = require("../middlewares/auth.middleware");
const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// Token doğrulama isteyen korumalı route
router.get("/", verifyToken, async (req, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      select: {
        id: true,
        email: true,
        role: true,
        name: true,
        phone: true,
        gender: true,
        birthday: true,
      },
    });
    res.json({ user });
  } catch (error) {
    res.status(500).json({ error: "Profil getirilemedi." });
  }
});

// Profil bilgilerini güncelle
router.patch("/", verifyToken, profileController.updateProfile);

// Hizmetleri güncelle
router.patch("/services", verifyToken, profileController.updateServices);

module.exports = router;
