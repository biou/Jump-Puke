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

#define NUM_FILTER_POINTS 10  // number of recent points to use in average


@class JNPGameLayer;

typedef enum tagPaddleState {
	kPaddleStateGrabbed,
	kPaddleStateUngrabbed
} PaddleState;

@interface JNPControlLayer : CCLayer <CCTargetedTouchDelegate,UIAccelerometerDelegate> {
	@private
    PaddleState state;
    JNPGameLayer *ref;
    
    CCLabelTTF *labelScore;
    CCLabelTTF *labelShadowScore;
    CCLabelTTF *labelTime;
    CCLabelTTF *labelShadowTime;
    float accelY;
	int orientation;

}

@property (retain) NSMutableArray *rawAccelY;	

-(void)assignGameLayer:(JNPGameLayer*)gameLayer;
- (void)showScore: (int)score;
- (void)showTime: (int)t;
- (float)getAccelY;

@end
