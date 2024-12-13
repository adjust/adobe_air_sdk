//
//  AdjustTestCommandListener.h
//  AdjustTestExtension
//
//  Created by Abdullah Obaied on 20th February 2018.
//  Copyright © 2018-Present Adjust GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdjustTestLibrary/ATLTestLibrary.h>
#import "AdjustTestFREUtils.h"

@interface AdjustTestCommandListener : NSObject<AdjustCommandDelegate>

- (id)initWithContext:(FREContext *)freContext;

@end
