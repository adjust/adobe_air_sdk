#!/usr/bin/env bash

# - Build the JAR file
# - Copy the JAR file to the root dir

# End script if one of the lines fails
 set -e

if [ $# -ne 1 ]; then
    echo $0: "usage: ./build.sh [debug || release]"
    exit 1
fi

BUILD_TYPE=$1

# Get the current directory (ext/android/)
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Traverse up to get to the root directory
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"
EXT_DIR=ext/android
BUILD_DIR=src/AdjustExtension
JAR_IN_DIR=src/AdjustExtension/extension/build/outputs
EXTENSION_SOURCE_DIR=src/AdjustExtension/extension/src/main/java/com/adjust/sdk
SDK_SOURCE_DIR=sdk/Adjust/adjust/src/main/java/com/adjust/sdk

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

echo -e "${GREEN}>>> Remove all non-AdjustExtension related files${NC}"
cd ${ROOT_DIR}/${EXT_DIR}/${EXTENSION_SOURCE_DIR}
mv -v AdjustActivity.java AdjustExtension.java AdjustFunction.java AdjustContext.java ..
rm -rv *
mv -v ../Adjust*.java .

echo -e "${GREEN}>>> Copy all files from ${SDK_SOURCE_DIR} to ${EXTENSION_SOURCE_DIR}${NC}"
cd ${ROOT_DIR}/${EXT_DIR}/${SDK_SOURCE_DIR}
cp -rv * ${ROOT_DIR}/${EXT_DIR}/${EXTENSION_SOURCE_DIR}

cd ${ROOT_DIR}/${EXT_DIR}/${BUILD_DIR}
if [ "$BUILD_TYPE" == "debug" ]; then
    echo -e "${GREEN}>>> Running Gradle tasks: makeDebugJar${NC}"
    ./gradlew clean makeDebugJar

elif [ "$BUILD_TYPE" == "release" ]; then
    echo -e "${GREEN}>>> Running Gradle tasks: makeReleaseJar${NC}"
    ./gradlew clean makeReleaseJar
fi

echo -e "${GREEN}>>> Moving the jar from ${JAR_IN_DIR} to ${EXT_DIR} ${NC}"
cd ${ROOT_DIR}/${EXT_DIR}
cp -v ${JAR_IN_DIR}/adjust-android.jar ${ROOT_DIR}/${EXT_DIR}
