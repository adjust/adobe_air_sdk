#!/usr/bin/env bash

set -e

# Get the current directory (ext/ios/)
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Traverse up to get to the root directory
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"

SRC_DIR=src/AdjustExtension
SDK_DIR=sdk
EXT_DIR=ext/ios

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

# cd to the called directory to be able to run the script from anywhere
cd ${ROOT_DIR}

echo -e "${GREEN}>>> iOS build script: Remove existing framework ${NC}"
cd ${ROOT_DIR}/${EXT_DIR}/${SDK_DIR}
rm -rfv Frameworks/Static/*;

echo -e "${GREEN}>>> iOS build script: Xcode build and linkage ${NC}"
xcodebuild -target AdjustStatic -configuration Release;
mkdir -p AdjustSdk.framework/tmp;
cp Frameworks/Static/AdjustSdk.framework/Versions/A/Headers/* AdjustSdk.framework/tmp;
cp Frameworks/Static/AdjustSdk.framework/Versions/A/AdjustSdk AdjustSdk.framework/tmp;
mkdir -p AdjustSdk.framework/Headers;
mv AdjustSdk.framework/tmp/*.h AdjustSdk.framework/Headers;
mv AdjustSdk.framework/tmp/AdjustSdk AdjustSdk.framework/AdjustSdk;

echo -e "${GREEN}>>> iOS build script: Cleaning up ${NC}"
rm -rf AdjustSdk.framework/tmp; cd ..;

echo -e "${GREEN}>>> iOS build script: Copying generated framework to ${ROOT_DIR} ${NC}"
cd ${ROOT_DIR}/${EXT_DIR}
cp -R ${SDK_DIR}/AdjustSdk.framework ${SRC_DIR}/include/Adjust/
cp -R ${SDK_DIR}/AdjustSdk.framework ${ROOT_DIR}/${EXT_DIR}
rm -rf ${SDK_DIR}/AdjustSdk.framework
cd ${SRC_DIR}; xcodebuild CONFIGURATION_BUILD_DIR=${ROOT_DIR}/${EXT_DIR};

echo -e "${GREEN}>>> iOS build script: Complete ${NC}"
