//
//  AdjustTestFunction.m
//  AdjustTestExtension
//
//  Created by Pedro Filipe on 07/08/14.
//  Copyright (c) 2014 adjust. All rights reserved.
//

#import "AdjustTestFunction.h"
#import "AdjustTestFREUtils.h"
#import "AdjustTestCommandListener.h"

FREContext AdjustTestFREContext;
ATLTestLibrary *testLibrary;
AdjustTestCommandListener *adjustCommandListener;
NSMutableArray *selectedTests;
NSMutableArray *selectedTestDirs;

@implementation AdjustTestFunction

@end

FREObject ADJstartTestSession(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    if (argc == 1) {
        NSString *baseUrl       = nil;
        AdjustTestFREContext = ctx;

        if (argv[0] != nil) {
            FREGetObjectAsNativeString(argv[0], &baseUrl);
        }

        adjustCommandListener = [[AdjustTestCommandListener alloc] initWithContext:&AdjustTestFREContext];

        testLibrary = [ATLTestLibrary testLibraryWithBaseUrl:baseUrl
            andCommandDelegate:adjustCommandListener];

        for (id object in selectedTests) {
            [testLibrary addTest:object];
        }

        for (id object in selectedTestDirs) {
            [testLibrary addTestDirectory:object];
        }

        [testLibrary startTestSession:@"adobe_air4.13.0@ios4.13.0"];
    } else {
        NSLog(@"Adjust: Bridge startTestSession method triggered with wrong number of arguments");
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
            NSLog(@"addInfoToSend(): with key %@ and %@", key, value);
            [testLibrary addInfoToSend:key value:value];
        }
    } else {
        NSLog(@"Adjust: Bridge addInfoToSend method triggered with wrong number of arguments");
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
            NSLog(@"sendInfoToServer(): with basePath %@", basePath);
            [testLibrary sendInfoToServer:basePath];
        }
    } else {
        NSLog(@"Adjust: Bridge sendInfoToServer method triggered with wrong number of arguments");
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

        NSLog(@"addtest(): %@", testToAdd);
        [selectedTests addObject:testToAdd];
    } else {
        NSLog(@"Adjust: Bridge addTest method triggered with wrong number of arguments");
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

        NSLog(@"addtestDirectory(): %@", testDirToAdd);
        [selectedTestDirs addObject:testDirToAdd];
    } else {
        NSLog(@"Adjust: Bridge addTestDirectory method triggered with wrong number of arguments");
    }

    FREObject return_value;
    FRENewObjectFromBool(true, &return_value);

    return return_value;
}
