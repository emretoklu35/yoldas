const express = require("express");
const router = express.Router();
const prisma = require("../prisma/client");
const bcrypt = require("bcryptjs");

router.post("/reset-password", async (req, res) => {
  const { token, newPassword } = req.body;

  const user = await prisma.user.findFirst({
    where: {
      resetToken: token,
      resetTokenExpiry: {
        gte: new Date(),
      },
    },
  });

  if (!user) {
    return res
      .status(400)
      .json({ message: "Geçersiz veya süresi geçmiş token." });
  }

  const hashedPassword = await bcrypt.hash(newPassword, 10);

  await prisma.user.update({
    where: { id: user.id },
    data: {
      password: hashedPassword,
      resetToken: null,
      resetTokenExpiry: null,
    },
  });

  res.json({ message: "Şifreniz başarıyla güncellendi 💫" });
});

module.exports = router;
