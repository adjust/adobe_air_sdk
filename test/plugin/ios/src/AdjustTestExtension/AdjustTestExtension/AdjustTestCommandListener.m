//
//  AdjustTestCommandListener.m
//  AdjustTestExtension
//
//  Created by Abdullah Obaied on 20th February 2018.
//  Copyright © 2018-Present Adjust GmbH. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

#import "AdjustTestFREUtils.h"
#import "AdjustTestCommandListener.h"

@implementation AdjustTestCommandListener {
    int orderCounter;
    FREContext *adjustTestFREContext;
}

- (id)initWithContext:(FREContext *)freContext {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    orderCounter = 0;
    adjustTestFREContext = freContext;

    return self;
}

- (void)executeCommandRawJson:(NSString *)json {
    NSError *jsonError;
    NSData *objectData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:objectData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jsonError];

    // Order of packages sent through PluginResult is not reliable, this is solved
    // through a scheduling mechanism in command_executor.js#scheduleCommand() side.
    // The 'order' entry is used to schedule commands.
    NSNumber *num = [NSNumber numberWithInt:orderCounter];
    [dict setObject:num forKey:@"order"];
    orderCounter++;

    // Making a JSON string from dictionary: this step is necessary, using `messageAsDictionary` with `resultWithStatus` method below
    // produced extra objects in the string that were not necessary.
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    NSString *strJsonData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    const char* cResponseData = [strJsonData UTF8String];

    FREDispatchStatusEventAsync(*adjustTestFREContext, (const uint8_t *)"adjust_test_command", (const uint8_t *)cResponseData);
}

@end
