from utils import *

# Build Adobe AIR SDK Android extension JAR in debug mode.
def build_extension_sdk_android_debug():
    dir_scripts         = os.path.dirname(os.path.realpath(__file__))
    dir_root            = os.path.dirname(os.path.normpath(dir_scripts))
    dir_ext             = '{0}/ext/android'.format(dir_root)
    dir_bld_extension   = '{0}/src/AdjustExtension'.format(dir_ext)
    dir_src_extension   = '{0}/src/AdjustExtension/extension/src/main/java/com/adjust/sdk'.format(dir_ext)
    dir_src_sdk         = '{0}/sdk/Adjust/sdk-core/src/main/java/com/adjust/sdk'.format(dir_ext)
    dir_src_jar         = '{0}/src/AdjustExtension/extension/build/libs/debug'.format(dir_ext)

    debug_green('Update all Android SDK source files in the extension source directory ...')
    excluded_files = [
        '{0}/AdjustActivity.java'.format(dir_src_extension), 
        '{0}/AdjustExtension.java'.format(dir_src_extension), 
        '{0}/AdjustFunction.java'.format(dir_src_extension), 
        '{0}/AdjustContext.java'.format(dir_src_extension)]
    change_dir(dir_root)
    clean_dir('*', dir_src_extension, excluded_files)
    copy_dir_content(dir_src_sdk, dir_src_extension)

    debug_green('Building adjust-android.jar of the Android extension ...')
    change_dir(dir_bld_extension)
    execute_command(['./gradlew', 'clean', 'makeDebugJar'])

    debug_green('Copying generated adjust-android.jar from {0} to {1} ...'.format(dir_src_jar, dir_ext))
    copy_file('{0}/adjust-android.jar'.format(dir_src_jar), '{0}/adjust-android.jar'.format(dir_ext))

# Build Adobe AIR SDK Android extension JAR in release mode.
def build_extension_sdk_android_release():
    dir_scripts         = os.path.dirname(os.path.realpath(__file__))
    dir_root            = os.path.dirname(os.path.normpath(dir_scripts))
    dir_ext             = '{0}/ext/android'.format(dir_root)
    dir_bld_extension   = '{0}/src/AdjustExtension'.format(dir_ext)
    dir_src_extension   = '{0}/src/AdjustExtension/extension/src/main/java/com/adjust/sdk'.format(dir_ext)
    dir_src_sdk         = '{0}/sdk/Adjust/sdk-core/src/main/java/com/adjust/sdk'.format(dir_ext)
    dir_src_jar         = '{0}/src/AdjustExtension/extension/build/libs/release'.format(dir_ext)

    debug_green('Update all Android SDK source files in the extension source directory ...')
    excluded_files = [
        '{0}/AdjustActivity.java'.format(dir_src_extension), 
        '{0}/AdjustExtension.java'.format(dir_src_extension), 
        '{0}/AdjustFunction.java'.format(dir_src_extension), 
        '{0}/AdjustContext.java'.format(dir_src_extension)]
    change_dir(dir_root)
    clean_dir('*', dir_src_extension, excluded_files)
    copy_dir_content(dir_src_sdk, dir_src_extension)

    debug_green('Building adjust-android.jar of the Android extension ...')
    change_dir(dir_bld_extension)
    execute_command(['./gradlew', 'clean', 'makeReleaseJar'])

    debug_green('Copying generated adjust-android.jar from {0} to {1} ...'.format(dir_src_jar, dir_ext))
    copy_file('{0}/adjust-android.jar'.format(dir_src_jar), '{0}/adjust-android.jar'.format(dir_ext))

