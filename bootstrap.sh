#!/bin/sh

# Securiy group for Tsunami Server : TCP 46224
# Security group for Tsunami Client : UDP 46224

# packages to install
yum upgrade -y
yum install -y gcc gcc-cpp autoconf automake git

# download source code
cd /usr/local
git clone https://github.com/sebsto/tsunami-udp.git

# update build number
cd tsunami-udp
TSUNAMI_VERSION=`cat include/tsunami-cvs-buildnr.h  | grep TSUNAMI_CVS_BUILDNR | cut -f 2 -d "\""`
OLD_BUILD_NUMBER=`echo $TSUNAMI_VERSION | cut -f 4 -d " "`
let BUILD_NUMBER=OLD_BUILD_NUMBER+1
sed -e "/TSUNAMI_CVS_BUILDNR/s/$OLD_BUILD_NUMBER/$BUILD_NUMBER/" include/tsunami-cvs-buildnr.h > include/tsunami-cvs-buildnr.h.NEW
mv include/tsunami-cvs-buildnr.h.NEW include/tsunami-cvs-buildnr.h

# compile
make

