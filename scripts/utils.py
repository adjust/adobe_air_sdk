# Various utility methods.

import os, shutil, glob, time, sys, platform, subprocess
from distutils.dir_util import copy_tree

def set_log_tag(t):
    global TAG
    TAG = t

# ------------------------------------------------------------------
# Colours for terminal (does not work in Windows).

CEND = '\033[0m'

CBOLD     = '\33[1m'
CITALIC   = '\33[3m'
CURL      = '\33[4m'
CBLINK    = '\33[5m'
CBLINK2   = '\33[6m'
CSELECTED = '\33[7m'

CBLACK  = '\33[30m'
CRED    = '\33[31m'
CGREEN  = '\33[32m'
CYELLOW = '\33[33m'
CBLUE   = '\33[34m'
CVIOLET = '\33[35m'
CBEIGE  = '\33[36m'
CWHITE  = '\33[37m'

CBLACKBG  = '\33[40m'
CREDBG    = '\33[41m'
CGREENBG  = '\33[42m'
CYELLOWBG = '\33[43m'
CBLUEBG   = '\33[44m'
CVIOLETBG = '\33[45m'
CBEIGEBG  = '\33[46m'
CWHITEBG  = '\33[47m'

CGREY    = '\33[90m'
CRED2    = '\33[91m'
CGREEN2  = '\33[92m'
CYELLOW2 = '\33[93m'
CBLUE2   = '\33[94m'
CVIOLET2 = '\33[95m'
CBEIGE2  = '\33[96m'
CWHITE2  = '\33[97m'

CGREYBG    = '\33[100m'
CREDBG2    = '\33[101m'
CGREENBG2  = '\33[102m'
CYELLOWBG2 = '\33[103m'
CBLUEBG2   = '\33[104m'
CVIOLETBG2 = '\33[105m'
CBEIGEBG2  = '\33[106m'
CWHITEBG2  = '\33[107m'

# ------------------------------------------------------------------
# Log output methods.

def debug(msg):
    if not is_windows():
        print(('{0}* [{1}][INFO]:{2} {3}').format(CBOLD, TAG, CEND, msg))
    else:
        print(('* [{0}][INFO]: {1}').format(TAG, msg))

def debug_green(msg):
    if not is_windows():
        print(('{0}* [{1}][INFO]:{2} {3}{4}{5}').format(CBOLD, TAG, CEND, CGREEN, msg, CEND))
    else:
        print(('* [{0}][INFO]: {1}').format(TAG, msg))

def debug_blue(msg):
    if not is_windows():
        print(('{0}* [{1}][INFO]:{2} {3}{4}{5}').format(CBOLD, TAG, CEND, CBLUE, msg, CEND))
    else:
        print(('* [{0}][INFO]: {1}').format(TAG, msg))

def error(msg, do_exit=False):
    if not is_windows():
        print(('{0}* [{1}][ERROR]:{2} {3}{4}{5}').format(CBOLD, TAG, CEND, CRED, msg, CEND))
    else:
        print(('* [{0}][ERROR]: {1}').format(TAG, msg))

    if do_exit:
        exit()

# ------------------------------------------------------------------
# File system methods.

# Check if submodule directory is empty. Stop execution if it is.
def check_submodule_dir(platform, submodule_dir):
    if not os.path.isdir(submodule_dir) or not os.listdir(submodule_dir):
        error('[{0}] submodule folder empty. Did you forget to run \'git submodule update --init --recursive\'?'.format(platform))
        exit()

# Change to directory.
def change_dir(dir):
    debug('Changing directory to {0} ...'.format(dir))
    os.chdir(dir)

# Create directory if it doesn't exist.
def create_dir_if_not_present(dir):
    if not os.path.exists(dir):
        os.makedirs(dir)

# Remove given directory.
def remove_dir(dir):
    if os.path.exists(dir):
        shutil.rmtree(dir)
        debug('Deleted {0}'.format(dir))
    else:
        debug('Can not delete {0}. Directory doesn\'t exist'.format(dir))

# If given directory exists, remove it and create it again.
def recreate_dir(dir):
    if os.path.exists(dir):
        shutil.rmtree(dir)
        debug('Deleted {0}'.format(dir))
    os.mkdir(dir)
    debug('Created {0}'.format(dir))

# Remove given file if it exists.
def remove_file_if_exists(path):
    if os.path.exists(path):
        os.remove(path)
        debug('Deleted {0}'.format(path))
    else:
        error('Can not delete {0}. File does not exist.'.format(path))

# Remove files with certain pattern from given directory.
def remove_files_with_pattern(pattern, directory, excluded_files=[]):
    for item in glob.glob(directory + '/' + pattern):
        if item in excluded_files:
            debug('Skipping deletion of ' + item)
            continue
        if os.path.isfile(item):
            os.remove(item)
        else:
            shutil.rmtree(item)
        debug('Deleted ' + item)

