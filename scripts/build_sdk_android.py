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

def build_test_lib(root_dir):
    # ------------------------------------------------------------------
    # paths]
    test_plugin_dir    = '{0}/test/plugin/android'.format(root_dir)
    build_dir          = '{0}/src/AdjustTestExtension'.format(test_plugin_dir)
    jar_in_dir         = '{0}/extension/build/outputs'.format(build_dir)
    test_lib_dir       = '{0}/ext/android/sdk/Adjust/testlibrary/src/main/java/com/adjust/testlibrary'.format(root_dir)
    test_extension_dir = '{0}/extension/src/main/java/com/adjust/testlibrary'.format(build_dir)

    # ------------------------------------------------------------------
    # Removing all test plugin native source files except Adobe AIR .java files
    debug_green('Removing all test plugin native source files except Adobe AIR .java files ...')
    excluded_files = [
        '{0}/AdjustTestExtension.java'.format(test_extension_dir), 
        '{0}/AdjustTestFunction.java'.format(test_extension_dir), 
        '{0}/AdjustTestContext.java'.format(test_extension_dir), 
        '{0}/CommandListener.java'.format(test_extension_dir)]
    remove_files('*', test_extension_dir, excluded_files)

    # ------------------------------------------------------------------
    # Adding test library native source files
    debug_green('Adding test library native source files ...')
    copy_files('*', test_lib_dir, test_extension_dir)

    # ------------------------------------------------------------------
    # Starting Gradle tasks: clean makeJar
    debug_green('Starting Gradle tasks: clean makeJar ...')
    change_dir(build_dir)
    gradle_clean_make_jar()

    # ------------------------------------------------------------------
    # Copying adjust-android-test.jar to it's destination (${TEST_PLUGIN_DIR})
    debug_green('Copying adjust-android-test.jar to it\'s destination ({0}) ...'.format(test_plugin_dir))
    copy_file('{0}/adjust-android-test.jar'.format(jar_in_dir), '{0}/adjust-android-test.jar'.format(test_plugin_dir))

    debug_green('Android Test Lib build done ...');
