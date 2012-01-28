//
//  JNPControlLayer.m
//  JumpNPuke
//
//  Created by Alain Vagner on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNPControlLayer.h"
#import "JNPPlayer.h"

CCSprite * jumpButton;
CCSprite * pukeButton;
CGSize winSize;
id jumpButtonNormal;
id jumpButtonSelected;
id pukeButtonNormal;
id pukeButtonSelected;

@implementation JNPControlLayer
- (id)init {
    self = [super init];
    if (self) {
		state = kPaddleStateUngrabbed;
		winSize = [[CCDirector sharedDirector] winSize];
		
		jumpButton = [CCSprite spriteWithFile: @"jumpButton.png"];
        jumpButton.position = ccp( 100, 100 );
        [self addChild:jumpButton];
		jumpButtonNormal = [[CCTextureCache sharedTextureCache] addImage:@"jumpButton.png"];
		jumpButtonSelected= [[CCTextureCache sharedTextureCache] addImage:@"jumpButton-selected.png"];	
		pukeButtonNormal = [[CCTextureCache sharedTextureCache] addImage:@"pukeButton.png"];
		pukeButtonSelected= [[CCTextureCache sharedTextureCache] addImage:@"pukeButton-selected.png"];		
		
		pukeButton = [CCSprite spriteWithFile: @"pukeButton.png"];
        pukeButton.position = ccp(winSize.width - 100, 100);
        [self addChild:pukeButton];	
		
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
	if (state != kPaddleStateUngrabbed) return NO;
	state = kPaddleStateGrabbed;
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	if (location.x < winSize.width /2) {
		[jumpButton setTexture:jumpButtonSelected]; 

                
        [ref tellPlayerToJump];
        
        NSLog(@"Jump!\n");
	} else {
		[pukeButton setTexture:pukeButtonSelected];		
		NSLog(@"Puke!\n");			
	}	
	
	return YES;
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	NSAssert(state == kPaddleStateGrabbed, @"Paddle - Unexpected state!");
	state = kPaddleStateUngrabbed;
	[jumpButton setTexture:jumpButtonNormal]; 
	[pukeButton setTexture:pukeButtonNormal]; 
}

-(void)assignGameLayer:(HelloWorldLayer *)gameLayer{
    ref=gameLayer;
}



- (void)dealloc {
    [super dealloc];
}

@end
