const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// Kullanıcı profilini getir
exports.getProfile = async (req, res) => {
  try {
    const userId = req.user.id;

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        name: true,
        phone: true,
        role: true,
        services: true,
        createdAt: true,
      },
    });

    if (!user) {
      return res.status(404).json({ message: "Kullanıcı bulunamadı" });
    }

    res.json(user);
  } catch (error) {
    console.error("Profil getirilirken hata:", error);
    res.status(500).json({ message: "Profil getirilemedi" });
  }
};

// Profil güncelle
exports.updateProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const { name, phone } = req.body;

    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: {
        name,
        phone,
      },
      select: {
        id: true,
        email: true,
        name: true,
        phone: true,
        role: true,
        services: true,
        createdAt: true,
      },
    });

    res.json(updatedUser);
  } catch (error) {
    console.error("Profil güncellenirken hata:", error);
    res.status(500).json({ message: "Profil güncellenemedi" });
  }
};

// Hizmetleri güncelle
exports.updateServices = async (req, res) => {
  try {
    const userId = req.user.id;
    const { services } = req.body;

    // Kullanıcının rolünü kontrol et
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { role: true },
    });

    if (user.role !== 'serviceprovider') {
      return res.status(403).json({ message: "Bu işlem için yetkiniz yok" });
    }

    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: {
        services,
      },
      select: {
        id: true,
        email: true,
        name: true,
        phone: true,
        role: true,
        services: true,
        createdAt: true,
      },
    });

    res.json(updatedUser);
  } catch (error) {
    console.error("Hizmetler güncellenirken hata:", error);
    res.status(500).json({ message: "Hizmetler güncellenemedi" });
  }
}; 