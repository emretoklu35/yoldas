const nodemailer = require("nodemailer");
require("dotenv").config();

const sendMail = async (to, subject, text) => {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER, // Örn: cerenkocyigit05@gmail.com
      pass: process.env.EMAIL_PASS, // Google'dan alınan uygulama şifresi
    },
  });

  const mailOptions = {
    from: `"Yoldaş Destek" <${process.env.EMAIL_USER}>`,
    to,
    subject,
    text,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log("Mail gönderildi:", to);
  } catch (error) {
    console.error("Mail gönderilemedi:", error);
  }
};

module.exports = sendMail;
