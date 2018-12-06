##
##  Various util python methods which can be utilized and shared among different scripts
##
import os, shutil, glob, time, sys, platform, subprocess
from distutils.dir_util import copy_tree

def set_log_tag(t):
    global TAG
    TAG = t

############################################################
### colors for terminal (does not work in Windows... of course)

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

############################################################
### file system util methods

def copy_file(sourceFile, destFile):
    debug('copying: {0} -> {1}'.format(sourceFile, destFile))
    shutil.copyfile(sourceFile, destFile)

def copy_files(fileNamePattern, sourceDir, destDir):
    for file in glob.glob(sourceDir + '/' + fileNamePattern):
        if os.path.isdir(file):
            error('Skip copying [{0}]. It\'s a directory.'.format(file))
            continue
        debug('copying: {0} -> {1}'.format(file, destDir))
        shutil.copy(file, destDir)

def copy_dir_contents(source_dir, dest_dir, copy_symlinks=False):
    debug('copying dir contents: {0} -> {1}'.format(source_dir, dest_dir))
    if not copy_symlinks:
        copy_tree(source_dir, dest_dir)
    else:
        shutil.copytree(source_dir, dest_dir, symlinks=True);

def remove_files(fileNamePattern, sourceDir, excluded_files=[], log=True):
    for file in glob.glob(sourceDir + '/' + fileNamePattern):
        if file in excluded_files:
            if log:
                debug('skip deleting: ' + file)
            continue
        if log:
            debug('deleting: ' + file)
        os.remove(file)

def rename_file(fileNamePattern, newFileName, sourceDir):
    for file in glob.glob(sourceDir + '/' + fileNamePattern):
        debug('rename: {0} -> {1}'.format(file, newFileName))
        os.rename(file, sourceDir + '/' + newFileName)

def move_file(file_name, source_dir, dest_dir):
    debug('move file [{0}]: {1} -> {2}'.format(file_name, source_dir, dest_dir))
    shutil.move('{0}/{1}'.format(source_dir, file_name), '{0}/{1}'.format(dest_dir, file_name))

def remove_dir_if_exists(path):
    if os.path.exists(path):
        debug('deleting dir: ' + path)
        shutil.rmtree(path)
    else:
        error('canot delete {0}. dir does not exist'.format(path))

def remove_file_if_exists(path):
    if os.path.exists(path):
        debug('deleting: ' + path)
        os.remove(path)
    else:
        error('canot delete {0}. file does not exist'.format(path))

def clear_dir(dir):
    shutil.rmtree(dir)
    os.mkdir(dir)

def recreate_dir(dir):
    if os.path.exists(dir):
        shutil.rmtree(dir)
    os.mkdir(dir)

def create_dir_if_not_exist(dir):
    if not os.path.exists(dir):
        os.makedirs(dir)

############################################################
### debug messages util methods

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

############################################################
### util

def check_submodule_dir(platform, submodule_dir):
    if not os.path.isdir(submodule_dir) or not os.listdir(submodule_dir):
        error('Submodule [{0}] folder empty. Did you forget to run >> git submodule update --init --recursive << ?'.format(platform))
        exit()

def is_windows():
    return platform.system().lower() == 'windows';

# https://stackoverflow.com/questions/17140886/how-to-search-and-replace-text-in-a-file-using-python
def replace_text_in_file(file_path, substring, replace_with):
    # Read in the file
    with open(file_path, 'r') as file:
        filedata = file.read()

    # Replace the target string
    filedata = filedata.replace(substring, replace_with)

    # Write the file out again
    with open(file_path, 'w') as file:
        file.write(filedata)

def execute_command(cmd_params, log=True):
    if log:
        debug_blue('Executing: [{0}]'.format(' '.join([str(cmd) for cmd in cmd_params])))
    subprocess.call(cmd_params)

def change_dir(dir):
    os.chdir(dir)

def get_env_variable(var_name):
    return os.environ.get(var_name);

def xcode_build(target, configuration='Release'):
    execute_command(['xcodebuild', '-target', target, '-configuration', configuration, '-UseModernBuildSystem=NO'])

def xcode_clean_build(target, configuration='Release'):
    execute_command(['xcodebuild', '-target', target, '-configuration', configuration, 'clean', 'build', '-UseModernBuildSystem=NO'])

def xcode_build_custom(ext_dir):
    execute_command(['xcodebuild', 'CONFIGURATION_BUILD_DIR={0}'.format(ext_dir), '-UseModernBuildSystem=NO'])

def adb_uninstall(package):
    execute_command(['adb', 'uninstall', package])

def adb_install_apk(path):
    execute_command(['adb', 'install', '-r', path])

