#!/bin/bash

sudo apt install haproxy -y
sudo mv /tmp/haproxy.cfg /etc/haproxy/haproxy.cfg
cp /usr/lib/systemd/system/haproxy.service /etc/systemd/system/haproxy.service
systemctl enable haproxy
systemctl restart haproxy
