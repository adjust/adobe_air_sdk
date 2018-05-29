#!/usr/bin/env bash

set -e

POSITIONAL=()
BUILD_PLUGIN=YES
BUILD_TESTING_PLUGIN=YES
BUILD_ANDROID=YES
DISPLAY_HELP=NO

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --skip-plugin)
            BUILD_PLUGIN=NO
            shift # past argument
            ;;
        --skip-testing-plugin)
            BUILD_TESTING_PLUGIN=NO
            shift # past argument
            ;;
        --skip-android)
            BUILD_ANDROID=NO
            shift # past argument
            ;;
        --help)
            DISPLAY_HELP=YES
            shift # past argument
            ;;
        *)
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

# check for invalid arguments
if [[ -n $1 ]]; then
    echo "Argument invalid"
    exit 0
fi

if [ "${DISPLAY_HELP}" == YES ]; then
    echo "./adobe_ci_ios; runs ci build script for ios"
    echo
    echo "# Make sure"
    echo "- Device is plugged-in"
    echo "- Test server is running"
    echo
    echo "# Arguments"
    echo "    --skip-plugin: Skips building plugin"
    echo "    --skip-testing-plugin: Skips building test plugin"
    echo "    --skip-android: Skips building the android part of both adjust plugin and testing plugin"
    echo "    --help: Displays help"
    exit 1
fi

if [ "$BUILD_ANDROID" = NO ]; then
    SKIP_ANDROID=--skip-android
fi

# Get the current directory (/scripts/ directory)
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Traverse up to get to the root directory
ROOT_DIR="$(dirname "$SCRIPTS_DIR")"
TEST_APP_DIR=test_app
EXT_DIR=ext/ios
VERSION=`cat ${ROOT_DIR}/VERSION`
TEST_PLUGIN_DIR=testing_plugin

MAIN_FILE=Main.as
EXAMPLE_APP_XML_FILE=Main-app.xml
KEYSTORE_FILE=`cd ${ROOT_DIR}/${TEST_APP_DIR}; find . -name "*.pfx" -print` # Get any keystore file with extension .pfx

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

echo -e "${GREEN}>>> Removing ANEs ${NC}"
cd ${ROOT_DIR}
rm -rfv ${TEST_APP_DIR}/lib/Adjust-*.*.*.ane
rm -rfv ${TEST_APP_DIR}/lib/Adjust-testing-*.*.*.ane

if [ "$BUILD_PLUGIN" = YES ]; then
    echo -e "${GREEN}>>> Removing Adjust SDK ANE file from root dir ${NC}"
    cd ${ROOT_DIR}
    rm -rfv Adjust-*.*.*.ane

    echo -e "${GREEN}>>> Building Adjust SDK ANE ${NC}"
    cd ${ROOT_DIR}
    ${SCRIPTS_DIR}/build-adjust-ane.sh ${SKIP_ANDROID}

    echo -e "${GREEN}>>> Copying Adjust SDK ANE to example app ${NC}"
    mkdir -p ${TEST_APP_DIR}/lib
    cp -v Adjust-${VERSION}.ane ${TEST_APP_DIR}/lib/
fi

if [ "$BUILD_TESTING_PLUGIN" = YES ]; then
    echo -e "${GREEN}>>> Removing Adjust Testing ANE file from root dir ${NC}"
    cd ${ROOT_DIR}
    rm -rfv Adjust-testing-*.*.*.ane

    echo -e "${GREEN}>>> Building Adjust Testing ANE ${NC}"
    cd ${ROOT_DIR}
    ${TEST_PLUGIN_DIR}/build-test-ane.sh ${SKIP_ANDROID}

    echo -e "${GREEN}>>> Copying Adjust Testing ANE to example app ${NC}"
    cd ${ROOT_DIR}
    mkdir -p ${TEST_APP_DIR}/lib
    cp -v Adjust-testing-${VERSION}.ane ${TEST_APP_DIR}/lib/
fi

echo -e "${GREEN}>>> Running amxmlc ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
amxmlc -external-library-path+=lib/Adjust-${VERSION}.ane -external-library-path+=lib/Adjust-testing-${VERSION}.ane -output=Main.swf -- ${MAIN_FILE}

echo -e "${GREEN}>>> Packaging IPA file. ${NC}"
cd ${ROOT_DIR}/${TEST_APP_DIR}
echo | adt -package -target ipa-debug -provisioning-profile ${DEV_CI_PROVISIONING_PROFILE_PATH} -storetype pkcs12 -keystore ${KEYSTORE_FILE_PATH} Main.ipa ${EXAMPLE_APP_XML_FILE} Main.swf -extdir lib

echo -e "${GREEN}>>> IPA file created. ${NC}"