def adb_shell_monkey(app_package):
    execute_command(['adb', 'shell', 'monkey', '-p', app_package, '1'])

def gradle_make_release_jar(do_clean=False):
    if (do_clean):
        execute_command(['./gradlew', 'clean', 'makeReleaseJar'])
    else:
        execute_command(['./gradlew', 'makeReleaseJar'])

def gradle_make_debug_jar(do_clean=False):
    if (do_clean):
        execute_command(['./gradlew', 'clean', 'makeDebugJar'])
    else:
        execute_command(['./gradlew', 'makeDebugJar'])

def gradle_clean_make_jar():
    execute_command(['./gradlew', 'clean', 'makeJar'])

def gradle_run(options):
    cmd_params = ['./gradlew']
    for opt in options:
        cmd_params.append(opt)
    execute_command(cmd_params)

def inject_cpp_bridge(android_proxy_dir, with_test_lib):
    if with_test_lib:
        execute_command(['{0}/inject_cpp_bridge.sh'.format(android_proxy_dir), '--with-test-lib'])
    else:
        execute_command(['{0}/inject_cpp_bridge.sh'.format(android_proxy_dir)])

def update_dist(root_dir):
    debug_green('Populate dist folder with files needed for clients ...')
    recreate_dir('{0}/dist'.format(root_dir))
    copy_dir_contents('{0}/src'.format(root_dir), '{0}/dist'.format(root_dir))
    remove_dir_if_exists('{0}/dist/test'.format(root_dir))

############################################################
### adobe air specific

def adobe_air_compc(root_dir, build_dir):
    air_sdk_path      = get_env_variable('AIR_SDK_PATH');
    compc             = '{0}/bin/compc'.format(air_sdk_path)
    default_src_dir   = '{0}/default/src'.format(root_dir)
    external_lib_path = '{0}/frameworks/libs/air/airglobal.swc'.format(air_sdk_path)
    output_dir        = '{0}/default'.format(build_dir)

    execute_command([compc, '-source-path', default_src_dir, '-swf-version', '27', '-external-library-path', 
        external_lib_path, '-include-classes', 'com.adjust.sdk.Adjust', 'com.adjust.sdk.LogLevel', 'com.adjust.sdk.Environment',
        'com.adjust.sdk.AdjustConfig', 'com.adjust.sdk.AdjustAttribution', 'com.adjust.sdk.AdjustEventSuccess',
        'com.adjust.sdk.AdjustEventFailure', 'com.adjust.sdk.AdjustEvent', 'com.adjust.sdk.AdjustSessionSuccess',
        'com.adjust.sdk.AdjustSessionFailure', 'com.adjust.sdk.AdjustTestOptions', '-directory=true', '-output', output_dir])

def adobe_air_compc_test_lib(root_dir, build_dir):
    air_sdk_path      = get_env_variable('AIR_SDK_PATH');
    compc             = '{0}/bin/compc'.format(air_sdk_path)
    default_src_dir   = '{0}/default/src'.format(root_dir)
    external_lib_path = '{0}/frameworks/libs/air/airglobal.swc'.format(air_sdk_path)
    output_dir        = '{0}/default'.format(build_dir)

    execute_command([compc, '-source-path', default_src_dir, '-swf-version', '27', '-external-library-path',
        external_lib_path, '-include-classes', 'com.adjust.test.AdjustTest', '-directory=true', '-output', output_dir])

def adobe_air_compc_build_swc(root_dir, build_dir):
    air_sdk_path      = get_env_variable('AIR_SDK_PATH');
    compc             = '{0}/bin/compc'.format(air_sdk_path)
    src_dir           = '{0}/src'.format(root_dir)
    external_lib_path = '{0}/frameworks/libs/air/airglobal.swc'.format(air_sdk_path)

    execute_command([compc, '-source-path', src_dir, '-swf-version', '27', '-external-library-path', 
        external_lib_path, '-include-classes', 'com.adjust.sdk.Adjust', 'com.adjust.sdk.LogLevel', 'com.adjust.sdk.Environment',
        'com.adjust.sdk.AdjustConfig', 'com.adjust.sdk.AdjustAttribution', 'com.adjust.sdk.AdjustEventSuccess',
        'com.adjust.sdk.AdjustEventFailure', 'com.adjust.sdk.AdjustEvent', 'com.adjust.sdk.AdjustSessionSuccess',
        'com.adjust.sdk.AdjustSessionFailure', 'com.adjust.sdk.AdjustTestOptions', '-output', '{0}/Adjust.swc'.format(build_dir)])

