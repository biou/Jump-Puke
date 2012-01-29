//
//  JNPDeath.mm
//  JumpNPuke
//
//  Created by Alain Vagner on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPBasicLayer.h"

static int mode;

@implementation JNPBasicLayer

+(CCScene *) scene:(int) m
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	mode = m;
	JNPBasicLayer * baseLayer = [[JNPBasicLayer alloc] init];

	[scene addChild: baseLayer];
	
	// return the scene
	return scene;
}


- (id)init {
    self = [super init];
    if (self) {
		// init du background
		NSString * image;
		int son;
		switch (mode) {
			case jnpGameover:
				image = @"gameover.png";
				son = jnpSndDie;
				break;
			case jnpCredits:
				image = @"creditsImg.png";
				son = 9;
				break;
			default:
				break;
		}
		
		CCSprite *bgpic = [CCSprite spriteWithFile:image];
		CGSize winsize = [[CCDirector sharedDirector] winSize];
        bgpic.position = ccp(winsize.width/2 , winsize.height/2 );
		[self addChild:bgpic];
		JNPAudioManager *audioManager = [[[JNPAudioManager alloc] init] autorelease];
		[audioManager play:son];
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
