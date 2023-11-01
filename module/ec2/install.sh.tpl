#!/bin/bash -ex
sudo apt update
sudo wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx.service
sudo systemctl status nginx.service
