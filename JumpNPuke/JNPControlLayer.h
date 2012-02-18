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
#import "JNPScore.h"
#import "JNPAudioManager.h"
#import "JNPGameLayer.h"


#define NUM_FILTER_POINTS 10  // number of recent points to use in average





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
-(void)resume;

@end
