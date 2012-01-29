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
			case jnpNewLevel:
				image = @"levelup.png";
				son = jnpSndLevel_Up;
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
	switch (mode) {
		case jnpGameover:
			[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[JNPMenuScene node]]];
			break;
		case jnpCredits:
			[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[JNPMenuScene node]]];
			break;
		case jnpNewLevel:
			[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
			break;				
		default:
			break;
	}

	

}


- (void)dealloc {
    
    [super dealloc];
}
@end
