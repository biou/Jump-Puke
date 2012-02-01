//
//  JNPControlLayer.h
//  JumpNPuke
//
//  Created by Alain Vagner on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCTouchDispatcher.h"

@class JNPGameLayer;

typedef enum tagPaddleState {
	kPaddleStateGrabbed,
	kPaddleStateUngrabbed
} PaddleState;

@interface JNPControlLayer : CCLayer <CCTargetedTouchDelegate> {
	@private
    PaddleState state;
    JNPGameLayer *ref;
    
    CCLabelTTF *label;
    CCLabelTTF *labelShadow;
}

-(void)assignGameLayer:(JNPGameLayer*)gameLayer;
- (void)showScore: (int)score;

@end
