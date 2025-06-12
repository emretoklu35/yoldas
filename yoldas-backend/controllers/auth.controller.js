const { PrismaClient } = require("@prisma/client");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const prisma = new PrismaClient();
const JWT_SECRET = process.env.JWT_SECRET || "dev_secret";

exports.register = async (req, res) => {
  console.log('body: ', req.body);
  const { email, password, name, phone, gender, birthday, role, gasStationId } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required." });
  }

  try {
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return res.status(409).json({ error: "User already exists." });
    }

    // Eğer servis sağlayıcı ise gasStationId kontrolü yap
    if (role === "serviceprovider") {
      console.log(' ---------- >>>  In SERVICEPROVIDER', gasStationId);
      if (!gasStationId) {
        return res.status(400).json({ error: "Service provider must have a gasStationId." });
      }

      const gasStation = await prisma.gasStation.findUnique({
        where: { placeId: gasStationId },
      });

      console.log('gasStationExists: ', gasStation);

      if (!gasStation) {
        return res.status(404).json({ error: "Gas station not found." });
      }
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        role: role,
        name,
        phone,
        gender,
        birthday: birthday ? new Date(birthday) : null,
        //gasStationId: role === 'serviceprovider' && gasStationId ? Number(gasStationId) : null,
      },
    });

    console.log("Yeni kullanıcı eklendi:", user);

    res.status(201).json({
      message: "User registered successfully",
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
        name: user.name,
        phone: user.phone,
        gender: user.gender,
        birthday: user.birthday,
        gasStationId: user.gasStationId,
      },
    });
  } catch (error) {
    console.error("Kayıt hatası:", error, error.meta);
    res.status(500).json({ error: "Registration failed.", detail: error.message, meta: error.meta });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) return res.status(404).json({ error: "User not found." });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch)
      return res.status(401).json({ error: "Invalid credentials." });

    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: "7d" }
    );

    res.json({
      message: "Login successful",
      token,
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
        name: user.name,
        phone: user.phone,
        gender: user.gender,
        birthday: user.birthday,
        gasStationId: user.gasStationId,
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Login failed." });
  }
};
