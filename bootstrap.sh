#!/bin/sh

# Securiy group for Tsunami Server : TCP 46224
# Security group for Tsunami Client : UDP 46224

# packages to install
yum install -y gcc gcc-cpp autoconf automake git

# download source code
cd /usr/local
git clone https://github.com/sebsto/tsunami-udp.git

# compile
cd tsunami-udp
make

