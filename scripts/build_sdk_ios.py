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
    # recreate_dir('{0}/AdjustSdk.framework/tmp'.format(root_dir))

    copy_dir_contents('{0}/Frameworks/Static/AdjustSdk.framework'.format(sdk_dir), '{0}/include/Adjust/AdjustSdk.framework'.format(src_dir))
    copy_dir_contents('{0}/Frameworks/Static/AdjustSdk.framework'.format(sdk_dir), '{0}/AdjustSdk.framework'.format(ext_dir))

    change_dir(src_dir)
    xcode_build_custom(ext_dir)

    debug_green('iOS build done ...');
    