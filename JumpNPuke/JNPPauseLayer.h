//
//  JNPPauseLayer.h
//  JumpNPuke
//
//  Created by Alain Vagner on 13/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JNPAudioManager.h"

@class JNPControlLayer;
@class JNPGameScene;


@interface JNPPauseLayer : CCLayer {
		
}

@property (retain) id controlLayer;
@property (retain) id scene;
- (id)init;

@end
