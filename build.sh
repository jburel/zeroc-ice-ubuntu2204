#!/bin/sh

set -eux

ICE_VERSION=${1:-"3.6.5"}
BUILD=${BRANCH_NAME:-dev}
TARGET_NAME=ice-$ICE_VERSION-$BUILD

export CPPFLAGS="-Wno-deprecated-declarations -Wno-unused-result -Wno-register"
export CFLAGS=-"Wno-deprecated"

# Build ice cpp from source
wget -q https://github.com/zeroc-ice/ice/archive/v$ICE_VERSION.tar.gz
tar xzf v$ICE_VERSION.tar.gz
cd ice-$ICE_VERSION/cpp
patch -u src/IceUtil/Thread.cpp -i /patch

# Apply patch


make --silent prefix=/opt/$TARGET_NAME
make install --silent prefix=/opt/$TARGET_NAME

tar -zcf /dist/$TARGET_NAME-ubuntu2204-amd64.tar.gz -C /opt $TARGET_NAME

# Zeroc IcePy
# TODO: is it possible to rename the wheel to indicate it's only for Ubuntu?
pip3 download "zeroc-ice==$ICE_VERSION"
tar -zxf "zeroc-ice-$ICE_VERSION.tar.gz"
cd "zeroc-ice-$ICE_VERSION"
ls
python3 setup.py bdist_wheel

cp dist/* /dist/
# rename so it is in the list of supported for pip
mv /dist/zeroc_ice-3.6.5-cp310-cp310-linux_x86_64.whl /dist/zeroc_ice-3.6.5-cp310-cp310-linux_aarch64.whl
