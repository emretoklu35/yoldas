const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

exports.getUserVehicles = async (req, res) => {
  const userId = req.user.id;
  const vehicles = await prisma.vehicle.findMany({
    where: { userId: userId },
  });
  res.json({ vehicles });
};

exports.createVehicle = async (req, res) => {
  const { carName, plate, brand, model } = req.body;
  const userId = req.user.id;
  const vehicle = await prisma.vehicle.create({
    data: { carName, plate, brand, model, userId },
  });
  res.json({ vehicle });
};