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
        --skip-plugin)
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

set -- "${POSITIONAL[@]}" # restore positional parameters

# ======================================== #

# Check for invalid arguments
if [[ -n $1 ]]; then
    echo "Argument invalid"
    exit 0
fi

# ======================================== #

# Help dialog
if [ "${DISPLAY_HELP}" == YES ]; then
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} test-ios.sh script is used to build Adjust SDK and Test ANE for iOS integration tests purpose. ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Make sure that: ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN}     - Test device/simulator is connected and started ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN}     - Test server is running ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Arguments: ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN}     --skip-sdk-plugin: Skips building SDK plugin ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN}     --skip-test-plugin: Skips building SDK test plugin ${NC}"
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN}     --help: Displays help instructions"
    exit 1
fi

# ======================================== #

# Set directories of interest for the script
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
TEST_APP_DIR=test/app
EXT_DIR=ext/android
TEST_PLUGIN_DIR=test/plugin
VERSION=`cat ${ROOT_DIR}/VERSION`

# Tools and commands parts
MAIN_FILE=Main.as
EXAMPLE_APP_XML_FILE=Main-app.xml
KEYSTORE_FILE=`cd ${ROOT_DIR}/${TEST_APP_DIR}; find . -name "*.pfx" -print` # Get any keystore file with extension .pfx

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Removing ANEs ... ${NC}"
cd ${ROOT_DIR}
rm -rfv ${TEST_APP_DIR}/lib/Adjust-*.*.*.ane
rm -rfv ${TEST_APP_DIR}/lib/AdjustTest-*.*.*.ane
echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Done! ${NC}"

if [ "$BUILD_SDK_PLUGIN" = YES ]; then
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Removing Adjust SDK ANE file from root directory ... ${NC}"
    cd ${ROOT_DIR}
    rm -rfv Adjust-*.*.*.ane
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Done! ${NC}"

    # ======================================== #

    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Building Adjust SDK ANE for iOS platform ... ${NC}"
    cd ${ROOT_DIR}
    ${SCRIPTS_DIR}/build-adjust-ane.sh --skip-android
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Done! ${NC}"

    # ======================================== #

    echo -e "${CYAN}[ADJUST][TEST-iOS]:${GREEN} Copying Adjust SDK ANE to the example app ... ${NC}"
    mkdir -p ${TEST_APP_DIR}/lib
    cp -v Adjust-${VERSION}.ane ${TEST_APP_DIR}/lib/
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Done! ${NC}"
fi

if [ "$BUILD_TEST_PLUGIN" = YES ]; then
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Removing Adjust Test ANE file from root directory ... ${NC}"
    cd ${ROOT_DIR}
    rm -rfv AdjustTest-*.*.*.ane
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Done! ${NC}"

    # ======================================== #

    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Building Adjust SDK Test ANE for iOS platform ... ${NC}"
    cd ${ROOT_DIR}
    ${TEST_PLUGIN_DIR}/build-test-ane.sh --skip-android
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Done! ${NC}"

    # ======================================== #

    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Copying Adjust SDK Test ANE to example app ... ${NC}"
    cd ${ROOT_DIR}
    mkdir -p ${TEST_APP_DIR}/lib
    cp -v AdjustTest-${VERSION}.ane ${TEST_APP_DIR}/lib/
    echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Done! ${NC}"
fi

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Running amxmlc ... ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
amxmlc -external-library-path+=lib/Adjust-${VERSION}.ane -external-library-path+=lib/AdjustTest-${VERSION}.ane -output=Main.swf -- ${MAIN_FILE}
echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Packaging IPA file ... ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
echo | adt -package -target ipa-debug -provisioning-profile ${DEV_CI_PROVISIONING_PROFILE_PATH} -storetype pkcs12 -keystore ${KEYSTORE_FILE_PATH} Main.ipa ${EXAMPLE_APP_XML_FILE} Main.swf -extdir lib
echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Done! ${NC}"

# ======================================== #

echo -e "${CYAN}[ADJUST][TEST-IOS]:${GREEN} Script completed! ${NC}"

# ======================================== #
