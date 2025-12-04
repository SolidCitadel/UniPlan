CREATE DATABASE IF NOT EXISTS uniplan_user;
CREATE DATABASE IF NOT EXISTS uniplan_planner;
CREATE DATABASE IF NOT EXISTS uniplan_catalog;

CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON uniplan_user.* TO 'user'@'%';
GRANT ALL PRIVILEGES ON uniplan_planner.* TO 'user'@'%';
GRANT ALL PRIVILEGES ON uniplan_catalog.* TO 'user'@'%';
FLUSH PRIVILEGES;
