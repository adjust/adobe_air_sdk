from utils import *

# Build Adobe AIR SDK ANE.
def build_ane_sdk():
    dir_scripts     = os.path.dirname(os.path.realpath(__file__))
    dir_root        = os.path.dirname(os.path.normpath(dir_scripts))
    dir_build       = '{0}/build'.format(dir_root)
    dir_src         = '{0}/src'.format(dir_root)
    dir_ext_android = '{0}/ext/android'.format(dir_root)
    dir_ext_ios     = '{0}/ext/ios'.format(dir_root)

    version = open(dir_root + '/VERSION').read()
    version = version[:-1] # Remove end character.

    # Check for presence of submodule directories.
    debug_green('Checking for presence of submodules directories ...')
    check_submodule_dir('iOS', dir_ext_ios + '/sdk')
    check_submodule_dir('Android', dir_ext_android + '/sdk')

    # Go to root directory.
    debug_green('Moving to root directory ...')
    change_dir(dir_root)

    # Recreate 'build' directory and it's 'default' sub-directory.
    debug_green('Recreating \'build\' and \'build/default\' directories ...')
    recreate_dir(dir_build)
    recreate_dir('{0}/default'.format(dir_build))

    # Run 'compc' command.
    debug_green('Running compc ...')
    adobe_air_compc_sdk(dir_root, dir_build)

    # Remove 'catalog.xml' file.
    remove_file_if_exists('{0}/default/catalog.xml'.format(dir_build))

    # Recreate build directories.
    recreate_dir('{0}/Android'.format(dir_build))
    recreate_dir('{0}/iOS'.format(dir_build))
    recreate_dir('{0}/Android-x86'.format(dir_build))
    recreate_dir('{0}/iOS-x86'.format(dir_build))

    # Copy generated files into build directories.
    copy_file('{0}/adjust-android.jar'.format(dir_ext_android), '{0}/Android/adjust-android.jar'.format(dir_build))
    copy_file('{0}/libAdjustExtension.a'.format(dir_ext_ios), '{0}/iOS/libAdjustExtension.a'.format(dir_build))
    copy_dir_content('{0}/AdjustSdk.framework'.format(dir_ext_ios), '{0}/iOS/AdjustSdk.framework'.format(dir_build))
    copy_file('{0}/adjust-android.jar'.format(dir_ext_android), '{0}/Android-x86/adjust-android.jar'.format(dir_build))
    copy_file('{0}/libAdjustExtension.a'.format(dir_ext_ios), '{0}/iOS-x86/libAdjustExtension.a'.format(dir_build))
    copy_dir_content('{0}/AdjustSdk.framework'.format(dir_ext_ios), '{0}/iOS-x86/AdjustSdk.framework'.format(dir_build))

    # Generate .swc file.
    debug_green('Making SWC file ...')
    adobe_air_compc_swc_sdk(dir_root, dir_build)

    # Generate SDK ANE file.
    debug_green('Running ADT and finalizing the ANE file generation ...')
    adobe_air_unzip('{0}/Android'.format(dir_build), '{0}/Adjust.swc'.format(dir_build))
    adobe_air_unzip('{0}/iOS'.format(dir_build), '{0}/Adjust.swc'.format(dir_build))
    adobe_air_unzip('{0}/Android-x86'.format(dir_build), '{0}/Adjust.swc'.format(dir_build))
    adobe_air_unzip('{0}/iOS-x86'.format(dir_build), '{0}/Adjust.swc'.format(dir_build))
    copy_file('{0}/platformoptions.xml'.format(dir_src), '{0}/iOS/platformoptions.xml'.format(dir_build))
    copy_file('{0}/platformoptions.xml'.format(dir_src), '{0}/iOS-x86/platformoptions.xml'.format(dir_build))
    copy_file('{0}/extension.xml'.format(dir_src), '{0}/extension.xml'.format(dir_build))
    change_dir(dir_build)
    adobe_air_adt_sdk(version)

