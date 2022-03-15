CREATE DATABASE operationaldb /*\!40100 DEFAULT CHARACTER SET utf8 */;
UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User='root';
flush privileges;
