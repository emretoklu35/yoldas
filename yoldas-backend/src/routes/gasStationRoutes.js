const express = require('express');
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Benzin istasyonu ekleme
router.post('/add', async (req, res) => {
    try {
        const { placeId, name, latitude, longitude, address } = req.body;
        
        // Önce bu istasyon var mı kontrol et
        const existingStation = await prisma.gasStation.findUnique({
            where: { placeId }
        });
        
        if (existingStation) {
            return res.status(200).json({ message: 'Bu benzin istasyonu zaten kayıtlı' });
        }
        
        // Yeni istasyon ekle
        const newStation = await prisma.gasStation.create({
            data: {
                placeId,
                name,
                latitude,
                longitude,
                address
            }
        });
        
        res.status(201).json({
            success: true,
            data: newStation
        });
    } catch (error) {
        console.error('Benzin istasyonu eklenirken hata:', error);
        res.status(500).json({
            success: false,
            error: 'Benzin istasyonu eklenirken bir hata oluştu'
        });
    }
});

module.exports = router; 