#!/usr/bin/env bash

set -e

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# Get the root directory
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"

# Set directories of interest for the script
SRC_DIR=test/plugin/ios/src/AdjustTestExtension
TEST_LIBRARY_PROJECT_DIR=ext/iOS/sdk/AdjustTests/AdjustTestLibrary
FRAMEWORKS_DIR=ext/iOS/sdk/Frameworks/Static

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Removing all test plugin native binaries ... ${NC}"
cd ${ROOT_DIR}/${SRC_DIR}
rm -rfv AdjustTestLibrary.framework
rm -rfv libAdjustTestExtension.a
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Done! ${NC}"

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Building test library static framework target ... ${NC}"
cd ${ROOT_DIR}/${TEST_LIBRARY_PROJECT_DIR}
xcodebuild -target AdjustTestLibraryStatic -configuration Release clean build
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Done! ${NC}"

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Removing symlinks inside of framework ... ${NC}"
cd ${ROOT_DIR}/${SRC_DIR}
cp -Rv ${ROOT_DIR}/${FRAMEWORKS_DIR}/AdjustTestLibrary.framework .
cd AdjustTestLibrary.framework
# Remove any existing symlinks
rm -rfv AdjustTestLibrary
rm -rfv Headers

# Move library and headers
mv -v Versions/A/AdjustTestLibrary .
mv -v Versions/A/Headers .

# Remove Versions folder
rm -rfv Versions
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Done! ${NC}"

# Why?
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Building .a library ... ${NC}"
cd ${ROOT_DIR}/${SRC_DIR}
xcodebuild CONFIGURATION_BUILD_DIR=${ROOT_DIR}/ext/iOS
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Done! ${NC}"

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Moving .a library to ${ROOT_DIR}/${SRC_DIR} ... ${NC}"
cd ${ROOT_DIR}
mv -v ext/iOS/libAdjustTestExtension.a ${ROOT_DIR}/${SRC_DIR}
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Done! ${NC}"

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-IOS]:${GREEN} Script completed! ${NC}"
