#!/usr/bin/env bash
SDK_DIR=~/Dev/adobe_air_sdk
SAMPLE_DIR=~/Dev/adobe_air_sdk/sample
MAIN_FILE=Main.as
SAMPLE_APP_XML_FILE=Main-app.xml
VERSION=`cat ${SDK_DIR}/VERSION`
KEYSTORE_FILE=`cd ${SAMPLE_DIR}; find . -name "*.pfx" -print` # Get any keystore file with extension .pfx
RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

set -e

echo -e "${GREEN}>>> Removing ANE file from sample/lib ${NC}"
rm -rfv ${SAMPLE_DIR}/lib/Adjust-${VERSION}.ane

echo -e "${GREEN}>>> Removing ANE file from root dir ${NC}"
rm -rfv ${SDK_DIR}/Adjust*.ane

echo -e "${GREEN}>>> Building ANE for version ${VERSION} ${NC}"

cd ${SDK_DIR}
make -f Makefile
\cp -v Adjust-${VERSION}.ane ${SAMPLE_DIR}/lib/

echo -e "${GREEN}>>> Checking if ANE is built successfully in location: ${SAMPLE_DIR}/lib/Adjust-${VERSION}.ane ${NC}"

if [ ! -f "${SAMPLE_DIR}/lib/Adjust-${VERSION}.ane" ]; then
    echo -e "${RED}>>> Bulding ANE failed ${NC}"
    exit 1
fi

echo -e "${GREEN}>>> ANE built successfully ${NC}"

echo -e "${GREEN}>>> Building sample app ${NC}"
echo -e "${GREEN}>>> Running amxmlc ${NC}"
cd ${SAMPLE_DIR}
amxmlc -external-library-path+=lib/Adjust-${VERSION}.ane -output=Main.swf -- ${MAIN_FILE}

echo -e "${GREEN}>>> Checking if keystore exists ${NC}"
if [ ! -f "${KEYSTORE_FILE}" ]; then
    echo -e "${GREEN}>>> Keystore file does not exist; creating one with password [pass] ${NC}"
    adt -certificate -validityPeriod 25 -cn SelfSigned 1024-RSA sampleCert.pfx pass
    echo -e "${GREEN}>>> Keystore file created ${NC}"
fi

echo -e "${GREEN}>>> Keystore file exists ${NC}"

echo -e "${GREEN}>>> Packaging APK file. Password will enter automatically ${NC}"
echo "pass" | adt -package -target apk-debug -storetype pkcs12 -keystore sampleCert.pfx Main.apk Main-app.xml Main.swf -extdir lib

echo -e "${GREEN}>>> APK file created. Running ADB install ${NC}"
adb install -r Main.apk

echo -e "${GREEN}>>> ADB installed ${NC}"

open -b com.apple.terminal
echo -e "${GREEN}>>> ADB logcat command piped to clipboard ${NC}"

# Pipe adb logcat command to pbcopy for Mac (xclip for Linux)
echo 'adb logcat | grep `adb shell ps | grep adjust | cut -c10-15`' | pbcopy
