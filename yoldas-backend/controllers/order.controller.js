const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// Kullanıcının siparişlerini getir
exports.getUserOrders = async (req, res) => {
  try {
    console.log('Kullanıcı ID:', req.user.id); // Kullanıcı ID'sini logla
    
    const userId = req.user.id;
    const orders = await prisma.order.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' }
    });
    
    console.log('Bulunan siparişler:', orders); // Siparişleri logla
    res.json(orders);
  } catch (error) {
    console.error("Siparişler getirilirken hata:", error);
    res.status(500).json({ 
      error: "Siparişler getirilemedi.",
      details: error.message 
    });
  }
};

// Yeni sipariş oluştur
exports.createOrder = async (req, res) => {
  try {
    const userId = req.user.id;
    const { serviceType, address, totalAmount, deliveryTime, cardNumber, cardHolder } = req.body;

    console.log('Yeni sipariş isteği:', { userId, serviceType, address, totalAmount, deliveryTime, cardNumber, cardHolder });

    const order = await prisma.order.create({
      data: {
        userId,
        serviceType,
        status: "pending",
        address,
        deliveryTime,
        cardNumber,
        cardHolder,
        totalAmount
      }
    });

    console.log('Oluşturulan sipariş:', order);
    res.status(201).json(order);
  } catch (error) {
    console.error("Sipariş oluşturulurken hata:", error);
    res.status(500).json({ 
      error: "Sipariş oluşturulamadı.",
      details: error.message 
    });
  }
}; 