# Build Adobe AIR SDK test library Android extension JAR in debug mode.
def build_extension_test_android_debug():
    dir_scripts         = os.path.dirname(os.path.realpath(__file__))
    dir_root            = os.path.dirname(os.path.normpath(dir_scripts))
    dir_plugin          = '{0}/test/plugin/android'.format(dir_root)
    dir_bld_extension   = '{0}/src/AdjustTestExtension'.format(dir_plugin)
    dir_src_extension   = '{0}/extension/src/main/java/com/adjust/test'.format(dir_bld_extension)
    dir_src_test        = '{0}/ext/android/sdk/Adjust/test-library/src/main/java/com/adjust/test'.format(dir_root)
    dir_src_jar         = '{0}/extension/build/libs/debug'.format(dir_bld_extension)

    debug_green('Update all Android SDK test library source files in the extension source directory ...')
    excluded_files = [
        '{0}/AdjustTestExtension.java'.format(dir_src_extension), 
        '{0}/AdjustTestFunction.java'.format(dir_src_extension), 
        '{0}/AdjustTestContext.java'.format(dir_src_extension), 
        '{0}/CommandListener.java'.format(dir_src_extension)]
    change_dir(dir_root)
    clean_dir('*', dir_src_extension, excluded_files)
    copy_dir_content(dir_src_test, dir_src_extension)

    debug_green('Building adjust-android-test.jar of the Android test extension ...')
    change_dir(dir_bld_extension)
    execute_command(['./gradlew', 'clean', 'makeDebugJar'])

    debug_green('Copying generated adjust-android-test.jar from {0} to {1} ...'.format(dir_src_jar, dir_plugin))
    copy_file('{0}/adjust-android-test.jar'.format(dir_src_jar), '{0}/adjust-android-test.jar'.format(dir_plugin))

# Build Adobe AIR SDK test library Android extension JAR in release mode.
def build_extension_test_android_release():
    dir_scripts         = os.path.dirname(os.path.realpath(__file__))
    dir_root            = os.path.dirname(os.path.normpath(dir_scripts))
    dir_plugin          = '{0}/test/plugin/android'.format(dir_root)
    dir_bld_extension   = '{0}/src/AdjustTestExtension'.format(dir_plugin)
    dir_src_extension   = '{0}/extension/src/main/java/com/adjust/test'.format(dir_bld_extension)
    dir_src_test        = '{0}/ext/android/sdk/Adjust/test-library/src/main/java/com/adjust/test'.format(dir_root)
    dir_src_jar         = '{0}/extension/build/libs/release'.format(dir_bld_extension)

    debug_green('Update all Android SDK test library source files in the extension source directory ...')
    excluded_files = [
        '{0}/AdjustTestExtension.java'.format(dir_src_extension), 
        '{0}/AdjustTestFunction.java'.format(dir_src_extension), 
        '{0}/AdjustTestContext.java'.format(dir_src_extension), 
        '{0}/CommandListener.java'.format(dir_src_extension)]
    change_dir(dir_root)
    clean_dir('*', dir_src_extension, excluded_files)
    copy_dir_content(dir_src_test, dir_src_extension)

    debug_green('Building adjust-android-test.jar of the Android test extension ...')
    change_dir(dir_bld_extension)
    execute_command(['./gradlew', 'clean', 'makeReleaseJar'])

    debug_green('Copying generated adjust-android-test.jar from {0} to {1} ...'.format(dir_src_jar, dir_plugin))
    copy_file('{0}/adjust-android-test.jar'.format(dir_src_jar), '{0}/adjust-android-test.jar'.format(dir_plugin))

# Build Adobe AIR SDK iOS extension .a library in debug mode.
def build_extension_sdk_ios_debug():
    dir_scripts         = os.path.dirname(os.path.realpath(__file__))
    dir_root            = os.path.dirname(os.path.normpath(dir_scripts))
    dir_ext             = '{0}/ext/ios'.format(dir_root)
    dir_sdk             = '{0}/sdk'.format(dir_ext)
    dir_src_extension   = '{0}/src/AdjustExtension'.format(dir_ext)

    debug_green('Removing existing static AdjustSdk.framework ...')
    recreate_dir('{0}/Frameworks/Static'.format(dir_sdk))

    debug_green('Running Xcode debug build and symlink removal ...')
    change_dir(dir_sdk)
    xcode_rebuild('AdjustStatic', 'Debug')

    copy_dir_content('{0}/Frameworks/Static/AdjustSdk.framework'.format(dir_sdk), '{0}/include/Adjust/AdjustSdk.framework'.format(dir_src_extension))
    copy_dir_content('{0}/Frameworks/Static/AdjustSdk.framework'.format(dir_sdk), '{0}/AdjustSdk.framework'.format(dir_ext))

    debug_green('Building Adobe AIR iOS SDK extension .a library and outputing it to {0} ...'.format(dir_ext))
    change_dir(dir_src_extension)
    xcode_rebuild_custom_destination('AdjustExtension', 'Debug', dir_ext)

