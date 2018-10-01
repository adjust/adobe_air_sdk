from scripting_utils import *

def build(root_dir, is_release = True):
    # ------------------------------------------------------------------
    # paths]
    ext_dir              = '{0}/ext/android'.format(root_dir)
    build_dir            = '{0}/src/AdjustExtension'.format(ext_dir)
    extension_source_dir = '{0}/src/AdjustExtension/extension/src/main/java/com/adjust/sdk'.format(ext_dir)
    jar_in_dir           = '{0}/src/AdjustExtension/extension/build/outputs'.format(ext_dir)
    sdk_source_dir       = '{0}/sdk/Adjust/adjust/src/main/java/com/adjust/sdk'.format(ext_dir)

    # ------------------------------------------------------------------
    # Removing all files not related to Adjust extension
    debug_green('Removing all files not related to Adjust extension ...')
    excluded_files = [
        '{0}/AdjustActivity.java'.format(extension_source_dir), 
        '{0}/AdjustExtension.java'.format(extension_source_dir), 
        '{0}/AdjustFunction.java'.format(extension_source_dir), 
        '{0}/AdjustContext.java'.format(extension_source_dir)]
    remove_dir_if_exists('{0}/plugin'.format(extension_source_dir))
    remove_files('*', extension_source_dir, excluded_files)

    # ------------------------------------------------------------------
    # Copying files from ${SDK_SOURCE_DIR} to ${EXTENSION_SOURCE_DIR}
    debug_green('Copying files from {0} to {1} ...'.format(sdk_source_dir, extension_source_dir))
    copy_dir_contents('{0}/plugin'.format(sdk_source_dir), '{0}/plugin'.format(extension_source_dir))
    copy_files('*', sdk_source_dir, extension_source_dir)

    # ------------------------------------------------------------------
    # Running Gradle task: make Jar
    debug_green('Running Gradle task: make Jar ...')
    change_dir(build_dir)
    if is_release:
        gradle_make_release_jar(do_clean=True)
    else:
        gradle_make_debug_jar(do_clean=True)

    # ------------------------------------------------------------------
    # Moving generated JAR from ${JAR_IN_DIR} to ${EXT_DIR}
    debug_green('Moving generated JAR from {0} to {1} ...'.format(jar_in_dir, ext_dir))
    copy_file('{0}/adjust-android.jar'.format(jar_in_dir), '{0}/adjust-android.jar'.format(ext_dir))

    debug_green('Android build done ...');
