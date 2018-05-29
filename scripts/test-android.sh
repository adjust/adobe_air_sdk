#!/usr/bin/env bash

set -e

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# Handle input parameters
POSITIONAL=()
BUILD_PLUGIN=YES
BUILD_TESTING_PLUGIN=YES
DISPLAY_HELP=NO

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --skip-plugin)
            BUILD_PLUGIN=NO
            shift # Past argument
            ;;
        --skip-testing-plugin)
            BUILD_TESTING_PLUGIN=NO
            shift # Past argument
            ;;
        --help)
            DISPLAY_HELP=YES
            shift # Past argument
            ;;
        *)
            POSITIONAL+=("$1") # save it in an array for later
            shift # Past argument
            ;;
    esac
done

set -- "${POSITIONAL[@]}" # Restore positional parameters

# Check for invalid arguments
if [[ -n $1 ]]; then
    echo -e "${RED}[ADJUST][ANE-BUILD-TEST]:${GREEN} Invalid argument! Aborting ... ${NC}"
    exit 0
fi

# Help dialog
if [ "${DISPLAY_HELP}" == YES ]; then
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} test-android.sh script is used to build Adjust SDK and Test ANE for integration tests purpose. ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Make sure that: ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN}     - Test device/simulator is connected and started ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN}     - Test server is running ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Arguments: ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN}     --skip-sdk-plugin: Skips building SDK plugin ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN}     --skip-test-plugin: Skips building SDK test plugin ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN}     --help: Displays help instructions"
    exit 1
fi

# Set directories of interest for the script
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
TEST_APP_DIR=test/app
EXT_DIR=ext/android
TEST_PLUGIN_DIR=test/plugin

# Tools and commands parts
VERSION=`cat ${ROOT_DIR}/VERSION`
MAIN_FILE=Main.as
SAMPLE_APP_XML_FILE=Main-app.xml
KEYSTORE_FILE=`cd ${ROOT_DIR}/${TEST_APP_DIR}; find . -name "*.pfx" -print` # Get any keystore file with extension .pfx

echo -e "${GREEN}>>> Running adb uninstall ${NC}"
adb uninstall air.com.adjust.examples || true

echo -e "${GREEN}>>> Removing ANEs ${NC}"
cd ${ROOT_DIR}
rm -rfv ${TEST_APP_DIR}/lib/Adjust-*.*.*.ane
rm -rfv ${TEST_APP_DIR}/lib/AdjustTest-*.*.*.ane


if [ "$BUILD_PLUGIN" = YES ]; then
    echo -e "${GREEN}>>> Removing Adjust SDK ANE file from root dir ${NC}"
    cd ${ROOT_DIR}
    rm -rfv Adjust-*.*.*.ane

    echo -e "${GREEN}>>> Building Adjust SDK ANE ${NC}"
    cd ${ROOT_DIR}
    ${SCRIPTS_DIR}/ane-build-sdk.sh --skip-ios

    echo -e "${GREEN}>>> Copying Adjust SDK ANE to example app ${NC}"
    mkdir -p ${TEST_APP_DIR}/lib
    cp -v Adjust-${VERSION}.ane ${TEST_APP_DIR}/lib/
fi

if [ "$BUILD_TESTING_PLUGIN" = YES ]; then
    echo -e "${GREEN}>>> Removing Adjust Test ANE file from root dir ${NC}"
    cd ${ROOT_DIR}
    rm -rfv AdjustTest-*.*.*.ane

    echo -e "${GREEN}>>> Building Adjust Test ANE ${NC}"
    cd ${ROOT_DIR}
    ${TEST_PLUGIN_DIR}/ane-build-test.sh --skip-ios

    echo -e "${GREEN}>>> Copying Adjust Test ANE to example app ${NC}"
    cd ${ROOT_DIR}
    mkdir -p ${TEST_APP_DIR}/lib
    cp -v AdjustTest-${VERSION}.ane ${TEST_APP_DIR}/lib/
fi

echo -e "${GREEN}>>> Running amxmlc ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
amxmlc -external-library-path+=lib/Adjust-${VERSION}.ane -external-library-path+=lib/AdjustTest-${VERSION}.ane -output=Main.swf -- ${MAIN_FILE}

echo -e "${GREEN}>>> Checking if keystore exists ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
if [ ! -f "${KEYSTORE_FILE}" ]; then
    echo -e "${GREEN}>>> Keystore file does not exist; creating one with password [pass] ${NC}"
    adt -certificate -validityPeriod 25 -cn SelfSigned 1024-RSA sampleCert.pfx pass
    echo -e "${GREEN}>>> Keystore file created ${NC}"
fi

echo -e "${GREEN}>>> Keystore file exists ${NC}"

echo -e "${GREEN}>>> Packaging APK file. Password will be entered automatically ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
echo "pass" | adt -package -target apk-debug -storetype pkcs12 -keystore sampleCert.pfx Main.apk Main-app.xml Main.swf -extdir lib

echo -e "${GREEN}>>> APK file created. Running ADB install ${NC}"
adb install -r Main.apk

echo -e "${GREEN}>>> ADB installed. Running app ${NC}"

adb shell monkey -p air.com.adjust.examples 1
