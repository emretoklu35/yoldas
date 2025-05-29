const express = require("express");
const router = express.Router();
const sendMail = require("../utils/sendMail");
const prisma = require("../prisma/client");

router.post("/forgot-password", async (req, res) => {
  console.log("Şifre sıfırlama isteği alındı.");
  const { email } = req.body;

  const user = await prisma.user.findUnique({ where: { email } });

  if (!user) {
    return res.status(404).json({ message: "Kullanıcı bulunamadı." });
  }

  // ✅ Token oluştur ve süresi ayarla
  const resetToken = Math.random().toString(36).substring(2, 12);
  const expiry = new Date(Date.now() + 15 * 60 * 1000); // 15 dakika geçerli

  // ✅ Token'ı veritabanına yaz
  await prisma.user.update({
    where: { email },
    data: {
      resetToken,
      resetTokenExpiry: expiry,
    },
  });

  const resetLink = `yoldas://reset-password?token=${resetToken}`;

  // ✅ Mail gönder
  await sendMail(
    email,
    "Şifre Sıfırlama",
    `Şifreni yenilemek için bu bağlantıya tıkla: ${resetLink}`
  );

  res.json({
    message: "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi 💌",
  });
});

module.exports = router;
