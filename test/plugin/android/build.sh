#!/usr/bin/env bash

set -e

# ======================================== #

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# Set directories of interest for the script
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"
BUILD_DIR=src/AdjustTestExtension
TEST_PLUGIN_DIR=test/plugin/android
JAR_IN_DIR=src/AdjustTestExtension/extension/build/outputs
TEST_LIBRARY_DIR=ext/android/sdk/Adjust/testlibrary/src/main/java/com/adjust/testlibrary
TEST_EXTENSION_DIR=src/AdjustTestExtension/extension/src/main/java/com/adjust/testlibrary

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-ANDROID]:${GREEN} Removing all test plugin native source files except Adobe AIR .java files ... ${NC}"
cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}/${TEST_EXTENSION_DIR}
mv -v AdjustTestExtension.java AdjustTestFunction.java AdjustTestContext.java CommandListener.java ..
rm -rf *
mv -v ../Adjust*.java .
mv -v ../CommandListener.java .
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-ANDROID]:${GREEN} Adding test library native source files ... ${NC}"
cd ${ROOT_DIR}/${TEST_LIBRARY_DIR}
cp -rv * ${ROOT_DIR}/${TEST_PLUGIN_DIR}/${TEST_EXTENSION_DIR}
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-ANDROID]:${GREEN} Starting Gradle tasks: clean makeJar ${NC}"
cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}/${BUILD_DIR}
./gradlew clean makeJar
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-ANDROID]:${GREEN} Copying adjust-android-test.jar to it's destination (${TEST_PLUGIN_DIR}) ... ${NC}"
cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
cp -v ${JAR_IN_DIR}/adjust-android-test.jar .
echo -e "${CYAN}[ADJUST][TEST-PLUGIN-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-PLUGIN-ANDROID]:${GREEN} Script completed! ${NC}"

# ======================================== #
