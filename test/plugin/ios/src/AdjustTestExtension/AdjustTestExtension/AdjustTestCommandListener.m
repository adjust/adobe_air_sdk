//
//  AdjustTestCommandListener.m
//
//  Created by Abdullah Obaied on 20.02.18.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "AdjustTestCommandListener.h"
#import "AdjustTestFREUtils.h"

@interface AdjustTestCommandListener ()

@end

@implementation AdjustTestCommandListener {
    int orderCounter;
    FREContext *AdjustTestFREContext;
}

- (id)initWithContext:(FREContext *) _freContext {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    orderCounter = 0;
    AdjustTestFREContext = _freContext;
    
    return self;
}

- (void)executeCommandRawJson:(NSString *)json {
    NSLog(@"executeCommandRawJson: %@", json);
    
    NSError *jsonError;
    NSData *objectData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    // Order of packages sent through PluginResult is not reliable, this is solved
    //  through a scheduling mechanism in command_executor.js#scheduleCommand() side.
    // The 'order' entry is used to schedule commands
    NSNumber *_num = [NSNumber numberWithInt:orderCounter];
    [dict setObject:_num forKey:@"order"];
    orderCounter++;
    
    // Making a JSON string from dictionary: this step is necessary, using `messageAsDictionary` with `resultWithStatus` method below
    // produced extra objects in the string that were not necessary.
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    NSString * strJsonData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    const char* cResponseData = [strJsonData UTF8String];

    FREDispatchStatusEventAsync(*AdjustTestFREContext,
            (const uint8_t *)"AdjustTest_command",
            (const uint8_t *)cResponseData);
}

@end
