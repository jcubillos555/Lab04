CREATE DATABASE crud_app;
USE crud_app;
CREATE USER 'jcubillos555'@'%' IDENTIFIED BY 'jcubillos555';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON * . * TO 'jcubillos555'@'%';
FLUSH PRIVILEGES;
alter user 'jcubillos555'@'%' identified with mysql_native_password by 'jcubillos555';
FLUSH PRIVILEGES;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `users` (
  `id` int(11) UNSIGNED NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

ALTER TABLE `users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;