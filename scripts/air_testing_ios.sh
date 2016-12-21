#!/usr/bin/env bash

SDK_DIR=~/Dev/adobe_air_sdk
SAMPLE_DIR=~/Dev/adobe_air_sdk/sample
MAIN_FILE=Main.as
SAMPLE_APP_XML_FILE=Main-app.xml
VERSION=`cat ${SDK_DIR}/VERSION`
KEYSTORE_FILE=~/Desktop/Certificates.p12
PROVISIONING_FILE=~/Desktop/adjust_Development.mobileprovision

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

echo -e "${GREEN}>>> Update submodules"
git submodule update --init --recursive

echo -e "${GREEN}>>> Removing ANE file from sample/lib ${NC}"
rm -rfv ${SAMPLE_DIR}/lib/Adjust*.ane

echo -e "${GREEN}>>> Removing ANE file from root dir ${NC}"
rm -rfv ${SDK_DIR}/Adjust*.ane

echo -e "${GREEN}>>> Building ANE for version ${VERSION} ${NC}"

cd ${SDK_DIR}
./build.sh
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
/Applications/AIRSDK_Compiler/bin/amxmlc -external-library-path+=lib/Adjust-${VERSION}.ane -output=Main.swf -- ${MAIN_FILE}

echo -e "${GREEN}>>> Packaging IPA file${NC}"
echo | /Applications/AIRSDK_Compiler/bin/adt -package -target ipa-debug -provisioning-profile ${PROVISIONING_FILE} -storetype pkcs12 -keystore ${KEYSTORE_FILE} Main.ipa ${SAMPLE_APP_XML_FILE} Main.swf -extdir lib

echo -e "${GREEN}>>> IPA file created. ${NC}"
