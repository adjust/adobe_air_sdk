#!/usr/bin/python
from scripting_utils import *
import argparse

set_log_tag('BUILD-APP')

if __name__ != "__main__":
    error('Error. Do not import this script, but run it explicitly.')
    exit()

# ------------------------------------------------------------------
# set arguments
parser = argparse.ArgumentParser(description="""Script used to setup example/test app for Adobe Air. 
    To get the up to date .ane, make sure to have called >build_sdk.py< before.""")
parser.add_argument('platform', help='platform on which the scripts will be ran', choices=['android', 'ios'])
parser.add_argument('-t', '--apptype', help='type of the application to be set up', choices=['example', 'test'], default='example')
args = parser.parse_args()

# ------------------------------------------------------------------
# common paths
script_dir = os.path.dirname(os.path.realpath(__file__))
root_dir   = os.path.dirname(os.path.normpath(script_dir))
version    = open(root_dir + '/VERSION').read()
version    = version[:-1] # remove end character

def is_example_app():
    return args.apptype == 'example'
def is_test_app():
    return args.apptype == 'test'

def run_android(root_dir, apptype):
    # ------------------------------------------------------------------
    # paths
    ext_dir         = '{0}/ext/android'.format(root_dir)
    example_dir     = '{0}/example'.format(root_dir)
    test_app_dir    = '{0}/test/app'.format(root_dir)

    # ------------------------------------------------------------------
    # Removing ANE file from app
    debug_green('Removing ANE file from app ...')
    if is_example_app():
        remove_files('Adjust-*.*.*.ane', '{0}/lib'.format(example_dir))
    else:
        remove_files('Adjust-*.*.*.ane', '{0}/lib'.format(test_app_dir))
        remove_files('AdjustTest-*.*.*.ane', '{0}/lib'.format(test_app_dir))

    # adb uninstall
    adb_uninstall('air.com.adjust.examples')

    # ------------------------------------------------------------------
    # Copying ANE to app
    debug_green('Copying ANE to app ...')
    if is_example_app():
        create_dir_if_not_exist('{0}/lib'.format(example_dir))
        copy_file('{0}/Adjust-{1}.ane'.format(root_dir, version), '{0}/lib/Adjust-{1}.ane'.format(example_dir, version))
    else:
        create_dir_if_not_exist('{0}/lib'.format(test_app_dir))
        copy_file('{0}/Adjust-{1}.ane'.format(root_dir, version), '{0}/lib/Adjust-{1}.ane'.format(test_app_dir, version))
        copy_file('{0}/AdjustTest-{1}.ane'.format(root_dir, version), '{0}/lib/AdjustTest-{1}.ane'.format(test_app_dir, version))

    # ------------------------------------------------------------------
    # Running amxmlc
    debug_green('Running amxmlc ...')
    if is_example_app():
        change_dir(example_dir)
        adobe_amxmlc(version)
    else:
        change_dir(test_app_dir)
        adobe_amxmlc_test_app(version)

    if (is_example_app() and not keystore_file_exists_at(example_dir)) or (is_test_app() and not keystore_file_exists_at(test_app_dir)):
        debug_green('Keystore file does not exist, creating one with password [pass]')
        make_sample_cert()
        debug_green('Keystore file created')
    else:
        debug_green('Keystore file exists')

    # ------------------------------------------------------------------
    # Packaging APK file. Password will be entered automatically
    debug_green('Packaging APK file. Password will be entered automatically ...')
    package_apk_file()

    # ------------------------------------------------------------------
    # APK file created. Running ADB install
    debug_green('APK file created. Running ADB install ...')
    adb_install_apk('Main.apk')

    # ------------------------------------------------------------------
    # App installed. Running the app
    if is_test_app():
        debug_green('App installed. Running the app ...')
        adb_shell_monkey('air.com.adjust.examples')

def run_ios(root_dir):
    exit()

try:
    if args.platform == 'android':
        run_android(root_dir, args.apptype)
    else:
        run_ios(root_dir, args.apptype)
finally:
    # remove autocreated python compiled files
    remove_files('*.pyc', script_dir, log=False)

# ------------------------------------------------------------------
# Script completed
debug_green('Script completed!')

