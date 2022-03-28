CREATE DATABASE operationaldb /*\!40100 DEFAULT CHARACTER SET utf8 */;
ALTER USER root@localhost IDENTIFIED VIA unix_socket;
flush privileges;