# Remove all the contents of the given directory.
def clean_dir(item_pattern, directory, excluded_files=[]):
    for item in glob.glob(directory + '/' + item_pattern):
        if item in excluded_files:
            debug('Skipping deletion of ' + item)
            continue
        if os.path.isfile(item):
            os.remove(item)
        else:
            shutil.rmtree(item)
        debug('Deleted ' + item)

# Copy content of one directory to another
def copy_dir_content(dir_source, dir_destination):
    copy_tree(dir_source, dir_destination)

def copy_file(file_source, file_destination):
    shutil.copyfile(file_source, file_destination)

# ------------------------------------------------------------------
# Adobe AIR methods.

# Run 'compc' command for SDK.
def adobe_air_compc_sdk(root_dir, build_dir):
    path_air_sdk    = get_env_variable('AIR_SDK_PATH');
    file_swc        = '{0}/frameworks/libs/air/airglobal.swc'.format(path_air_sdk)
    compc           = '{0}/bin/compc'.format(path_air_sdk)
    dir_src         = '{0}/default/src'.format(root_dir)
    dir_output      = '{0}/default'.format(build_dir)

    execute_command([compc, '-source-path', dir_src, '-swf-version', '27', '-external-library-path', 
        file_swc, '-include-classes', 'com.adjust.sdk.Adjust', 'com.adjust.sdk.LogLevel', 'com.adjust.sdk.Environment',
        'com.adjust.sdk.AdjustConfig', 'com.adjust.sdk.AdjustAttribution', 'com.adjust.sdk.AdjustEventSuccess',
        'com.adjust.sdk.AdjustEventFailure', 'com.adjust.sdk.AdjustEvent', 'com.adjust.sdk.AdjustSessionSuccess',
        'com.adjust.sdk.AdjustSessionFailure', 'com.adjust.sdk.AdjustTestOptions', '-directory=true', '-output', dir_output])

# Run 'compc' command for SDK test library.
def adobe_air_compc_test(root_dir, build_dir):
    air_sdk_path      = get_env_variable('AIR_SDK_PATH');
    compc             = '{0}/bin/compc'.format(air_sdk_path)
    default_src_dir   = '{0}/default/src'.format(root_dir)
    external_lib_path = '{0}/frameworks/libs/air/airglobal.swc'.format(air_sdk_path)
    output_dir        = '{0}/default'.format(build_dir)

    execute_command([compc, '-source-path', default_src_dir, '-swf-version', '27', '-external-library-path',
        external_lib_path, '-include-classes', 'com.adjust.test.AdjustTest', '-directory=true', '-output', output_dir])

# Run 'compc' command to build .swc file for SDK.
def adobe_air_compc_swc_sdk(root_dir, build_dir):
    air_sdk_path      = get_env_variable('AIR_SDK_PATH');
    compc             = '{0}/bin/compc'.format(air_sdk_path)
    src_dir           = '{0}/src'.format(root_dir)
    external_lib_path = '{0}/frameworks/libs/air/airglobal.swc'.format(air_sdk_path)

    execute_command([compc, '-source-path', src_dir, '-swf-version', '27', '-external-library-path', 
        external_lib_path, '-include-classes', 'com.adjust.sdk.Adjust', 'com.adjust.sdk.LogLevel', 'com.adjust.sdk.Environment',
        'com.adjust.sdk.AdjustConfig', 'com.adjust.sdk.AdjustAttribution', 'com.adjust.sdk.AdjustEventSuccess',
        'com.adjust.sdk.AdjustEventFailure', 'com.adjust.sdk.AdjustEvent', 'com.adjust.sdk.AdjustSessionSuccess',
        'com.adjust.sdk.AdjustSessionFailure', 'com.adjust.sdk.AdjustTestOptions', '-output', '{0}/Adjust.swc'.format(build_dir)])

# Run 'compc' command to build .swc file for SDK test library.
def adobe_air_compc_swc_test(root_dir, build_dir):
    air_sdk_path      = get_env_variable('AIR_SDK_PATH');
    compc             = '{0}/bin/compc'.format(air_sdk_path)
    src_dir           = '{0}/src'.format(root_dir)
    external_lib_path = '{0}/frameworks/libs/air/airglobal.swc'.format(air_sdk_path)

    execute_command([compc, '-source-path', src_dir, '-swf-version', '27', '-external-library-path',
        external_lib_path, '-include-classes', 'com.adjust.test.AdjustTest', '-output', '{0}/AdjustTest.swc'.format(build_dir)])

# Run 'adt' command for SDK.
def adobe_air_adt_sdk(version):
    air_sdk_path  = get_env_variable('AIR_SDK_PATH');
    adt           = '{0}/bin/adt'.format(air_sdk_path)
    
    execute_command([adt, '-package', '-target', 'ane', '../Adjust-{0}.ane'.format(version), 'extension.xml', '-swc', 'Adjust.swc', 
        '-platform', 'Android-ARM', '-C', 'Android', '.', '-platform', 'Android-x86', '-C', 'Android-x86', '.',
        '-platform', 'iPhone-ARM', '-C', 'iOS', '.', '-platformoptions', 'iOS/platformoptions.xml',
        '-platform', 'iPhone-x86', '-C', 'iOS-x86', '.', '-platform', 'default', '-C', 'default', '.'])

