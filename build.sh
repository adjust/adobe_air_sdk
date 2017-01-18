#!/usr/bin/env bash
#---------- Directories
# Get the current directory (ext/iOS/)
OUT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_DIR=src
BUILD_DIR=build
EXT_DIR=ext

#------------ Commands and misc
ADT=${AIR_SDK_PATH}/bin/adt
COMPC=${AIR_SDK_PATH}/bin/compc
COMPC_CLASSES="com.adjust.sdk.Adjust com.adjust.sdk.LogLevel com.adjust.sdk.Environment com.adjust.sdk.AdjustConfig com.adjust.sdk.AdjustAttribution com.adjust.sdk.AdjustEventSuccess com.adjust.sdk.AdjustEventFailure com.adjust.sdk.AdjustEvent com.adjust.sdk.AdjustSessionSuccess com.adjust.sdk.AdjustSessionFailure"
VERSION=`cat VERSION`

#----------- echo colors
RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

# cd to the called directory to be able to run the script from anywhere
cd $(dirname $0) 
cd ${OUT_DIR}

echo -e "${GREEN}>>> AA build script: BEGIN${NC}"
cd ${OUT_DIR}

#----------- emulator
echo -e "${GREEN}>>> AA build script: running emulator tasks${NC}"
mkdir -p ${BUILD_DIR}/default
${COMPC} -source-path default/src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -directory=true -output ${BUILD_DIR}/default
rm -rf ${BUILD_DIR}/default/catalog.xml

#----------- Run android and iOS build scripts
echo -e "${GREEN}>>> AA build script:  Running Android and iOS build scripts${NC}"
${EXT_DIR}/Android/build.sh
${EXT_DIR}/iOS/build.sh

#----------- Copy generated files to BUILD_DIR
echo -e "${GREEN}>>> AA build script: copying generated files to ${BUILD_DIR} ${NC}"
cd ${OUT_DIR}
mkdir -p ${BUILD_DIR}/Android
cp -v ${EXT_DIR}/Android/*.jar ${BUILD_DIR}/Android
cp -vr ${EXT_DIR}/iOS/*.a ${EXT_DIR}/iOS/*.framework ${BUILD_DIR}/iOS

#------------ Making swc file
echo -e "${GREEN}>>> AA build script:  Making swc file${NC}"
mkdir -p ${BUILD_DIR}
${COMPC} -source-path src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -output ${BUILD_DIR}/Adjust.swc

#------------ Running ADT and finalizing the ANE file 
echo -e "${GREEN}>>> AA build script: Running ADT and finalizing the ANE file ${NC}"
unzip -d ${BUILD_DIR}/Android -qq -o ${BUILD_DIR}/Adjust.swc -x catalog.xml
unzip -d ${BUILD_DIR}/iOS -qq -o ${BUILD_DIR}/Adjust.swc -x catalog.xml
cp -af ${SOURCE_DIR}/platformoptions.xml ${BUILD_DIR}/iOS/
cp -af ${SOURCE_DIR}/extension.xml ${BUILD_DIR}/extension.xml
cd ${BUILD_DIR}; ${ADT} -package -target ane ../Adjust-${VERSION}.ane extension.xml -swc Adjust.swc -platform Android-ARM -C Android . -platform iPhone-ARM -C iOS . -platformoptions iOS/platformoptions.xml -platform default -C default .

echo -e "${GREEN}>>> AA build script: END ${NC}"
