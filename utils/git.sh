#!/bin/sh

cd utils

source ../env/compile.env
source ../env/database.env

if [ ! -d "../sources/SkyFire_548" ]; then
   cd ../sources
   git clone $GIT_URL_SOURCE SkyFire_548
else
   cd ../sources/SkyFire_548
   git config --global --add safe.directory .
   git pull
fi