# Run 'adt' command for SDK test library.
def adobe_air_adt_test(root_dir, build_dir, version):
    air_sdk_path  = get_env_variable('AIR_SDK_PATH');
    adt           = '{0}/bin/adt'.format(air_sdk_path)

    execute_command([adt, '-package', '-target', 'ane', '{0}/AdjustTest-{1}.ane'.format(root_dir, version), 'extension.xml', 
        '-swc', 'AdjustTest.swc', '-platform', 'Android-ARM', '-C', 'Android', '.', '-platformoptions', 
        '{0}/Android/platformoptions_android.xml'.format(build_dir), '-platform', 'Android-x86', '-C', 'Android-x86', '.',
        '-platform', 'iPhone-ARM', '-C', 'iOS', '.', '-platformoptions', '{0}/iOS/platformoptions_ios.xml'.format(build_dir),
        '-platform', 'iPhone-x86', '-C', 'iOS-x86', '.', '-platform', 'default', '-C', 'default', '.'])

# Run 'unzip' command.
def adobe_air_unzip(dir_path, adjust_swc_path):
    execute_command(['unzip', '-d', dir_path, '-qq', '-o', adjust_swc_path, '-x', 'catalog.xml'])

# Run 'amxmlc' command for Adobe AIR example app.
def adobe_air_amxmlc_example(version):
    execute_command(['amxmlc', '-external-library-path+=lib/Adjust-{0}.ane'.format(version), '-output=Main.swf', '--', 'Main.as'])

# Run 'axmlc' command for Adobe AIR test app.
def adobe_air_amxmlc_test(version):
    execute_command(['amxmlc', '-external-library-path+=lib/Adjust-{0}.ane'.format(version),
        '-external-library-path+=lib/AdjustTest-{0}.ane'.format(version), '-output=Main.swf', '--', 'Main.as'])

# Create example certificate for Adobe AIR app.
def adobe_air_make_sample_cert():
    execute_command(['adt', '-certificate', '-validityPeriod', '25', '-cn', 'SelfSigned', '2048-RSA', 'sampleCert.pfx', 'pass'])

# Package Adobe AIR app APK file.
def adobe_air_package_apk_file():
    debug_blue('Packaging APK file, please wait ...')
    command = 'adt -package -target apk-debug -storetype pkcs12 -keystore sampleCert.pfx Main.apk Main-app.xml Main.swf -extdir lib'
    debug_blue('Executing: [{0}] ...'.format(command))
    os.system('echo pass|{0}'.format(command))
    debug_blue('Packaging APK file done.')

# Package Adobe AIR app IPA file.
def adobe_air_package_ipa_file(prov_profile_path, keystore_file_path, example_app_xml_file):
    debug_blue('Packaging IPA file, please wait ...')
    command = """adt -package -target ipa-debug -provisioning-profile {0} -storetype pkcs12 -keystore {1} Main.ipa {2} Main.swf -extdir lib""".format(prov_profile_path, keystore_file_path, example_app_xml_file)
    debug_blue('Executing: [{0}]'.format(command))
    os.system('echo|{0}'.format(command))
    debug_blue('Packaging IPA file done')

# Check if keystore file exists on given path.
def adobe_air_does_keystore_file_exist(dir_path):
    return len(glob.glob('{0}/*.pfx'.format(dir_path))) > 0

# ------------------------------------------------------------------
# Command execution methods.

# Execute given command.
def execute_command(cmd_params, log=True):
    if log:
        debug_blue('Executing: [{0}]'.format(' '.join([str(cmd) for cmd in cmd_params])))
    subprocess.call(cmd_params)

# Execute xcodebuild command for given target and configuration (debug/release).
def xcode_rebuild(target, configuration):
    execute_command(['xcodebuild', '-target', target, '-configuration', configuration, 'clean', 'build', '-UseModernBuildSystem=NO'])

# Execute xcodebuild command for given target and configuration (debug/release).
def xcode_rebuild_custom_destination(target, configuration, destination):
    execute_command(['xcodebuild', '-target', target, '-configuration', configuration, 'clean', 'build', 'CONFIGURATION_BUILD_DIR={0}'.format(destination), '-UseModernBuildSystem=NO'])

# ------------------------------------------------------------------
# ADB commands.

def adb_uninstall(package):
    execute_command(['adb', 'uninstall', package])

def adb_install_apk(path):
    execute_command(['adb', 'install', '-r', path])

def adb_shell_monkey(package):
    execute_command(['adb', 'shell', 'monkey', '-p', package, '1'])

# ------------------------------------------------------------------
# Random stuff.

# Check if platform is Windows.
def is_windows():
    return platform.system().lower() == 'windows';

# Get system enviornment variable value.
def get_env_variable(var_name):
    return os.environ.get(var_name);