# Build Adobe AIR SDK test library ANE.
def build_ane_test():
    dir_scripts         = os.path.dirname(os.path.realpath(__file__))
    dir_root            = os.path.dirname(os.path.normpath(dir_scripts))
    dir_plugin          = '{0}/test/plugin'.format(dir_root)
    dir_plugin_android  = '{0}/android'.format(dir_plugin)
    dir_plugin_ios      = '{0}/ios'.format(dir_plugin)
    dir_plugin_src      = '{0}/src'.format(dir_plugin)
    dir_plugin_build    = '{0}/build'.format(dir_plugin)

    version = open(dir_root + '/VERSION').read()
    version = version[:-1] # Remove end character.

    # Go to root directory.
    debug_green('Moving to root directory ...')
    change_dir(dir_plugin)

    # Recreate 'build' directory and it's 'default' sub-directory.
    debug_green('Recreating \'build\' and \'build/default\' directories ...')
    recreate_dir(dir_plugin_build)
    recreate_dir('{0}/default'.format(dir_plugin_build))

    # Run 'compc' command.
    debug_green('Running compc ...')
    adobe_air_compc_test(dir_plugin, dir_plugin_build)

    # Remove 'catalog.xml' file.
    remove_file_if_exists('{0}/default/catalog.xml'.format(dir_plugin_build))

    # Recreate build directories.
    recreate_dir('{0}/Android'.format(dir_plugin_build))
    recreate_dir('{0}/iOS'.format(dir_plugin_build))
    recreate_dir('{0}/Android-x86'.format(dir_plugin_build))
    recreate_dir('{0}/iOS-x86'.format(dir_plugin_build))

    # Copy generated files into build directories.
    copy_file('{0}/adjust-android-test.jar'.format(dir_plugin_android), '{0}/Android/adjust-android-test.jar'.format(dir_plugin_build))
    copy_file('{0}/src/AdjustTestExtension/extension/libs/gson-2.8.0.jar'.format(dir_plugin_android), '{0}/Android/gson-2.8.0.jar'.format(dir_plugin_build))
    copy_file('{0}/libAdjustTestExtension.a'.format(dir_plugin_ios), '{0}/iOS/libAdjustTestExtension.a'.format(dir_plugin_build))
    copy_dir_content('{0}/AdjustTestLibrary.framework'.format(dir_plugin_ios), '{0}/iOS/AdjustTestLibrary.framework'.format(dir_plugin_build))
    copy_file('{0}/adjust-android-test.jar'.format(dir_plugin_android), '{0}/Android-x86/adjust-android-test.jar'.format(dir_plugin_build))
    copy_file('{0}/src/AdjustTestExtension/extension/libs/gson-2.8.0.jar'.format(dir_plugin_android), '{0}/Android-x86/gson-2.8.0.jar'.format(dir_plugin_build))
    copy_file('{0}/libAdjustTestExtension.a'.format(dir_plugin_ios), '{0}/iOS-x86/libAdjustTestExtension.a'.format(dir_plugin_build))
    copy_dir_content('{0}/AdjustTestLibrary.framework'.format(dir_plugin_ios), '{0}/iOS-x86/AdjustTestLibrary.framework'.format(dir_plugin_build))

    # Generate .swc file.
    debug_green('Making SWC file ...')
    adobe_air_compc_swc_test(dir_plugin, dir_plugin_build)

    # Generate SDK ANE file.
    debug_green('Running ADT and finalizing the ANE file generation ...')
    adobe_air_unzip('{0}/Android'.format(dir_plugin_build), '{0}/AdjustTest.swc'.format(dir_plugin_build))
    adobe_air_unzip('{0}/iOS'.format(dir_plugin_build), '{0}/AdjustTest.swc'.format(dir_plugin_build))
    adobe_air_unzip('{0}/Android-x86'.format(dir_plugin_build), '{0}/AdjustTest.swc'.format(dir_plugin_build))
    adobe_air_unzip('{0}/iOS-x86'.format(dir_plugin_build), '{0}/AdjustTest.swc'.format(dir_plugin_build))
    copy_file('{0}/platformoptions_android.xml'.format(dir_plugin_src), '{0}/Android/platformoptions_android.xml'.format(dir_plugin_build))
    copy_file('{0}/platformoptions_ios.xml'.format(dir_plugin_src), '{0}/iOS/platformoptions_ios.xml'.format(dir_plugin_build))
    copy_file('{0}/platformoptions_android.xml'.format(dir_plugin_src), '{0}/Android-x86/platformoptions_android.xml'.format(dir_plugin_build))
    copy_file('{0}/platformoptions_ios.xml'.format(dir_plugin_src), '{0}/iOS-x86/platformoptions_ios.xml'.format(dir_plugin_build))
    copy_file('{0}/extension.xml'.format(dir_plugin_src), '{0}/extension.xml'.format(dir_plugin_build))
    change_dir(dir_plugin_build)
    adobe_air_adt_test(dir_root, dir_plugin_build, version)