# Build Adobe AIR iOS SDK extension .a library in release mode.
def build_extension_sdk_ios_release():
    dir_scripts         = os.path.dirname(os.path.realpath(__file__))
    dir_root            = os.path.dirname(os.path.normpath(dir_scripts))
    dir_ext             = '{0}/ext/ios'.format(dir_root)
    dir_sdk             = '{0}/sdk'.format(dir_ext)
    dir_src_extension   = '{0}/src/AdjustExtension'.format(dir_ext)

    debug_green('Removing existing static AdjustSdk.framework ...')
    recreate_dir('{0}/Frameworks/Static'.format(dir_sdk))

    debug_green('Running Xcode release build and symlink removal ...')
    change_dir(dir_sdk)
    xcode_rebuild('AdjustStatic', 'Release')

    copy_dir_content('{0}/Frameworks/Static/AdjustSdk.framework'.format(dir_sdk), '{0}/include/Adjust/AdjustSdk.framework'.format(dir_src_extension))
    copy_dir_content('{0}/Frameworks/Static/AdjustSdk.framework'.format(dir_sdk), '{0}/AdjustSdk.framework'.format(dir_ext))

    debug_green('Building Adobe AIR iOS SDK extension .a library and outputing it to {0} ...'.format(dir_ext))
    change_dir(dir_src_extension)
    xcode_rebuild_custom_destination('AdjustExtension', 'Release', dir_ext)

# Build Adobe AIR SDK test library iOS extension .a library in debug mode.
def build_extension_test_ios_debug():
    dir_scripts         = os.path.dirname(os.path.realpath(__file__))
    dir_root            = os.path.dirname(os.path.normpath(dir_scripts))
    dir_plugin          = '{0}/test/plugin/ios'.format(dir_root)
    dir_ext             = '{0}/ext/ios'.format(dir_root)
    dir_src_extension   = '{0}/test/plugin/ios/src/AdjustTestExtension'.format(dir_root)
    dir_test_lib        = '{0}/sdk/AdjustTests/AdjustTestLibrary'.format(dir_ext)
    dir_frameworks      = '{0}/sdk/Frameworks/Static'.format(dir_ext)

    debug_green('Removing existing static AdjustTestLibrary.framework ...')
    recreate_dir(dir_frameworks)

    debug_green('Running Xcode debug build and symlink removal ...')
    change_dir(dir_test_lib)
    xcode_rebuild('AdjustTestLibraryStatic', 'Debug')

    copy_dir_content('{0}/AdjustTestLibrary.framework'.format(dir_frameworks), '{0}/AdjustTestLibrary.framework'.format(dir_src_extension))
    copy_dir_content('{0}/AdjustTestLibrary.framework'.format(dir_frameworks), '{0}/AdjustTestLibrary.framework'.format(dir_plugin))

    debug_green('Building Adobe AIR SDK test library iOS extension .a library and outputing it to {0} ...'.format(dir_plugin))
    change_dir(dir_src_extension)
    xcode_rebuild_custom_destination('AdjustTestExtension', 'Debug', dir_plugin)

# Build Adobe AIR SDK test library iOS extension .a library in release mode.
def build_extension_test_ios_release():
    dir_scripts         = os.path.dirname(os.path.realpath(__file__))
    dir_root            = os.path.dirname(os.path.normpath(dir_scripts))
    dir_plugin          = '{0}/test/plugin/ios'.format(dir_root)
    dir_ext             = '{0}/ext/ios'.format(dir_root)
    dir_src_extension   = '{0}/test/plugin/ios/src/AdjustTestExtension'.format(dir_root)
    dir_test_lib        = '{0}/sdk/AdjustTests/AdjustTestLibrary'.format(dir_ext)
    dir_frameworks      = '{0}/sdk/Frameworks/Static'.format(dir_ext)

    debug_green('Removing existing static AdjustTestLibrary.framework ...')
    recreate_dir(dir_frameworks)

    debug_green('Running Xcode release build and symlink removal ...')
    change_dir(dir_test_lib)
    xcode_rebuild('AdjustTestLibraryStatic', 'Release')

    copy_dir_content('{0}/AdjustTestLibrary.framework'.format(dir_frameworks), '{0}/AdjustTestLibrary.framework'.format(dir_src_extension))
    copy_dir_content('{0}/AdjustTestLibrary.framework'.format(dir_frameworks), '{0}/AdjustTestLibrary.framework'.format(dir_plugin))

    debug_green('Building Adobe AIR SDK test library iOS extension .a library and outputing it to {0} ...'.format(dir_plugin))
    change_dir(dir_src_extension)
    xcode_rebuild_custom_destination('AdjustTestExtension', 'Release', dir_plugin)
