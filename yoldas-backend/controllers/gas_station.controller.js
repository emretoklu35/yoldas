const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

// İstasyon ekle
exports.addGasStation = async (req, res) => {
  try {
    const { placeId, name, latitude, longitude, address } = req.body;
    
    console.log('İstasyon ekleme isteği:', { placeId, name, latitude, longitude, address });

    // Önce bu place_id ile bir istasyon var mı kontrol et
    const existingStation = await prisma.gasStation.findUnique({
      where: { placeId }
    });

    if (existingStation) {
      console.log('İstasyon zaten mevcut:', existingStation);
      return res.status(200).json(existingStation);
    }

    // Yeni istasyon oluştur
    const station = await prisma.gasStation.create({
      data: {
        placeId,
        name,
        latitude,
        longitude,
        address
      }
    });

    console.log('Yeni istasyon oluşturuldu:', station);
    res.status(201).json(station);
  } catch (error) {
    console.error("İstasyon eklenirken hata:", error);
    res.status(500).json({ 
      error: "İstasyon eklenemedi.",
      details: error.message 
    });
  }
};

// Yakındaki istasyonları getir
exports.getNearbyGasStations = async (req, res) => {
  try {
    // Kullanıcının konumunu al (şimdilik tüm istasyonları getir)
    const stations = await prisma.gasStation.findMany({
      orderBy: {
        name: 'asc'
      }
    });
    
    res.json(stations);
  } catch (error) {
    console.error("İstasyonlar getirilirken hata:", error);
    res.status(500).json({ 
      error: "İstasyonlar getirilemedi.",
      details: error.message 
    });
  }
};

  exports.findMany = async (req, res) => {
  try {
    // get all
    const stations = await prisma.gasStation.findMany();
    
    res.json(stations);
  } catch (error) {
    console.error("İstasyonlar getirilirken hata:", error);
    res.status(500).json({ 
      error: "İstasyonlar getirilemedi.",
      details: error.message 
    });
  }
}; 