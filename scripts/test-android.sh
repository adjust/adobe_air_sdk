#!/usr/bin/env bash

set -e

# ======================================== #

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# ======================================== #

# Handle input parameters
POSITIONAL=()
BUILD_SDK_PLUGIN=YES
BUILD_TEST_PLUGIN=YES
DISPLAY_HELP=NO

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --skip-sdk-plugin)
            BUILD_SDK_PLUGIN=NO
            shift # Past argument
            ;;
        --skip-test-plugin)
            BUILD_TEST_PLUGIN=NO
            shift # Past argument
            ;;
        --help)
            DISPLAY_HELP=YES
            shift # Past argument
            ;;
        *)
            POSITIONAL+=("$1") # Save it in an array for later
            shift # Past argument
            ;;
    esac
done

set -- "${POSITIONAL[@]}" # Restore positional parameters

# ======================================== #

# Check for invalid arguments
if [[ -n $1 ]]; then
    echo -e "${RED}[ADJUST][TEST-ANDROID]:${GREEN} Invalid argument! Aborting ... ${NC}"
    exit 0
fi

# ======================================== #

# Help dialog
if [ "${DISPLAY_HELP}" == YES ]; then
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} test-android.sh script is used to build Adjust SDK and Test ANE for Android integration tests purpose. ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Make sure that: ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN}     - Test device/simulator is connected and started ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN}     - Test server is running ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Arguments: ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN}     --skip-sdk-plugin: Skips building SDK plugin ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN}     --skip-test-plugin: Skips building SDK test plugin ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN}     --help: Displays help instructions"
    exit 1
fi

# ======================================== #

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
KEYSTORE_FILE=`cd ${ROOT_DIR}/${TEST_APP_DIR}; find . -name "*.pfx" -print`

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Running adb uninstall ... ${NC}"
adb uninstall air.com.adjust.examples || true
echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Removing ANEs ... ${NC}"
cd ${ROOT_DIR}
rm -rfv ${TEST_APP_DIR}/lib/Adjust-*.*.*.ane
rm -rfv ${TEST_APP_DIR}/lib/AdjustTest-*.*.*.ane
echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

if [ "$BUILD_SDK_PLUGIN" = YES ]; then
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Removing Adjust SDK ANE file from root directory ... ${NC}"
    cd ${ROOT_DIR}
    rm -rfv Adjust-*.*.*.ane
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

    # ======================================== #

    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Building Adjust SDK ANE for Android platform ... ${NC}"
    cd ${ROOT_DIR}
    ${SCRIPTS_DIR}/build-sdk-ane.sh --skip-ios
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

    # ======================================== #

    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Copying Adjust SDK ANE to the example app ... ${NC}"
    mkdir -p ${TEST_APP_DIR}/lib
    cp -v Adjust-${VERSION}.ane ${TEST_APP_DIR}/lib/
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"
fi

if [ "$BUILD_TEST_PLUGIN" = YES ]; then
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Removing Adjust Test ANE file from root directory ... ${NC}"
    cd ${ROOT_DIR}
    rm -rfv AdjustTest-*.*.*.ane
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

    # ======================================== #

    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Building Adjust SDK Test ANE for Android platform ... ${NC}"
    cd ${ROOT_DIR}
    ${TEST_PLUGIN_DIR}/build-test-ane.sh --skip-ios
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

    # ======================================== #

    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Copying Adjust SDK Test ANE to example app ... ${NC}"
    cd ${ROOT_DIR}
    mkdir -p ${TEST_APP_DIR}/lib
    cp -v AdjustTest-${VERSION}.ane ${TEST_APP_DIR}/lib/
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"
fi

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Running amxmlc ... ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
amxmlc -external-library-path+=lib/Adjust-${VERSION}.ane -external-library-path+=lib/AdjustTest-${VERSION}.ane -output=Main.swf -- ${MAIN_FILE}
echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Checking if keystore file exists ... ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
if [ ! -f "${KEYSTORE_FILE}" ]; then
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Keystore file does not exist. ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Creating one with password [pass] ... ${NC}"
    adt -certificate -validityPeriod 25 -cn SelfSigned 1024-RSA sampleCert.pfx pass
    echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Key store file created! ${NC}"
fi

echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Keystore file is present. ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Packaging APK file ... Password will be entered automatically. ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
echo "pass" | adt -package -target apk-debug -storetype pkcs12 -keystore sampleCert.pfx Main.apk Main-app.xml Main.swf -extdir lib
echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} APK file created. Running ADB install ... ${NC}"
adb install -r Main.apk
echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} App installed. Running the app ... ${NC}"
adb shell monkey -p air.com.adjust.examples 1
echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-ANDROID]:${GREEN} Script completed! ${NC}"

# ======================================== #
