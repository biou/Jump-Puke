//
//  IntroScene.m
//  plop
//
//  Created by Noliv on 22/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPIntroScene.h"
#import "JNPIntroBaseLayer.h"


@implementation JNPIntroScene

- (id)init {
    self = [super init];
    if (self) {
        id layer = [JNPIntroBaseLayer node];
        
        [self addChild:layer];
        
    }
    return self;
}


@end
