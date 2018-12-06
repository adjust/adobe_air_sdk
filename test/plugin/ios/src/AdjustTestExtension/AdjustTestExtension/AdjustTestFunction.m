//
//  AdjustTestFunction.m
//  AdjustTestExtension
//
//  Created by Abdullah Obaied (@obaied) on 20th February 2018.
//  Copyright © 2012-2018 Adjust GmbH. All rights reserved.
//

#import "AdjustTestFunction.h"
#import "AdjustTestFREUtils.h"
#import "AdjustTestCommandListener.h"

NSMutableArray *selectedTests;
NSMutableArray *selectedTestDirs;
ATLTestLibrary *testLibrary;
FREContext adjustTestFREContext;
AdjustTestCommandListener *adjustCommandListener;

@implementation AdjustTestFunction

@end

FREObject ADJstartTestSession(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *baseUrl = nil;
        adjustTestFREContext = ctx;

        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &baseUrl);
        }

        adjustCommandListener = [[AdjustTestCommandListener alloc] initWithContext:&adjustTestFREContext];
        testLibrary = [ATLTestLibrary testLibraryWithBaseUrl:baseUrl
                                          andCommandDelegate:adjustCommandListener];

        for (id object in selectedTests) {
            [testLibrary addTest:object];
        }
        for (id object in selectedTestDirs) {
            [testLibrary addTestDirectory:object];
        }
        [testLibrary startTestSession:@"adobe_air4.17.0@ios4.17.0"];
    } else {
        NSLog(@"AdjustTestExtension: Bridge startTestSession method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject ADJaddInfoToSend(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 2) {
        NSString *key   = nil;
        NSString *value = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &key);
        }
        if (argv[1] != nil) {
            FREGetObjectAsNativeString(argv[1], &value);
        }
        if (testLibrary != nil) {
            [testLibrary addInfoToSend:key value:value];
        }
    } else {
        NSLog(@"AdjustTestExtension: Bridge addInfoToSend method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject ADJsendInfoToServer(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *basePath = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &basePath);
        }
        if (testLibrary != nil) {
            [testLibrary sendInfoToServer:basePath];
        }
    } else {
        NSLog(@"AdjustTestExtension: Bridge sendInfoToServer method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject ADJaddTest(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *testToAdd = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &testToAdd);
        }
        if (!selectedTests || !selectedTests.count) {
            selectedTests = [NSMutableArray array];
        }
        [selectedTests addObject:testToAdd];
    } else {
        NSLog(@"AdjustTestExtension: Bridge addTest method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}

FREObject ADJaddTestDirectory(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *testDirToAdd = nil;
        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &testDirToAdd);
        }
        if (!selectedTestDirs || !selectedTestDirs.count) {
            selectedTestDirs = [NSMutableArray array];
        }
        [selectedTestDirs addObject:testDirToAdd];
    } else {
        NSLog(@"AdjustTestExtension: Bridge addTestDirectory method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);
    return return_value;
}
