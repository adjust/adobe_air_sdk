#!/usr/bin/python
from scripting_utils import *
import build_sdk_android as android
import build_sdk_ios     as ios

set_log_tag('BUILD-SDK-ANE')

if __name__ != "__main__":
    error('Error. Do not import this script, but run it explicitly.')
    exit()

# ------------------------------------------------------------------
# common paths
script_dir              = os.path.dirname(os.path.realpath(__file__))
root_dir                = os.path.dirname(os.path.normpath(script_dir))
android_submodule_dir   = '{0}/ext/android'.format(root_dir)
ios_submodule_dir       = '{0}/ext/ios'.format(root_dir)
source_dir              = '{0}/src'.format(root_dir)
build_dir               = '{0}/build'.format(root_dir)

version = open(root_dir + '/VERSION').read()
version = version[:-1] # remove end character

try:
    check_submodule_dir('iOS', ios_submodule_dir + '/sdk')
    check_submodule_dir('Android', android_submodule_dir + '/sdk')

    # ------------------------------------------------------------------
    # Running compc
    debug_green('Running compc ...')
    change_dir(root_dir)
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
    copy_files('*.jar', android_submodule_dir, '{0}/Android-x86'.format(build_dir))
    copy_files('*.a', ios_submodule_dir, '{0}/iOS-x86'.format(build_dir))
    copy_files('*.framework', ios_submodule_dir, '{0}/iOS-x86'.format(build_dir))
    copy_files('*.jar', android_submodule_dir, '{0}/Android-x86'.format(build_dir))
    copy_files('*.a', ios_submodule_dir, '{0}/iOS-x86'.format(build_dir))
    copy_files('*.framework', ios_submodule_dir, '{0}/iOS-x86'.format(build_dir))

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

finally:
    # remove autocreated python compiled files
    remove_files('*.pyc', script_dir, log=False)

# ------------------------------------------------------------------
# Script completed
debug_green('Script completed!')
