//
//  HelloWorldLayer.h
//  plop
//
//  Created by Alain Vagner on 04/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "CCTexture2D.h"
#import "JNPMenuScene.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer
@interface JNPIntroBaseLayer : CCLayer
{
}
@end


@interface JNPIntroBaseLayerLoader : NSOperation
{
	JNPIntroBaseLayer *introLayer;
}
@property (nonatomic, retain) JNPIntroBaseLayer *introLayer;
@end
