from scripting_utils import *

def build(root_dir):
    # ------------------------------------------------------------------
    # paths]
    ext_dir = '{0}/ext/ios'.format(root_dir)
    sdk_dir = '{0}/sdk'.format(ext_dir)
    src_dir = '{0}/src/AdjustExtension'.format(ext_dir)

    # ------------------------------------------------------------------
    # Removing existing framework
    debug_green('Removing existing framework ...')
    recreate_dir('{0}/Frameworks/Static'.format(sdk_dir))

    # ------------------------------------------------------------------
    # Running Xcode release build and symlink removal
    debug_green('Running Xcode release build and symlink removal ...')
    change_dir(sdk_dir)
    xcode_build('AdjustStatic')

    copy_dir_contents('{0}/Frameworks/Static/AdjustSdk.framework'.format(sdk_dir), '{0}/include/Adjust/AdjustSdk.framework'.format(src_dir))
    copy_dir_contents('{0}/Frameworks/Static/AdjustSdk.framework'.format(sdk_dir), '{0}/AdjustSdk.framework'.format(ext_dir))

    # ------------------------------------------------------------------
    # Building .a library
    debug_green('Building .a library ...')
    change_dir(src_dir)
    xcode_build_custom(ext_dir)

    debug_green('iOS build done!');
    
def build_test_lib(root_dir):
    # ------------------------------------------------------------------
    # paths]
    ext_dir              = '{0}/ext/iOS'.format(root_dir)
    src_dir              = '{0}/test/plugin/ios/src/AdjustTestExtension'.format(root_dir)
    test_lib_project_dir = '{0}/sdk/AdjustTests/AdjustTestLibrary'.format(ext_dir)
    frameworks_dir       = '{0}/sdk/Frameworks/Static'.format(ext_dir)

    # ------------------------------------------------------------------
    # Removing existing framework
    debug_green('Removing existing framework ...')
    remove_dir_if_exists('{0}/AdjustTestLibrary.framework'.format(src_dir))
    remove_file_if_exists('{0}/libAdjustTestExtension.a'.format(src_dir))

    # ------------------------------------------------------------------
    # Building test library static framework target
    debug_green('Building test library static framework target ...')
    change_dir(test_lib_project_dir)
    xcode_clean_build('AdjustTestLibraryStatic')

    # ------------------------------------------------------------------
    # Building test library static framework target
    debug_green('Building test library static framework target ...')
    copy_dir_contents('{0}/AdjustTestLibrary.framework'.format(frameworks_dir), '{0}/AdjustTestLibrary.framework'.format(src_dir))
    remove_dir_if_exists('{0}/AdjustTestLibrary.framework/Versions'.format(src_dir))

    # ------------------------------------------------------------------
    # Building .a library
    debug_green('Building .a library ...')
    change_dir(src_dir)
    xcode_build_custom(ext_dir)
    move_file('libAdjustTestExtension.a', ext_dir, '{0}/src'.format(root_dir))

    debug_green('iOS test lib build done!');
