//
//  JNPControlLayer.m
//  JumpNPuke
//
//  Created by Alain Vagner on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNPControlLayer.h"
#import "JNPGameLayer.h"

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
		jumpButtonNormal = [[[CCTextureCache sharedTextureCache] addImage:@"jumpButton.png"] retain];
		jumpButtonSelected= [[[CCTextureCache sharedTextureCache] addImage:@"jumpButton-selected.png"] retain];	
		pukeButtonNormal = [[[CCTextureCache sharedTextureCache] addImage:@"pukeButton.png"] retain];
		pukeButtonSelected= [[[CCTextureCache sharedTextureCache] addImage:@"pukeButton-selected.png"] retain];		
		
		pukeButton = [CCSprite spriteWithFile: @"pukeButton.png"];
        pukeButton.position = ccp(winSize.width - 100, 100);
        [self addChild:pukeButton];	
		
        
        JNPScore * s = [JNPScore jnpscore];
        int t = [s getScore];
        t += 0;
        NSString * str = [NSString stringWithFormat:@"Score: %d", t];
        CGSize labelSize;
        labelSize.width = 400;
        labelSize.height= 50;
        label = [CCLabelTTF labelWithString:str dimensions:labelSize alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:42];
        [label setColor:ccc3(240, 0, 0)];
        [label setPosition: ccp(213, winSize.height - 30)];
        labelShadow = [CCLabelTTF labelWithString:str dimensions:labelSize alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:42];
        [labelShadow setColor:ccc3(0, 0, 0)];
        [labelShadow setPosition: ccp(215, winSize.height - 31)];

        
        [self addChild: labelShadow];
        [self addChild: label];
        
		self.isTouchEnabled = YES;
	}
    return self;
}

- (void)showScore: (int)score {
    NSString * str = [NSString stringWithFormat:@"Score: %d", score];
    [labelShadow setString:str];
    [label setString:str];
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
    NSLog(@"##############################################");
    NSLog(@"########        TOUCH BEGAN        ###########");
    NSLog(@"##############################################");
    
	if (state != kPaddleStateUngrabbed) return NO;
	state = kPaddleStateGrabbed;
	
	CGPoint location = [touch locationInView: [touch view]];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	if (location.x < winSize.width /2) {
		[jumpButton setTexture:jumpButtonSelected]; 

        [ref tellPlayerToJump];
        
	} else {
		[pukeButton setTexture:pukeButtonSelected];		

        [ref tellPlayerToPuke:location];			
	}	
	
	return YES;
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"##############################################");
    NSLog(@"########        TOUCH ENDED        ###########");
    NSLog(@"##############################################");
	NSAssert(state == kPaddleStateGrabbed, @"Paddle - Unexpected state!");
	state = kPaddleStateUngrabbed;
	[jumpButton setTexture:jumpButtonNormal]; 
	[pukeButton setTexture:pukeButtonNormal]; 
}

-(void)assignGameLayer:(JNPGameLayer *)gameLayer{
    ref=gameLayer;
}



- (void)dealloc {
    [super dealloc];
}

@end