def adobe_air_compc_build_swc_test_lib(root_dir, build_dir):
    air_sdk_path      = get_env_variable('AIR_SDK_PATH');
    compc             = '{0}/bin/compc'.format(air_sdk_path)
    src_dir           = '{0}/src'.format(root_dir)
    external_lib_path = '{0}/frameworks/libs/air/airglobal.swc'.format(air_sdk_path)

    execute_command([compc, '-source-path', src_dir, '-swf-version', '27', '-external-library-path',
        external_lib_path, '-include-classes', 'com.adjust.test.AdjustTest', '-output', '{0}/adjust-test.swc'.format(build_dir)])

def adobe_air_unzip(dir_path, adjust_swc_path):
    execute_command(['unzip', '-d', dir_path, '-qq', '-o', adjust_swc_path, '-x', 'catalog.xml'])

def adobe_air_adt(version):
    air_sdk_path  = get_env_variable('AIR_SDK_PATH');
    adt           = '{0}/bin/adt'.format(air_sdk_path)
    
    execute_command([adt, '-package', '-target', 'ane', '../Adjust-{0}.ane'.format(version), 'extension.xml', '-swc', 'Adjust.swc', 
        '-platform', 'Android-ARM', '-C', 'Android', '.', '-platform', 'Android-x86', '-C', 'Android-x86', '.',
        '-platform', 'iPhone-ARM', '-C', 'iOS', '.', '-platformoptions', 'iOS/platformoptions.xml',
        '-platform', 'iPhone-x86', '-C', 'iOS-x86', '.', '-platform', 'default', '-C', 'default', '.'])

def adobe_air_adt_test_lib(root_dir, build_dir, version):
    air_sdk_path  = get_env_variable('AIR_SDK_PATH');
    adt           = '{0}/bin/adt'.format(air_sdk_path)

    execute_command([adt, '-package', '-target', 'ane', '{0}/AdjustTest-{1}.ane'.format(root_dir, version), 'extension.xml', 
        '-swc', 'adjust-test.swc', '-platform', 'Android-ARM', '-C', 'Android', '.', '-platformoptions', 
        '{0}/Android/platformoptions_android.xml'.format(build_dir), '-platform', 'Android-x86', '-C', 'Android-x86', '.',
        '-platform', 'iPhone-ARM', '-C', 'iOS', '.', '-platformoptions', '{0}/iOS/platformoptions_ios.xml'.format(build_dir),
        '-platform', 'iPhone-x86', '-C', 'iOS-x86', '.', '-platform', 'default', '-C', 'default', '.'])

def keystore_file_exists_at(dir_path):
    return len(glob.glob('{0}/*.pfx'.format(dir_path))) > 0

def adobe_amxmlc(version):
    execute_command(['amxmlc', '-external-library-path+=lib/Adjust-{0}.ane'.format(version), '-output=Main.swf', '--', 'Main.as'])

def adobe_amxmlc_test_app(version):
    execute_command(['amxmlc', '-external-library-path+=lib/Adjust-{0}.ane'.format(version),
        '-external-library-path+=lib/AdjustTest-{0}.ane'.format(version), '-output=Main.swf', '--', 'Main.as'])

def make_sample_cert():
    execute_command(['adt', '-certificate', '-validityPeriod', '25', '-cn', 'SelfSigned', '2048-RSA', 'sampleCert.pfx', 'pass'])

def package_apk_file():
    debug_blue('Packaging APK file, please wait ...')
    command = 'adt -package -target apk-debug -storetype pkcs12 -keystore sampleCert.pfx Main.apk Main-app.xml Main.swf -extdir lib'
    debug_blue('Executing: [{0}]'.format(command))
    os.system('echo pass|{0}'.format(command))
    debug_blue('Packaging APK file done')

def package_ipa_file(prov_profile_path, keystore_file_path, example_app_xml_file):
    debug_blue('Packaging IPA file, please wait ...')
    command = """adt -package -target ipa-debug -provisioning-profile {0} -storetype pkcs12 -keystore {1} Main.ipa {2} Main.swf -extdir lib""".format(prov_profile_path, keystore_file_path, example_app_xml_file)
    debug_blue('Executing: [{0}]'.format(command))
    os.system('echo|{0}'.format(command))
    debug_blue('Packaging IPA file done')

############################################################
### nonsense, eyecandy and such

def waiting_animation(duration, step):
    if(duration <= step):
        return

    line = '-'
    line_killer = '\b'
    while duration >= 0:
        duration -= step
        sys.stdout.write(line)
        sys.stdout.flush()
        sys.stdout.write(line_killer)
        line += '-'
        line_killer += '\b'
        if len(line) > 65:
            line = '-'
        time.sleep(step)
