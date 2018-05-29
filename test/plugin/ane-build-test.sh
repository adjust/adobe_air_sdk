#!/usr/bin/env bash

set -e

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
CYAN='\033[1;36m'
GREEN='\033[0;32m'

# Handle input parameters
POSITIONAL=()
BUILD_ANDROID=YES
BUILD_IOS=YES
DISPLAY_HELP=NO

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --skip-android)
            BUILD_ANDROID=NO
            shift # Past argument
            ;;
        --skip-ios)
            BUILD_IOS=NO
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

# Check for invalid arguments
if [[ -n $1 ]]; then
    echo -e "${RED}[ADJUST][ANE-BUILD-TEST]:${GREEN} Invalid argument! Aborting ... ${NC}"
    exit 0
fi

# Help dialog
if [ "${DISPLAY_HELP}" == YES ]; then
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} ane-build-test.sh script is used to build Adjust SDK ANE used for integration tests. ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Arguments: ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN}     --skip-android: Skips building native Android test library ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN}     --skip-ios: Skips building native iOS test library ${NC}"
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN}     --help: Displays help instructions"
    exit 1
fi

# Set directories of interest for the script
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"
TEST_PLUGIN_DIR=test/plugin
SOURCE_DIR=src
BUILD_DIR=build

# Tools and commands parts
ADT=${AIR_SDK_PATH}/bin/adt
COMPC=${AIR_SDK_PATH}/bin/compc
COMPC_CLASSES="com.adjust.test.AdjustTest"
VERSION=`cat ${ROOT_DIR}/VERSION`

echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Running emulator tasks ... ${NC}"
cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
mkdir -p ${BUILD_DIR}/default
${COMPC} -source-path default/src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -directory=true -output ${BUILD_DIR}/default
rm -rf ${BUILD_DIR}/default/catalog.xml
echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"

if [ "$BUILD_ANDROID" = YES ]; then
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Cleaning up Android binary files from previous build ... ${NC}"
    cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
    rm -rfv build/Android/adjust-*.jar
    rm -rfv build/Android/gson*.jar
    rm -rfv build/Android-x86/adjust-*.jar
    rm -rfv build/Android-x86/gson*.jar
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"

    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Running Android test library build script ... ${NC}"
    cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
    android/build.sh
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"

    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Copying generated libraries to their destination (${ROOT_DIR}/${TEST_PLUGIN_DIR}/${BUILD_DIR}/Android) ... ${NC}"
    cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
    mkdir -p ${BUILD_DIR}/Android
    mkdir -p ${BUILD_DIR}/Android-x86
    cp -Rv android/adjust-android-test.jar ${BUILD_DIR}/Android
    cp -Rv android/src/AdjustTestExtension/extension/libs/gson*.jar ${BUILD_DIR}/Android
    cp -Rv android/adjust-android-test.jar ${BUILD_DIR}/Android-x86
    cp -Rv android/src/AdjustTestExtension/extension/libs/gson*.jar ${BUILD_DIR}/Android-x86
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"
fi

if [ "$BUILD_IOS" = YES ]; then
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Cleaning up iOS binary files from previous build ... ${NC}"
    cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
    rm -rfv build/iOS/Adjust*.framework
    rm -rfv build/iOS/libAdjust*.a
    rm -rfv build/iOS-x86/Adjust*.framework
    rm -rfv build/iOS-x86/libAdjust*.a
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"
    
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Running iOS test library build script ... ${NC}"
    cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
    ios/build.sh
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"

    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Copying generated libraries to destination (${ROOT_DIR}/${TEST_PLUGIN_DIR}/${BUILD_DIR}/iOS) ... ${NC}"
    cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
    mkdir -p ${BUILD_DIR}/iOS
    mkdir -p ${BUILD_DIR}/iOS-x86
    cp -Rv ios/src/AdjustTestExtension/*.a ${BUILD_DIR}/iOS
    cp -Rv ios/src/AdjustTestExtension/*.framework ${BUILD_DIR}/iOS
    cp -Rv ios/src/AdjustTestExtension/*.a ${BUILD_DIR}/iOS-x86
    cp -Rv ios/src/AdjustTestExtension/*.framework ${BUILD_DIR}/iOS-x86
    echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"
fi

echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Making SWC file ... ${NC}"
cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
${COMPC} -source-path src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -output ${BUILD_DIR}/adjust-test.swc
echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"

echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Copying files to ${BUILD_DIR} directory ... ${NC}"
cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}
unzip -d ${BUILD_DIR}/Android -qq -o ${BUILD_DIR}/adjust-test.swc -x catalog.xml
unzip -d ${BUILD_DIR}/iOS -qq -o ${BUILD_DIR}/adjust-test.swc -x catalog.xml
unzip -d ${BUILD_DIR}/Android-x86 -qq -o ${BUILD_DIR}/adjust-test.swc -x catalog.xml
unzip -d ${BUILD_DIR}/iOS-x86 -qq -o ${BUILD_DIR}/adjust-test.swc -x catalog.xml
cp -afv ${SOURCE_DIR}/platformoptions_android.xml ${BUILD_DIR}/Android/platformoptions_android.xml
cp -afv ${SOURCE_DIR}/platformoptions_ios.xml ${BUILD_DIR}/iOS/platformoptions_ios.xml
cp -afv ${SOURCE_DIR}/extension.xml ${BUILD_DIR}/extension.xml
echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"

echo -e "${GREEN}>>> Running ADT ${NC}"
echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Running ADT ... ${NC}"
cd ${ROOT_DIR}/${TEST_PLUGIN_DIR}/${BUILD_DIR}
${ADT} -package -target ane ${ROOT_DIR}/AdjustTest-${VERSION}.ane extension.xml -swc adjust-test.swc -platform Android-ARM -C Android . -platformoptions Android/platformoptions_android.xml -platform Android-x86 -C Android-x86 . -platform iPhone-ARM -C iOS . -platformoptions iOS/platformoptions_ios.xml -platform iPhone-x86 -C iOS-x86 . -platform default -C default .
echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Done! ${NC}"

echo -e "${CYAN}[ADJUST][ANE-BUILD-TEST]:${GREEN} Script completed! ${NC}"
