#!/usr/bin/env bash

# Get the current directory (ext/Android/)
OUT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR=src/AdjustExtension
JAR_IN_DIR=src/AdjustExtension/extension/build/outputs
ORIGINAL_SDK_DIR=sdk/Adjust/adjust/src/main/java/com/adjust/sdk
EXTENSION_DIR=src/AdjustExtension/extension/src/main/java/com/adjust/sdk

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

# cd to the called directory to be able to run the script from anywhere
cd $(dirname $0) 
cd ${OUT_DIR}

cd ${EXTENSION_DIR}
mv AdjustActivity.java AdjustExtension.java AdjustFunction.java AdjustContext.java ..
rm -r *
mv ../Adjust*.java .

# Copy all files from ext/android/sdk towards ext/android/src/AdjustExtension/extension/src/main/java/com/adjust/sdk/
cd ${OUT_DIR}/${ORIGINAL_SDK_DIR}
cp -rv * ${OUT_DIR}/${EXTENSION_DIR}

echo -e "${GREEN}>>> Android build script: Running Gradle tasks: clean clearJar makeJar ${NC}"
cd ${OUT_DIR}/${BUILD_DIR}; ./gradlew clean clearJar makeJar

echo -e "${GREEN}>>> Android build script: Copy JAR to ${OUT_DIR} ${NC}"
cd ${OUT_DIR}
cp ${JAR_IN_DIR}/adjust-android.jar ${OUT_DIR}

# echo -e "${GREEN}>>> Android build script: remove unneeded Javadoc and sources JARs ${NC}"
# rm ${OUT_DIR}/*-javadoc.jar;
# rm ${OUT_DIR}/*-sources.jar;

echo -e "${GREEN}>>> Android build script: Rename to Adjust.jar ${NC}"
mv ${OUT_DIR}/adjust-android.jar ${OUT_DIR}/Adjust.jar

echo -e "${GREEN}>>> Android build script: Complete ${NC}"
