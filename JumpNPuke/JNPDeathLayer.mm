//
//  JNPDeath.mm
//  JumpNPuke
//
//  Created by Alain Vagner on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPDeathLayer.h"


@implementation JNPDeathLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	JNPDeathLayer * baseLayer = [JNPDeathLayer node];
	[scene addChild: baseLayer];
	
	// return the scene
	return scene;
}


- (id)init {
    self = [super init];
    if (self) {
		// init du background
		CCSprite *bgpic = [CCSprite spriteWithFile:@"gameover.png"];
		CGSize winsize = [[CCDirector sharedDirector] winSize];
        bgpic.position = ccp(winsize.width/2 , winsize.height/2 );
		[self addChild:bgpic];
		JNPAudioManager *audioManager = [[[JNPAudioManager alloc] init] autorelease];
		[audioManager play:jnpSndDie];
		self.isTouchEnabled = YES;

    }
    return self;
}

- (void)onEnter
{
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director touchDispatcher] removeDelegate:self];
	[super onExit];
}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[JNPMenuScene node]]];
}


- (void)dealloc {
    
    [super dealloc];
}
@end
