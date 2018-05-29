//
//  AdjustTestCommandListener.h
//
//  Created by Abdullah Obaied on 20.02.18.
//

#import <Foundation/Foundation.h>
#import <AdjustTestLibrary/ATLTestLibrary.h>
#import "AdjustTestFREUtils.h"

@interface AdjustTestCommandListener : NSObject<AdjustCommandDelegate>

- (id)initWithContext:(FREContext *) _freContext;

@end
