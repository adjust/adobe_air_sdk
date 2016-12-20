#!/usr/bin/env bash

# Get the current directory (ext/iOS/)
OUT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SRC_DIR=src/AdjustExtension
SDK_DIR=sdk

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

# cd to the called directory to be able to run the script from anywhere
cd $(dirname $0) 
cd ${OUT_DIR}

echo -e "${GREEN}>>> iOS build script: Remove existing framework ${NC}"
cd ${SDK_DIR}
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

echo -e "${GREEN}>>> iOS build script: Copying generated framework to ${OUTDIR} ${NC}"
cd ${OUT_DIR}
cp -R ${SDK_DIR}/AdjustSdk.framework ${SRC_DIR}/include/Adjust/
cp -R ${SDK_DIR}/AdjustSdk.framework ${OUT_DIR}
rm -rf ${SDK_DIR}/AdjustSdk.framework
cd ${SRC_DIR}; xcodebuild CONFIGURATION_BUILD_DIR=${OUT_DIR};

echo -e "${GREEN}>>> iOS build script: Complete ${NC}"
