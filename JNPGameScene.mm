//
//  JNPGameScene.mm
//  JumpNPuke
//
//  Created by Alain Vagner on 15/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPGameScene.h"


@implementation JNPGameScene

@synthesize controlLayer;
@synthesize gameLayer;
@synthesize pauseLayer;
@synthesize parallax;

- (id)init {
    self = [super init];
    if (self) {
		
		//pauseLayer = [JNPPauseLayer node];
		gameLayer = [JNPGameLayer node];
		controlLayer = [JNPControlLayer node];
		[controlLayer assignGameLayer:gameLayer];


        /**** parallax ****/
        parallax = [CCParallaxScrollNode node];
        CCSprite *clouds1 = [CCSprite spriteWithFile:@"paralaxe1.png"];
        CCSprite *clouds2 = [CCSprite spriteWithFile:@"paralaxe2.png"];
        CCSprite *clouds1bis = [CCSprite spriteWithFile:@"paralaxe1.png"];
        CCSprite *clouds2bis = [CCSprite spriteWithFile:@"paralaxe2.png"];
        float totalWidth = 4 * clouds1.contentSize.width;
        [parallax addChild:clouds1 z:0 Ratio:ccp(1.3,1) Pos:ccp(0,0) ScrollOffset:ccp(totalWidth,0)];
        [parallax addChild:clouds2 z:0 Ratio:ccp(0.6,1) Pos:ccp(0,0) ScrollOffset:ccp(totalWidth,0)];
        [parallax addChild:clouds1bis z:0 Ratio:ccp(1.3,1) Pos:ccp(clouds1.contentSize.width,0) ScrollOffset:ccp(totalWidth,0)];
        [parallax addChild:clouds2bis z:0 Ratio:ccp(0.6,1) Pos:ccp(clouds2.contentSize.width,0) ScrollOffset:ccp(totalWidth,0)];
        // Add to layer, sprite, etc.
        [self addChild:parallax z:-1];	
		
		[gameLayer setGameScene:self];
		
		
		
		CCLayer *bgLayer = [CCLayer node];
		CGSize s = [CCDirector sharedDirector].winSize;		
		// init du background
		CCSprite *bgpic = [CCSprite spriteWithFile:@"fondpapier.png"];
		bgpic.position = ccp(bgpic.position.x + s.width/2.0, bgpic.position.y+s.height/2.0);
		bgpic.opacity = 160;
		[bgLayer addChild:bgpic];
		[self addChild:bgLayer z:-10];

		
		
		JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
		[audioManager playMusic:1];
		[self addChild:audioManager];
		[gameLayer setAudioManager:audioManager];
		
		// add layer as a child to scene
		//[self addChild: pauseLayer z:-2 tag:3];		
		[self addChild: gameLayer z:5 tag:1];
		[self addChild: controlLayer z:10 tag:2];

    }
    return self;
}




@end
