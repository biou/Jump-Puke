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

        //id layer = [JNPIntroBaseLayer node];
        //[self addChild:layer];
        
    }
    return self;
}

-(void) updatePercentage:(int)newPercent
{
	percentFinished = newPercent;
	[loadBar setTextureRect:CGRectMake(frame.origin.x, 
									   frame.origin.y, 
									   percentFinished*.01*frame.size.width, 
									   frame.size.height)];
}

-(void) increasePercentage:(int)amount
{
	percentFinished += amount;
	[loadBar setTextureRect:CGRectMake(frame.origin.x, 
									   frame.origin.y, 
									   percentFinished*.01*frame.size.width, 
									   frame.size.height)];
}

@end
