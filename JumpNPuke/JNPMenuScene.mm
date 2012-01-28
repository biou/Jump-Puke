//
//  MenuScene.m
//  plop
//
//  Created by Noliv on 22/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPMenuScene.h"


@implementation JNPMenuScene

- (id)init {
    self = [super init];
    if (self) {
        id layer = [JNPMenuBaseLayer node];
        [self addChild:layer];
        
    }
    return self;
}
@end
