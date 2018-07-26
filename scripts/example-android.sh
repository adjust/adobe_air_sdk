#!/usr/bin/env bash

set -e

# Get the current directory (/scripts/ directory)
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Traverse up to get to the root directory
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
EXAMPLE_DIR=example
EXT_DIR=ext/android
VERSION=`cat ${ROOT_DIR}/VERSION`

MAIN_FILE=Main.as
SAMPLE_APP_XML_FILE=Main-app.xml
KEYSTORE_FILE=`cd ${ROOT_DIR}/${EXAMPLE_DIR}; find . -name "*.pfx" -print` # Get any keystore file with extension .pfx

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

cd ${ROOT_DIR}

echo -e "${GREEN}>>> Removing ANE file from example app ${NC}"
rm -rfv ${EXAMPLE_DIR}/lib/Adjust-*.*.*.ane

echo -e "${GREEN}>>> Removing ANE file from root dir ${NC}"
rm -rfv Adjust*.ane

echo -e "${GREEN}>>> Building ANE ${NC}"
${SCRIPTS_DIR}/build-sdk-ane.sh

echo -e "${GREEN}>>> Copying ANE to example app ${NC}"
mkdir -p ${EXAMPLE_DIR}/lib
cp -v Adjust-${VERSION}.ane ${EXAMPLE_DIR}/lib/

echo -e "${GREEN}>>> Running amxmlc ${NC}"
cd ${EXAMPLE_DIR}
amxmlc -external-library-path+=lib/Adjust-${VERSION}.ane -output=Main.swf -- ${MAIN_FILE}

echo -e "${GREEN}>>> Checking if keystore exists ${NC}"
if [ ! -f "${KEYSTORE_FILE}" ]; then
    echo -e "${GREEN}>>> Keystore file does not exist; creating one with password [pass] ${NC}"
    adt -certificate -validityPeriod 25 -cn SelfSigned 1024-RSA sampleCert.pfx pass
    echo -e "${GREEN}>>> Keystore file created ${NC}"
fi

echo -e "${GREEN}>>> Keystore file exists ${NC}"

echo -e "${GREEN}>>> Packaging APK file. Password will be entered automatically ${NC}"
echo "pass" | adt -package -target apk-debug -storetype pkcs12 -keystore sampleCert.pfx Main.apk Main-app.xml Main.swf -extdir lib

echo -e "${GREEN}>>> Running adb uninstall ${NC}"
adb uninstall air.com.adjust.examples || true

echo -e "${GREEN}>>> APK file created. Running ADB install ${NC}"
adb install -r Main.apk

echo -e "${GREEN}>>> ADB installed ${NC}"
