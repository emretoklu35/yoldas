const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// Kullanıcının siparişlerini getir
exports.getUserOrders = async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { role: true },
    });

    let orders;
    if (user.role === 'serviceprovider') {
      // Servis sağlayıcı için tüm siparişleri getir
      orders = await prisma.order.findMany({
        include: {
          gasStation: true,
        },
        orderBy: {
          createdAt: 'desc',
        },
      });
    } else {
      // Normal kullanıcı için kendi siparişlerini getir
      orders = await prisma.order.findMany({
        where: { userId },
        include: {
          gasStation: true,
        },
        orderBy: {
          createdAt: 'desc',
        },
      });
    }

    res.json(orders);
  } catch (error) {
    console.error("Siparişler getirilirken hata:", error);
    res.status(500).json({ message: "Siparişler getirilemedi" });
  }
};

// Yeni sipariş oluştur
exports.createOrder = async (req, res) => {
  try {
    const userId = req.user.id;
    const {
      serviceType,
      address,
      totalAmount,
      deliveryTime,
      cardNumber,
      cardHolder,
      gasStationId,
    } = req.body;

    const order = await prisma.order.create({
      data: {
        serviceType,
        address,
        totalAmount,
        deliveryTime,
        cardNumber,
        cardHolder,
        userId,
        gasStationId,
      },
      include: {
        gasStation: true,
      },
    });

    res.status(201).json(order);
  } catch (error) {
    console.error("Sipariş oluşturulurken hata:", error);
    res.status(500).json({ message: "Sipariş oluşturulamadı" });
  }
};

// Sipariş durumunu güncelle
exports.updateOrderStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { status } = req.body;
    const userId = req.user.id;

    // Kullanıcının rolünü kontrol et
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { role: true },
    });

    if (user.role !== 'serviceprovider') {
      return res.status(403).json({ message: "Bu işlem için yetkiniz yok" });
    }

    const order = await prisma.order.update({
      where: { id: parseInt(orderId) },
      data: { status },
      include: {
        gasStation: true,
      },
    });

    res.json(order);
  } catch (error) {
    console.error("Sipariş durumu güncellenirken hata:", error);
    res.status(500).json({ message: "Sipariş durumu güncellenemedi" });
  }
}; 