#!/usr/bin/env bash
#---------- Directories
# Get the current directory (/scripts)
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Traverse up to get to the root directory
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
SOURCE_DIR=src
BUILD_DIR=build
EXT_DIR=ext

#------------ Commands and misc
ADT=${AIR_SDK_PATH}/bin/adt
COMPC=${AIR_SDK_PATH}/bin/compc
COMPC_CLASSES="com.adjust.sdk.Adjust com.adjust.sdk.LogLevel com.adjust.sdk.Environment com.adjust.sdk.AdjustConfig com.adjust.sdk.AdjustAttribution com.adjust.sdk.AdjustEventSuccess com.adjust.sdk.AdjustEventFailure com.adjust.sdk.AdjustEvent com.adjust.sdk.AdjustSessionSuccess com.adjust.sdk.AdjustSessionFailure"
VERSION=`cat ${ROOT_DIR}/VERSION`

#----------- echo colors
RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

echo -e "${GREEN}>>> AA build script: BEGIN${NC}"

#----------- 
echo -e "${GREEN}>>> AA build script: running emulator tasks${NC}"
cd ${ROOT_DIR}
mkdir -p ${BUILD_DIR}/default
${COMPC} -source-path default/src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -directory=true -output ${BUILD_DIR}/default
rm -rf ${BUILD_DIR}/default/catalog.xml

#----------- 
echo -e "${GREEN}>>> AA build script:  Running Android and iOS build scripts${NC}"
${EXT_DIR}/android/build.sh release
${EXT_DIR}/ios/build.sh

#----------- 
echo -e "${GREEN}>>> AA build script: copying generated files to ${BUILD_DIR} ${NC}"
cd ${ROOT_DIR}
mkdir -p ${BUILD_DIR}/Android
cp -vr ${EXT_DIR}/Android/*.jar ${BUILD_DIR}/Android
cp -vr ${EXT_DIR}/ios/*.a ${EXT_DIR}/ios/*.framework ${BUILD_DIR}/iOS

#------------ 
echo -e "${GREEN}>>> AA build script:  Making swc file${NC}"
mkdir -p ${BUILD_DIR}
${COMPC} -source-path src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -output ${BUILD_DIR}/Adjust.swc

##------------ 
echo -e "${GREEN}>>> AA build script: Running ADT and finalizing the ANE file ${NC}"
unzip -d ${BUILD_DIR}/Android -qq -o ${BUILD_DIR}/Adjust.swc -x catalog.xml
unzip -d ${BUILD_DIR}/iOS -qq -o ${BUILD_DIR}/Adjust.swc -x catalog.xml
cp -af ${SOURCE_DIR}/platformoptions.xml ${BUILD_DIR}/iOS/
cp -af ${SOURCE_DIR}/extension.xml ${BUILD_DIR}/extension.xml
cd ${BUILD_DIR}; ${ADT} -package -target ane ../Adjust-${VERSION}.ane extension.xml -swc Adjust.swc -platform Android-ARM -C Android . -platform iPhone-ARM -C iOS . -platformoptions iOS/platformoptions.xml -platform default -C default .

echo -e "${GREEN}>>> AA build script: END ${NC}"
