-- AlterTable
ALTER TABLE `Order` ADD COLUMN `gasStationId` INTEGER NULL;

-- AddForeignKey
ALTER TABLE `Order` ADD CONSTRAINT `Order_gasStationId_fkey` FOREIGN KEY (`gasStationId`) REFERENCES `gas_stations`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
