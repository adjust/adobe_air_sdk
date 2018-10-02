#!/usr/bin/python
from scripting_utils import *
import build_sdk_android as android
import build_sdk_ios     as ios
import argparse

set_log_tag('BUILD-SDK-ANE')

if __name__ != "__main__":
    error('Error. Do not import this script, but run it explicitly.')
    exit()

# ------------------------------------------------------------------
# set arguments
parser = argparse.ArgumentParser(description="Script used to build SDK ANE or Adobe Air")
parser.add_argument('-tl', '--withtestlib', help='build test library ANE as well', action='store_true')
args = parser.parse_args()

# ------------------------------------------------------------------
# common paths
script_dir              = os.path.dirname(os.path.realpath(__file__))
root_dir                = os.path.dirname(os.path.normpath(script_dir))
android_submodule_dir   = '{0}/ext/android'.format(root_dir)
ios_submodule_dir       = '{0}/ext/ios'.format(root_dir)
source_dir              = '{0}/src'.format(root_dir)
build_dir               = '{0}/build'.format(root_dir)

# test lib commong paths
test_plugin_dir         = '{0}/test/plugin'.format(root_dir)
test_plugin_source_dir  = '{0}/src'.format(test_plugin_dir)
test_plugin_build_dir   = '{0}/build'.format(test_plugin_dir)

version = open(root_dir + '/VERSION').read()
version = version[:-1] # remove end character

try:
    check_submodule_dir('iOS', ios_submodule_dir + '/sdk')
    check_submodule_dir('Android', android_submodule_dir + '/sdk')

    # ------------------------------------------------------------------
    # Running compc
    debug_green('Running compc ...')
    change_dir(root_dir)
    create_dir_if_not_exist(build_dir)
    recreate_dir('{0}/default'.format(build_dir))
    adobe_air_compc(root_dir, build_dir)
    remove_file_if_exists('{0}/default/catalog.xml'.format(build_dir))

    # ------------------------------------------------------------------
    # Running Android and iOS build scripts
    debug_green('Running Android and iOS build scripts ...')

    # call android build - release
    android.build(root_dir, is_release=True)
    # call ios build
    ios.build(root_dir)

    # ------------------------------------------------------------------
    # Copying generated files to ${BUILD_DIR}
    debug_green('Copying generated files to {0} ...'.format(build_dir))
    recreate_dir('{0}/Android'.format(build_dir))
    recreate_dir('{0}/iOS'.format(build_dir))
    recreate_dir('{0}/Android-x86'.format(build_dir))
    recreate_dir('{0}/iOS-x86'.format(build_dir))
    copy_files('*.jar', android_submodule_dir, '{0}/Android'.format(build_dir))
    copy_files('*.a', ios_submodule_dir, '{0}/iOS'.format(build_dir))
    copy_dir_contents('{0}/AdjustSdk.framework'.format(ios_submodule_dir), '{0}/iOS/AdjustSdk.framework'.format(build_dir))
    copy_files('*.jar', android_submodule_dir, '{0}/Android-x86'.format(build_dir))
    copy_files('*.a', ios_submodule_dir, '{0}/iOS-x86'.format(build_dir))
    copy_dir_contents('{0}/AdjustSdk.framework'.format(ios_submodule_dir), '{0}/iOS-x86/AdjustSdk.framework'.format(build_dir))

    # ------------------------------------------------------------------
    # Making SWC file
    debug_green('Making SWC file ...')
    adobe_air_compc_build_swc(root_dir, build_dir)  

    # ------------------------------------------------------------------
    # Running ADT and finalizing the ANE file generation
    debug_green('Running ADT and finalizing the ANE file generation ...')
    adobe_air_unzip('{0}/Android'.format(build_dir), '{0}/Adjust.swc'.format(build_dir))
    adobe_air_unzip('{0}/iOS'.format(build_dir), '{0}/Adjust.swc'.format(build_dir))
    adobe_air_unzip('{0}/Android-x86'.format(build_dir), '{0}/Adjust.swc'.format(build_dir))
    adobe_air_unzip('{0}/iOS-x86'.format(build_dir), '{0}/Adjust.swc'.format(build_dir))
    copy_file('{0}/platformoptions.xml'.format(source_dir), '{0}/iOS/platformoptions.xml'.format(build_dir))
    copy_file('{0}/platformoptions.xml'.format(source_dir), '{0}/iOS-x86/platformoptions.xml'.format(build_dir))
    copy_file('{0}/extension.xml'.format(source_dir), '{0}/extension.xml'.format(build_dir))
    change_dir(build_dir)
    adobe_air_adt(version)

    if args.withtestlib:
        debug_green('Making ANE for test library ...')

        # ------------------------------------------------------------------
        # Running emulator tasks
        debug_green('Running emulator tasks ...')
        change_dir(test_plugin_dir)
        create_dir_if_not_exist(test_plugin_build_dir)
        recreate_dir('{0}/default'.format(test_plugin_build_dir))
        adobe_air_compc_test_lib(test_plugin_dir, test_plugin_build_dir)
        remove_file_if_exists('{0}/default/catalog.xml'.format(test_plugin_build_dir))

        # call android build - release
        android.build_test_lib(root_dir)
        # call ios build
        ios.build_test_lib(root_dir)

        # ------------------------------------------------------------------
        # Making SWC file
        debug_green('Making SWC file ...')
        adobe_air_compc_build_swc_test_lib(test_plugin_dir, test_plugin_build_dir)

        # ------------------------------------------------------------------
        # Copying files to ${BUILD_DIR} directory
        debug_green('Copying files to {0} directory ...'.format(test_plugin_build_dir))
        adobe_air_unzip('{0}/Android'.format(test_plugin_build_dir), '{0}/adjust-test.swc'.format(test_plugin_build_dir))
        adobe_air_unzip('{0}/iOS'.format(test_plugin_build_dir), '{0}/adjust-test.swc'.format(test_plugin_build_dir))
        adobe_air_unzip('{0}/Android-x86'.format(test_plugin_build_dir), '{0}/adjust-test.swc'.format(test_plugin_build_dir))
        adobe_air_unzip('{0}/iOS-x86'.format(test_plugin_build_dir), '{0}/adjust-test.swc'.format(test_plugin_build_dir))
        copy_file('{0}/platformoptions_android.xml'.format(test_plugin_source_dir), '{0}/Android/platformoptions_android.xml'.format(test_plugin_build_dir))
        copy_file('{0}/platformoptions_ios.xml'.format(test_plugin_source_dir), '{0}/iOS/platformoptions_ios.xml'.format(test_plugin_build_dir))
        copy_file('{0}/extension.xml'.format(test_plugin_source_dir), '{0}/extension.xml'.format(test_plugin_build_dir))
        change_dir(test_plugin_build_dir)
        adobe_air_adt_test_lib(root_dir, test_plugin_build_dir, version)

finally:
    # remove autocreated python compiled files
    remove_files('*.pyc', script_dir, log=False)

# ------------------------------------------------------------------
# Script completed
debug_green('Script completed!')
