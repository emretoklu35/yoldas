-- AlterTable
ALTER TABLE `Order` ADD COLUMN `serviceProviderId` INTEGER NULL;

-- AlterTable
ALTER TABLE `User` ADD COLUMN `gasStationId` INTEGER NULL;

-- AddForeignKey
ALTER TABLE `Order` ADD CONSTRAINT `Order_serviceProviderId_fkey` FOREIGN KEY (`serviceProviderId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `User` ADD CONSTRAINT `User_gasStationId_fkey` FOREIGN KEY (`gasStationId`) REFERENCES `gas_stations`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
