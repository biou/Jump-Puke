//
//  IntroScene.h
//  plop
//
//  Created by Noliv on 22/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface JNPIntroScene : CCScene {
	int percentFinished;
	CCSprite *loadBar;
	CGRect frame;
}

-(void) updatePercentage:(int)newPercent;
-(void) increasePercentage:(int)amount;

@end
