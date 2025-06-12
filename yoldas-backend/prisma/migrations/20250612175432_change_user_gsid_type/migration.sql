-- DropForeignKey
ALTER TABLE `User` DROP FOREIGN KEY `User_gasStationId_fkey`;

-- AlterTable
ALTER TABLE `User` MODIFY `gasStationId` VARCHAR(191) NULL;

-- AddForeignKey
ALTER TABLE `User` ADD CONSTRAINT `User_gasStationId_fkey` FOREIGN KEY (`gasStationId`) REFERENCES `gas_stations`(`place_id`) ON DELETE SET NULL ON UPDATE CASCADE;
