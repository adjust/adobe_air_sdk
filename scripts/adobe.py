#!/usr/bin/python

from utils import *
import anes as ane
import apps as app
import extensions as extension
import argparse

# Set script tag.
set_log_tag('ADOBE-AIR-SDK')

# Make sure script gets executed and not imported somewhere.
if __name__ != "__main__":
    error('Error. Do not import this script, but run it explicitly.')
    exit()

dir_scripts = os.path.dirname(os.path.realpath(__file__))

# ------------------------------------------------------------------
# Arguments check.

# Usage message.
usage_message = """List of potential commands that can be executed:
                     adobe build-extension sdk android debug
                     adobe build-extension sdk android release
                     adobe build-extension sdk ios debug
                     adobe build-extension sdk ios release
                     adobe build-extension test android debug
                     adobe build-extension test android release
                     adobe build-extension test ios debug
                     adobe build-extension test ios release
                     adobe build-ane sdk
                     adobe build-ane test
                     adobe run-app example android
                     adobe run-app example ios
                     adobe run-app test android
                     adobe run-app test ios"""

# Too few arguments.
if len(sys.argv) < 3 or len(sys.argv) > 5:
    error('Error. Wrong number of arguments.')
    debug(usage_message)
    exit()

# At this point, valid number of arguments has been passed to the script.
# Let's check how many of them are there (can be either 4 or 5).

try:
    if len(sys.argv) == 5:
        # In here we build native extension.

        # argv[1] possible values:
        #  build-extension
        # argv[2] possible values:
        #  sdk
        #  test
        # argv[3] possible values:
        #  android
        #  ios
        # argv[4] possible values:
        #  debug
        #  release

        if sys.argv[1] == 'build-extension':
            if sys.argv[2] == 'sdk':
                if sys.argv[3] == 'android':
                    if sys.argv[4] == 'debug':
                        extension.build_extension_sdk_android_debug()
                    elif sys.argv[4] == 'release':
                        extension.build_extension_sdk_android_release()
                    else:
                        # Invalid parameter name.
                        error('Error. Invalid parameter passed: {0}'.format(sys.argv[4]))
                        debug(usage_message)
                        exit()
                elif sys.argv[3] == 'ios':
                    if sys.argv[4] == 'debug':
                        extension.build_extension_sdk_ios_debug()
                    elif sys.argv[4] == 'release':
                        extension.build_extension_sdk_ios_release()
                    else:
                        # Invalid parameter name.
                        error('Error. Invalid parameter passed: {0}'.format(sys.argv[4]))
                        debug(usage_message)
                        exit()
                else:
                    # Invalid parameter name.
                    error('Error. Invalid parameter passed: {0}'.format(sys.argv[3]))
                    debug(usage_message)
                    exit()
            elif sys.argv[2] == 'test':
                if sys.argv[3] == 'android':
                    if sys.argv[4] == 'debug':
                        extension.build_extension_test_android_debug()
                    elif sys.argv[4] == 'release':
                        extension.build_extension_test_android_release()
                    else:
                        # Invalid parameter name.
                        error('Error. Invalid parameter passed: {0}'.format(sys.argv[4]))
                        debug(usage_message)
                        exit()
                elif sys.argv[3] == 'ios':
                    if sys.argv[4] == 'debug':
                        extension.build_extension_test_ios_debug()
                    elif sys.argv[4] == 'release':
                        extension.build_extension_test_ios_release()
                    else:
                        # Invalid parameter name.
                        error('Error. Invalid parameter passed: {0}'.format(sys.argv[4]))
                        debug(usage_message)
                        exit()
                else:
                    # Invalid parameter name.
                    error('Error. Invalid parameter passed: {0}'.format(sys.argv[3]))
                    debug(usage_message)
                    exit()
            else:
                # Invalid parameter name.
                error('Error. Invalid parameter passed: {0}'.format(sys.argv[2]))
                debug(usage_message)
                exit()
        else:
            # Invalid parameter name.
            error('Error. Invalid parameter passed: {0}'.format(sys.argv[1]))
            debug(usage_message)
            exit()
    elif len(sys.argv) == 3:
        # In here we build ANE.

        # argv[1] possible values:
        #  build-ane
        # argv[2] possible values:
        #  sdk
        #  test

        if sys.argv[1] == 'build-ane':
            if sys.argv[2] == 'sdk':
                extension.build_extension_sdk_android_release()
                extension.build_extension_sdk_ios_release()
                ane.build_ane_sdk()
            elif sys.argv[2] == 'test':
                extension.build_extension_test_android_debug()
                extension.build_extension_test_ios_debug()
                ane.build_ane_test()
            else:
                # Invalid parameter name.
                error('Error. Invalid parameter passed: {0}'.format(sys.argv[2]))
                debug(usage_message)
                exit()
        else:
            # Invalid parameter name.
            error('Error. Invalid parameter passed: {0}'.format(sys.argv[1]))
            debug(usage_message)
            exit()
    else:
        if sys.argv[1] == 'run-app':
            if sys.argv[2] == 'example':
                if sys.argv[3] == 'android':
                    extension.build_extension_sdk_android_release()
                    extension.build_extension_sdk_ios_release()
                    ane.build_ane_sdk()
                    app.build_and_run_app_example_android()
                elif sys.argv[3] == 'ios':
                    extension.build_extension_sdk_android_release()
                    extension.build_extension_sdk_ios_release()
                    ane.build_ane_sdk()
                    app.build_and_run_app_example_ios()
            elif sys.argv[2] == 'test':
                if sys.argv[3] == 'android':
                    extension.build_extension_sdk_android_release()
                    extension.build_extension_sdk_ios_release()
                    extension.build_extension_test_android_debug()
                    extension.build_extension_test_ios_debug()
                    ane.build_ane_sdk()
                    ane.build_ane_test()
                    app.build_and_run_app_test_android()
                elif sys.argv[3] == 'ios':
                    extension.build_extension_sdk_android_release()
                    extension.build_extension_sdk_ios_release()
                    extension.build_extension_test_android_debug()
                    extension.build_extension_test_ios_debug()
                    ane.build_ane_sdk()
                    ane.build_ane_test()
                    app.build_and_run_app_test_ios()
            else:
                # Invalid parameter name.
                error('Error. Invalid parameter passed: {0}'.format(sys.argv[2]))
                debug(usage_message)
                exit()
finally:
    # Remove autocreated Python compiled files.
    remove_files_with_pattern('*.pyc', dir_scripts)
    debug_green('Script completed!')
