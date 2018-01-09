#!/usr/bin/env bash

# Get the current directory (/scripts/ directory)
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Traverse up to get to the root directory
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
EXAMPLE_DIR=example
EXT_DIR=ext/android
VERSION=`cat ${ROOT_DIR}/VERSION`

MAIN_FILE=Main.as
EXAMPLE_APP_XML_FILE=Main-app.xml
KEYSTORE_FILE=`cd ${EXAMPLE_DIR}; find . -name "*.pfx" -print` # Get any keystore file with extension .pfx

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

cd ${ROOT_DIR}

echo -e "${GREEN}>>> Removing ANE file from example app ${NC}"
rm -rfv ${EXAMPLE_DIR}/lib/Adjust-*.*.*.ane

echo -e "${GREEN}>>> Removing ANE file from root dir ${NC}"
rm -rfv Adjust*.ane

echo -e "${GREEN}>>> Building ANE ${NC}"
${SCRIPTS_DIR}/build.sh

echo -e "${GREEN}>>> Copying ANE to example app ${NC}"
mkdir -p ${EXAMPLE_DIR}/lib
cp -v Adjust-${VERSION}.ane ${EXAMPLE_DIR}/lib/

echo -e "${GREEN}>>> Running amxmlc ${NC}"
cd ${EXAMPLE_DIR}
amxmlc -external-library-path+=lib/Adjust-${VERSION}.ane -output=Main.swf -- ${MAIN_FILE}

echo -e "${GREEN}>>> Packaging IPA file${NC}"
echo | adt -package -target ipa-debug -provisioning-profile ${DEV_ADOBE_PROVISIONING_PROFILE_PATH} -storetype pkcs12 -keystore ${KEYSTORE_FILE_PATH} Main.ipa ${EXAMPLE_APP_XML_FILE} Main.swf -extdir lib

echo -e "${GREEN}>>> IPA file created. ${NC}"
