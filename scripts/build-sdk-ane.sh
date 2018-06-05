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
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
SOURCE_DIR=src
BUILD_DIR=build
EXT_DIR=ext

# Tools and commands parts
ADT=${AIR_SDK_PATH}/bin/adt
COMPC=${AIR_SDK_PATH}/bin/compc
COMPC_CLASSES="com.adjust.sdk.Adjust com.adjust.sdk.LogLevel com.adjust.sdk.Environment com.adjust.sdk.AdjustConfig com.adjust.sdk.AdjustAttribution com.adjust.sdk.AdjustEventSuccess com.adjust.sdk.AdjustEventFailure com.adjust.sdk.AdjustEvent com.adjust.sdk.AdjustSessionSuccess com.adjust.sdk.AdjustSessionFailure com.adjust.sdk.AdjustTestOptions"
VERSION=`cat ${ROOT_DIR}/VERSION`

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Running compc ... ${NC}"
cd ${ROOT_DIR}
mkdir -p ${BUILD_DIR}/default
${COMPC} -source-path default/src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -directory=true -output ${BUILD_DIR}/default
rm -rf ${BUILD_DIR}/default/catalog.xml
echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Running Android and iOS build scripts ... ${NC}"
${EXT_DIR}/android/build.sh release
${EXT_DIR}/ios/build.sh
echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Copying generated files to ${BUILD_DIR} ... ${NC}"
cd ${ROOT_DIR}
mkdir -p ${BUILD_DIR}/Android
mkdir -p ${BUILD_DIR}/iOS
mkdir -p ${BUILD_DIR}/Android-x86
mkdir -p ${BUILD_DIR}/iOS-x86
cp -vR ${EXT_DIR}/Android/*.jar ${BUILD_DIR}/Android
cp -vR ${EXT_DIR}/iOS/*.a ${BUILD_DIR}/iOS
cp -vR ${EXT_DIR}/iOS/*.framework ${BUILD_DIR}/iOS
cp -vR ${EXT_DIR}/Android/*.jar ${BUILD_DIR}/Android-x86
cp -vR ${EXT_DIR}/iOS/*.a ${BUILD_DIR}/iOS-x86
cp -vR ${EXT_DIR}/iOS/*.framework ${BUILD_DIR}/iOS-x86
echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Making SWC file ... ${NC}"
mkdir -p ${BUILD_DIR}
${COMPC} -source-path src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -output ${BUILD_DIR}/Adjust.swc
echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Running ADT and finalizing the ANE file generation ... ${NC}"
unzip -d ${BUILD_DIR}/Android -qq -o ${BUILD_DIR}/Adjust.swc -x catalog.xml
unzip -d ${BUILD_DIR}/iOS -qq -o ${BUILD_DIR}/Adjust.swc -x catalog.xml
unzip -d ${BUILD_DIR}/Android-x86 -qq -o ${BUILD_DIR}/Adjust.swc -x catalog.xml
unzip -d ${BUILD_DIR}/iOS-x86 -qq -o ${BUILD_DIR}/Adjust.swc -x catalog.xml
cp -af ${SOURCE_DIR}/platformoptions.xml ${BUILD_DIR}/iOS/
cp -af ${SOURCE_DIR}/platformoptions.xml ${BUILD_DIR}/iOS-x86/
cp -af ${SOURCE_DIR}/extension.xml ${BUILD_DIR}/extension.xml
cd ${BUILD_DIR}; ${ADT} -package -target ane ../Adjust-${VERSION}.ane extension.xml -swc Adjust.swc -platform Android-ARM -C Android . -platform Android-x86 -C Android-x86 . -platform iPhone-ARM -C iOS . -platformoptions iOS/platformoptions.xml -platform iPhone-x86 -C iOS-x86 . -platform default -C default .
echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-SDK-ANE]:${GREEN} Script completed! ${NC}"

# ======================================== #
