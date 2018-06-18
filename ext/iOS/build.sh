#!/usr/bin/env bash

set -e

# ======================================== #

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# ======================================== #

# Set directories of interest for the script
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"
SRC_DIR=src/AdjustExtension
SDK_DIR=sdk
EXT_DIR=ext/ios

# ======================================== #

# Switch to root directory so to be able to run script from anywhere
cd ${ROOT_DIR}

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-IOS]:${GREEN} Removing existing framework ... ${NC}"
cd ${ROOT_DIR}/${EXT_DIR}/${SDK_DIR}
rm -rfv Frameworks/Static/*;
echo -e "${CYAN}[ADJUST][BUILD-IOS]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-IOS]:${GREEN} Running Xcode release build and symlink removal ... ${NC}"
xcodebuild -target AdjustStatic -configuration Release;
mkdir -p AdjustSdk.framework/tmp;
cp Frameworks/Static/AdjustSdk.framework/Versions/A/Headers/* AdjustSdk.framework/tmp;
cp Frameworks/Static/AdjustSdk.framework/Versions/A/AdjustSdk AdjustSdk.framework/tmp;
mkdir -p AdjustSdk.framework/Headers;
mv AdjustSdk.framework/tmp/*.h AdjustSdk.framework/Headers;
mv AdjustSdk.framework/tmp/AdjustSdk AdjustSdk.framework/AdjustSdk;
echo -e "${CYAN}[ADJUST][BUILD-IOS]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-IOS]:${GREEN} Cleaning up ... ${NC}"
rm -rf AdjustSdk.framework/tmp; cd ..;
echo -e "${CYAN}[ADJUST][BUILD-IOS]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-IOS]:${GREEN} Copying generated framework to ${ROOT_DIR} ... ${NC}"
cd ${ROOT_DIR}/${EXT_DIR}
cp -R ${SDK_DIR}/AdjustSdk.framework ${SRC_DIR}/include/Adjust/
cp -R ${SDK_DIR}/AdjustSdk.framework ${ROOT_DIR}/${EXT_DIR}
rm -rf ${SDK_DIR}/AdjustSdk.framework
cd ${SRC_DIR}; xcodebuild CONFIGURATION_BUILD_DIR=${ROOT_DIR}/${EXT_DIR};
echo -e "${CYAN}[ADJUST][BUILD-IOS]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-IOS]:${GREEN} Script completed! ${NC}"

# ======================================== #
