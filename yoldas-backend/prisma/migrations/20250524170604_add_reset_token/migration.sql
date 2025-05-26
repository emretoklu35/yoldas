-- AlterTable
ALTER TABLE `User` ADD COLUMN `resetToken` VARCHAR(191) NULL,
    ADD COLUMN `resetTokenExpiry` DATETIME(3) NULL,
    MODIFY `role` VARCHAR(191) NOT NULL DEFAULT 'user';
