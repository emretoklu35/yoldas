-- DropForeignKey
ALTER TABLE `Order` DROP FOREIGN KEY `Order_gasStationId_fkey`;

-- AlterTable
ALTER TABLE `Order` MODIFY `gasStationId` VARCHAR(191) NULL;

-- AddForeignKey
ALTER TABLE `Order` ADD CONSTRAINT `Order_gasStationId_fkey` FOREIGN KEY (`gasStationId`) REFERENCES `gas_stations`(`place_id`) ON DELETE SET NULL ON UPDATE CASCADE;
