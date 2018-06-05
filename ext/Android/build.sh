#!/usr/bin/env bash

# ======================================== #

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# ======================================== #

# Script usage hint
if [ $# -ne 1 ]; then
    echo $0: "usage: ./build.sh [debug || release]"
    exit 1
fi

# ======================================== #

BUILD_TYPE=$1

# Set directories of interest for the script
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"
EXT_DIR=ext/android
BUILD_DIR=src/AdjustExtension
JAR_IN_DIR=src/AdjustExtension/extension/build/outputs
EXTENSION_SOURCE_DIR=src/AdjustExtension/extension/src/main/java/com/adjust/sdk
SDK_SOURCE_DIR=sdk/Adjust/adjust/src/main/java/com/adjust/sdk

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Removing all files not related to Adjust extension ... ${NC}"
cd ${ROOT_DIR}/${EXT_DIR}/${EXTENSION_SOURCE_DIR}
mv -v AdjustActivity.java AdjustExtension.java AdjustFunction.java AdjustContext.java ..
rm -rv *
mv -v ../Adjust*.java .
echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Copying files from ${SDK_SOURCE_DIR} to ${EXTENSION_SOURCE_DIR} ... ${NC}"
cd ${ROOT_DIR}/${EXT_DIR}/${SDK_SOURCE_DIR}
cp -rv * ${ROOT_DIR}/${EXT_DIR}/${EXTENSION_SOURCE_DIR}
echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

cd ${ROOT_DIR}/${EXT_DIR}/${BUILD_DIR}
if [ "$BUILD_TYPE" == "debug" ]; then
	echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Running Gradle task: makeDebugJar ... ${NC}"
    ./gradlew clean makeDebugJar
    echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Done! ${NC}"

elif [ "$BUILD_TYPE" == "release" ]; then
    echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Running Gradle task: makeReleaseJar ... ${NC}"
    ./gradlew clean makeReleaseJar
    echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Done! ${NC}"
fi

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Moving generated JAR from ${JAR_IN_DIR} to ${EXT_DIR} ... ${NC}"
cd ${ROOT_DIR}/${EXT_DIR}
cp -v ${JAR_IN_DIR}/adjust-android.jar ${ROOT_DIR}/${EXT_DIR}
echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][BUILD-ANDROID]:${GREEN} Script completed! ${NC}"

# ======================================== #