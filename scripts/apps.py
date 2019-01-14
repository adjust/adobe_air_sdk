from utils import *

def build_and_run_app_example_android():
    dir_script  = os.path.dirname(os.path.realpath(__file__))
    dir_root    = os.path.dirname(os.path.normpath(dir_script))
    dir_app     = '{0}/example'.format(dir_root)
    version     = open(dir_root + '/VERSION').read()
    version     = version[:-1] # remove end character

    debug_green('Removing SDK ANE file from example app ...')
    remove_files_with_pattern('Adjust-*.*.*.ane', '{0}/lib/'.format(dir_app))

    debug_green('Copying SDK ANE file to example app ...')
    create_dir_if_not_present('{0}/lib'.format(dir_app))
    copy_file('{0}/Adjust-{1}.ane'.format(dir_root, version), '{0}/lib/Adjust-{1}.ane'.format(dir_app, version))

    debug_green('Running \'amxmlc\' ...')
    change_dir(dir_app)
    adobe_air_amxmlc_example(version)

    if not adobe_air_does_keystore_file_exist(dir_app):
        debug_green('Keystore file does not exist, creating one with password [pass] ...')
        adobe_air_make_sample_cert()
        debug_green('Keystore file created.')
    else:
        debug_green('Keystore file exists.')

    debug_green('Uninstalling air.com.adjust.examples package from test device ...')
    adb_uninstall('air.com.adjust.examples')

    debug_green('Packaging APK file. Password will be entered automatically ...')
    adobe_air_package_apk_file()

    debug_green('Installing air.com.adjust.examples package to test device ...')
    adb_install_apk('Main.apk')

    debug_green('Example app installed. Starting the example app on the device ...')
    adb_shell_monkey('air.com.adjust.examples')

def build_and_run_app_test_android():
    dir_script  = os.path.dirname(os.path.realpath(__file__))
    dir_root    = os.path.dirname(os.path.normpath(dir_script))
    dir_app     = '{0}/test/app'.format(dir_root)
    version     = open(dir_root + '/VERSION').read()
    version     = version[:-1] # remove end character

    debug_green('Removing SDK and test library ANE files from test app ...')
    remove_files_with_pattern('Adjust-*.*.*.ane', '{0}/lib/'.format(dir_app))
    remove_files_with_pattern('AdjustTest-*.*.*.ane', '{0}/lib'.format(dir_app))

    debug_green('Copying SDK and test library ANE files to test app ...')
    create_dir_if_not_present('{0}/lib'.format(dir_app))
    copy_file('{0}/Adjust-{1}.ane'.format(dir_root, version), '{0}/lib/Adjust-{1}.ane'.format(dir_app, version))
    copy_file('{0}/AdjustTest-{1}.ane'.format(dir_root, version), '{0}/lib/AdjustTest-{1}.ane'.format(dir_app, version))

    debug_green('Running \'amxmlc\' ...')
    change_dir(dir_app)
    adobe_air_amxmlc_test(version)

    if not adobe_air_does_keystore_file_exist(dir_app):
        debug_green('Keystore file does not exist, creating one with password [pass] ...')
        adobe_air_make_sample_cert()
        debug_green('Keystore file created.')
    else:
        debug_green('Keystore file exists.')

    debug_green('Uninstalling air.com.adjust.examples package from test device ...')
    adb_uninstall('air.com.adjust.examples')

    debug_green('Packaging APK file. Password will be entered automatically ...')
    adobe_air_package_apk_file()

    debug_green('Installing air.com.adjust.examples package to test device ...')
    adb_install_apk('Main.apk')

    debug_green('Example app installed. Starting the example app on the device ...')
    adb_shell_monkey('air.com.adjust.examples')

def build_and_run_app_example_ios():
    dir_script      = os.path.dirname(os.path.realpath(__file__))
    dir_root        = os.path.dirname(os.path.normpath(dir_script))
    dir_app         = '{0}/example'.format(dir_root)
    version         = open(dir_root + '/VERSION').read()
    version         = version[:-1] # remove end character
    file_app_xml    = '{0}/Main-app.xml'.format(dir_app)

    path_prov_profile  = get_env_variable('DEV_ADOBE_PROVISIONING_PROFILE_PATH')
    path_keystore_file = get_env_variable('KEYSTORE_FILE_PATH')

    debug_green('Removing SDK ANE file from example app ...')
    remove_files_with_pattern('Adjust-*.*.*.ane', '{0}/lib/'.format(dir_app))

    debug_green('Copying SDK ANE file to example app ...')
    create_dir_if_not_present('{0}/lib'.format(dir_app))
    copy_file('{0}/Adjust-{1}.ane'.format(dir_root, version), '{0}/lib/Adjust-{1}.ane'.format(dir_app, version))

    debug_green('Running \'amxmlc\' ...')
    change_dir(dir_app)
    adobe_air_amxmlc_example(version)

    if not adobe_air_does_keystore_file_exist(dir_app):
        debug_green('Keystore file does not exist, creating one with password [pass] ...')
        adobe_air_make_sample_cert()
        debug_green('Keystore file created.')
    else:
        debug_green('Keystore file exists.')

    debug_green('Packaging IPA file ...')
    adobe_air_package_ipa_file(path_prov_profile, path_keystore_file, file_app_xml)

def build_and_run_app_test_ios():
    dir_script      = os.path.dirname(os.path.realpath(__file__))
    dir_root        = os.path.dirname(os.path.normpath(dir_script))
    dir_app         = '{0}/test/app'.format(dir_root)
    version         = open(dir_root + '/VERSION').read()
    version         = version[:-1] # remove end character
    file_app_xml    = '{0}/Main-app.xml'.format(dir_app)

    path_prov_profile  = get_env_variable('DEV_ADOBE_PROVISIONING_PROFILE_PATH')
    path_keystore_file = get_env_variable('KEYSTORE_FILE_PATH')

    debug_green('Removing SDK and test library ANE files from test app ...')
    remove_files_with_pattern('Adjust-*.*.*.ane', '{0}/lib/'.format(dir_app))
    remove_files_with_pattern('AdjustTest-*.*.*.ane', '{0}/lib'.format(dir_app))

    debug_green('Copying SDK and test library ANE files to test app ...')
    create_dir_if_not_present('{0}/lib'.format(dir_app))
    copy_file('{0}/Adjust-{1}.ane'.format(dir_root, version), '{0}/lib/Adjust-{1}.ane'.format(dir_app, version))
    copy_file('{0}/AdjustTest-{1}.ane'.format(dir_root, version), '{0}/lib/AdjustTest-{1}.ane'.format(dir_app, version))

    debug_green('Running \'amxmlc\' ...')
    change_dir(dir_app)
    adobe_air_amxmlc_test(version)

    if not adobe_air_does_keystore_file_exist(dir_app):
        debug_green('Keystore file does not exist, creating one with password [pass] ...')
        adobe_air_make_sample_cert()
        debug_green('Keystore file created.')
    else:
        debug_green('Keystore file exists.')

    debug_green('Packaging IPA file ...')
    adobe_air_package_ipa_file(path_prov_profile, path_keystore_file, file_app_xml)