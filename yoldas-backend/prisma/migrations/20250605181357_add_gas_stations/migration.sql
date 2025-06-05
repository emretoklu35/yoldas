-- CreateTable
CREATE TABLE `gas_stations` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `place_id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `latitude` DOUBLE NOT NULL,
    `longitude` DOUBLE NOT NULL,
    `address` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `gas_stations_place_id_key`(`place_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
