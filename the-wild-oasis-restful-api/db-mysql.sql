-- ----------------------------
-- 1、cabins
-- ----------------------------
DROP TABLE IF EXISTS cabins;
CREATE TABLE cabins
(
    `id`            BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each cabin',
    `name`          VARCHAR(255)   DEFAULT NULL COMMENT 'Name of the cabin',
    `max_capacity`  INT            DEFAULT NULL COMMENT 'Maximum number of guests the cabin can accommodate',
    `regular_price` DECIMAL(10, 2) DEFAULT NULL COMMENT 'Regular price per night for the cabin',
    `discount`      DECIMAL(10, 2) DEFAULT NULL COMMENT 'Discount amount or percentage applied to the regular price',
    `description`   TEXT           DEFAULT NULL COMMENT 'Detailed description of the cabin',
    `image`         VARCHAR(255)   DEFAULT NULL COMMENT 'URL or path to the cabins image ',
    `extra_charges` DECIMAL(10, 2) DEFAULT NULL COMMENT ' Any additional charges that may apply ',
    `del_flag`      TINYINT(1) NOT NULL DEFAULT '0' COMMENT ' Flag indicating if the record has been logically deleted ',
    `create_by`     VARCHAR(64)    DEFAULT NULL COMMENT ' User who created the record ',
    `create_time`   DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT ' Timestamp when the record was created ',
    `update_by`     VARCHAR(64)    DEFAULT NULL COMMENT ' User who last updated the record ',
    `update_time`   DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ' Timestamp of the last update to the record ',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT=' Table storing information about cabins ';


-- ----------------------------
-- 2、guests
-- ----------------------------
DROP TABLE IF EXISTS guests;
CREATE TABLE guests
(
    `id`           BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each guest',
    `full_name`    VARCHAR(255) DEFAULT NULL COMMENT 'Full name of the guest',
    `email`        VARCHAR(255) DEFAULT NULL COMMENT 'Email address of the guest',
    `national_id`  VARCHAR(255) DEFAULT NULL COMMENT 'National ID or passport number of the guest',
    `nationality`  VARCHAR(255) DEFAULT NULL COMMENT 'Nationality of the guest',
    `country_flag` VARCHAR(255) DEFAULT NULL COMMENT 'URL or path to the country flag image',
    `del_flag`     TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Flag indicating if the record has been logically deleted',
    `create_by`    VARCHAR(64)  DEFAULT NULL COMMENT 'User who created the record',
    `create_time`  DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when the record was created',
    `update_by`    VARCHAR(64)  DEFAULT NULL COMMENT 'User who last updated the record',
    `update_time`  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp of the last update to the record',
    PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='Table storing information about guests';


-- ----------------------------
-- 3、settings
-- ----------------------------
DROP TABLE IF EXISTS settings;
CREATE TABLE settings
(
    `id`                     BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each setting',
    `min_booking_length`     INT            DEFAULT NULL COMMENT 'Minimum number of nights for a booking',
    `max_booking_length`     INT            DEFAULT NULL COMMENT 'Maximum number of nights for a booking',
    `max_guests_per_booking` INT            DEFAULT NULL COMMENT 'Maximum number of guests allowed per booking',
    `breakfast_price`        DECIMAL(10, 2) DEFAULT NULL COMMENT 'Price for including breakfast in the booking',
    `del_flag`               TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Flag indicating if the record has been logically deleted',
    `create_by`              VARCHAR(64)    DEFAULT NULL COMMENT 'User who created the record',
    `create_time`            DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp when the record was created',
    `update_by`              VARCHAR(64)    DEFAULT NULL COMMENT 'User who last updated the record',
    `update_time`            DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp of the last update to the record',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='Table storing system settings for bookings';


-- ----------------------------
-- 4、bookings
-- ----------------------------
DROP TABLE IF EXISTS bookings;
CREATE TABLE bookings
(
    `id`            BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each booking',
    `num_nights`    INT            DEFAULT NULL COMMENT 'Number of nights booked',
    `num_guests`    INT            DEFAULT NULL COMMENT 'Number of guests',
    `start_date`    DATETIME       DEFAULT NULL COMMENT 'Booking start date',
    `end_date`      DATETIME       DEFAULT NULL COMMENT 'Booking end date',
    `cabin_price`   DECIMAL(10, 2) DEFAULT NULL COMMENT 'Price for the cabin per night',
    `extra_price`   DECIMAL(10, 2) DEFAULT NULL COMMENT 'Extra charges (if any)',
    `total_price`   DECIMAL(10, 2) GENERATED ALWAYS AS ((num_nights * cabin_price) + extra_price) STORED COMMENT 'Total price of the booking',
    `status`        VARCHAR(20)    DEFAULT NULL COMMENT 'Booking status',
    `has_breakfast` TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Breakfast included',
    `is_paid`       TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Payment status',
    `observations`  TEXT           DEFAULT NULL COMMENT 'Additional observations',
    `del_flag`      TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Deletion flag',
    `cabin_id`      BIGINT(20) DEFAULT NULL COMMENT 'Foreign key to cabins',
    `guest_id`      BIGINT(20) DEFAULT NULL COMMENT 'Foreign key to guests',
    `create_by`     VARCHAR(64)    DEFAULT NULL COMMENT 'Created by user',
    `create_time`   DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    `update_by`     VARCHAR(64)    DEFAULT NULL COMMENT 'Updated by user',
    `update_time`   DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update timestamp',
    PRIMARY KEY (id),
    INDEX           idx_cid_gid (`cabin_id`, `guest_id`) USING BTREE,
    INDEX           idx_status (`status`) USING BTREE,
    INDEX           idx_dates (`start_date`, `end_date`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='Table storing booking information';

-- Optionally, add foreign key constraints if you have the related tables:
ALTER TABLE bookings
    ADD CONSTRAINT fk_cabins FOREIGN KEY (`cabin_id`) REFERENCES cabins (`id`);
ALTER TABLE bookings
    ADD CONSTRAINT fk_guests FOREIGN KEY (`guest_id`) REFERENCES guests (`id`);

-- 在现有表上添加外键约束
-- DROP TABLE IF EXISTS bookings;
-- CREATE TABLE bookings
-- (
--     id            BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for each booking',
--     num_nights    INT            DEFAULT NULL COMMENT 'Number of nights booked',
--     num_guests    INT            DEFAULT NULL COMMENT 'Number of guests',
--     start_date    DATETIME       DEFAULT NULL COMMENT 'Booking start date',
--     end_date      DATETIME       DEFAULT NULL COMMENT 'Booking end date',
--     cabin_price   DECIMAL(10, 2) DEFAULT NULL COMMENT 'Price for the cabin per night',
--     extra_price   DECIMAL(10, 2) DEFAULT NULL COMMENT 'Extra charges (if any)',
--     total_price   DECIMAL(10, 2) GENERATED ALWAYS AS ((num_nights * cabin_price) + extra_price) STORED COMMENT 'Total price of the booking',
--     status        VARCHAR(20)    DEFAULT NULL COMMENT 'Booking status',
--     has_breakfast TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Breakfast included',
--     is_paid       TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Payment status',
--     observations  TEXT           DEFAULT NULL COMMENT 'Additional observations',
--     del_flag      TINYINT(1) NOT NULL DEFAULT '0' COMMENT 'Deletion flag',
--     cabin_id      INT            DEFAULT NULL COMMENT 'Foreign key to cabins',
--     guest_id      INT            DEFAULT NULL COMMENT 'Foreign key to guests',
--     create_by     VARCHAR(64)    DEFAULT NULL COMMENT 'Created by user',
--     create_time   DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
--     update_by     VARCHAR(64)    DEFAULT NULL COMMENT 'Updated by user',
--     update_time   DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update timestamp',
--     PRIMARY KEY (id),
--     INDEX         idx_cid_gid (cabin_id, guest_id) USING BTREE,
--     INDEX         idx_status (status) USING BTREE,
--     INDEX         idx_dates (start_date, end_date) USING BTREE,
--     CONSTRAINT fk_cabins FOREIGN KEY (cabin_id) REFERENCES cabins (id),
--     CONSTRAINT fk_guests FOREIGN KEY (guest_id) REFERENCES guests (id)
-- ) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COMMENT='Table storing booking information';


-- 价格字段：cabin_price, extra_price, total_price 改为 DECIMAL(10, 2) 类型，以支持货币计算。
-- total_price 字段：使用 GENERATED ALWAYS AS 创建了一个计算列，这样在插入或更新数据时，总价格会自动计算。
-- 时间戳字段：create_time 和 update_time 使用了 DEFAULT CURRENT_TIMESTAMP 和 ON
-- UPDATE CURRENT_TIMESTAMP，以自动处理时间戳的设置。
-- 索引：保留了原有的索引，并确保使用 INDEX 关键字以提高查询性能。
-- 外键约束：如果存在相关联的 cabins 和 guests 表，可以考虑添加外键约束以确保数据完整性。这里我用注释形式展示了如何添加这些约束。如果您确实有这些表，请取消注释并执行相应的SQL语句。


-- 去掉对 cabins 表的外键约束
-- ALTER TABLE bookings
-- DROP
-- FOREIGN KEY fk_cabins;

-- 去掉对 guests 表的外键约束
-- ALTER TABLE bookings
-- DROP
-- FOREIGN KEY fk_guests;

-- 查找 bookings 表中的所有外键约束 这个查询将返回 bookings 表中所有外键约束的名称及其引用的表和列。
-- SELECT CONSTRAINT_NAME,
--        REFERENCED_TABLE_NAME,
--        REFERENCED_COLUMN_NAME
-- FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
-- WHERE TABLE_NAME = 'bookings'
--   AND CONSTRAINT_SCHEMA = DATABASE();

-- 完整示例
-- 假设你已经知道外键约束的名称，以下是完整的步骤：

-- 去掉对 cabins 表的外键约束：

-- ALTER TABLE bookings
-- DROP
-- FOREIGN KEY fk_cabins;
-- 去掉对 guests 表的外键约束：

-- ALTER TABLE bookings
-- DROP
-- FOREIGN KEY fk_guests;
-- 验证外键约束是否已删除
-- 你可以再次运行查询来验证外键约束是否已被删除：

-- SELECT CONSTRAINT_NAME,
--        REFERENCED_TABLE_NAME,
--        REFERENCED_COLUMN_NAME
-- FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
-- WHERE TABLE_NAME = 'bookings'
--   AND CONSTRAINT_SCHEMA = DATABASE();
-- 如果查询结果中不再包含 fk_cabins 和 fk_guests，则说明外键约束已成功删除。