//
//  JNPControlLayer.m
//  JumpNPuke
//
//  Created by Alain Vagner on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "JNPControlLayer.h"

#import "JNPGameScene.h"

CCSprite * jumpButton;
CCSprite * pukeButton;
CGSize winSize;
id jumpButtonNormal;
id jumpButtonSelected;
id pukeButtonNormal;
id pukeButtonSelected;



@implementation JNPControlLayer


@synthesize rawAccelY;

- (id)init {
    self = [super init];
    if (self) {
		state = kPaddleStateUngrabbed;
		winSize = [[CCDirector sharedDirector] winSize];
		orientation = 1;
		
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
		
        
		// Affichage du score
        JNPScore * s = [JNPScore jnpscore];
        int t = [s getScore];
        t += 0;
        NSString * str = [NSString stringWithFormat:@"Score: %d", t];
        CGSize labelSize;
        labelSize.width = 400;
        labelSize.height= 50;
        labelScore = [CCLabelTTF labelWithString:str dimensions:labelSize alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:42];
        [labelScore setColor:ccc3(240, 0, 0)];
        [labelScore setPosition: ccp(213, winSize.height - 30)];
        labelShadowScore = [CCLabelTTF labelWithString:str dimensions:labelSize alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:42];
        [labelShadowScore setColor:ccc3(0, 0, 0)];
        [labelShadowScore setPosition: ccp(215, winSize.height - 31)];
        [self addChild: labelShadowScore];
        [self addChild: labelScore];
		
		int time = [s getTime];
        NSString * strTime = [NSString stringWithFormat:@"Time: %d", time];
        CGSize labelSizeTime;
        labelSizeTime.width = 400;
        labelSizeTime.height= 50;
        labelTime = [CCLabelTTF labelWithString:strTime dimensions:labelSize alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:42];
        [labelTime setColor:ccc3(240, 0, 0)];
        [labelTime setPosition: ccp(600, winSize.height - 30)];
        labelShadowTime = [CCLabelTTF labelWithString:strTime dimensions:labelSize alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:42];
        [labelShadowTime setColor:ccc3(0, 0, 0)];
        [labelShadowTime setPosition: ccp(602, winSize.height - 31)];
        [self addChild: labelShadowTime];
        [self addChild: labelTime];		
		

		CCMenuItemImage *menuItem3 = [CCMenuItemImage itemWithNormalImage:@"pause-off.png"
															selectedImage: @"pause-on.png"
																   target:self
																 selector:@selector(menuPause)];
        
        CCMenu * myMenu2 = [CCMenu menuWithItems:menuItem3, nil];
		
        [myMenu2 alignItemsHorizontally];		
        myMenu2.position = ccp(1024-100, 768-100);
        [self addChild:myMenu2];
		
		// Initialisation de l'acelerometre
		
		[self setRawAccelY:[NSMutableArray arrayWithCapacity:NUM_FILTER_POINTS]];
        for (int i = 0; i < NUM_FILTER_POINTS; i++)
        {
            [[self rawAccelY] addObject:[NSNumber numberWithFloat:0.0]];
        } 
		
        UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
        accelerometer.updateInterval = 1.0/60.0;
        accelerometer.delegate = self;		
        
		self.isTouchEnabled = YES;
	}
    return self;
}

-(void)setGameScene:(JNPGameScene *)s {
	gameScene = s;
}

- (void)showScore: (int)score {
    NSString * str = [NSString stringWithFormat:@"Score: %d", score];
    [labelShadowScore setString:str];
    [labelScore setString:str];
}

- (void)showTime: (int)t {
    NSString * str = [NSString stringWithFormat:@"Time: %d", t];
    [labelShadowTime setString:str];
    [labelTime setString:str];
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

- (float)getAccelY
{
    return accelY;
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{    
    [[self rawAccelY] insertObject:[NSNumber numberWithFloat: acceleration.y] atIndex:0];
    [[self rawAccelY] removeObjectAtIndex:NUM_FILTER_POINTS];
    
    // perform averaging
    accelY = 0.0;
    for (NSNumber *raw in [self rawAccelY])
    {
        accelY += [raw floatValue];
    }    
	UIInterfaceOrientation u= [[CCDirector sharedDirector] interfaceOrientation];
	if (u == UIInterfaceOrientationLandscapeLeft) {
		orientation = 1;
	} else if (u == UIInterfaceOrientationLandscapeRight) {
		orientation = -1;
	}

	accelY *= orientation;
	
    //NSLog(@"accel.y = %f - valeurmem = %f -- prout %f", accelY, [(NSNumber *)[[self rawAccelY] objectAtIndex:0] floatValue],acceleration.y);
    
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Désactivation temporaire du lock sur les boutons pour étudier le comportement (à cause du bug de blocage en mode jump)     
	// if (state != kPaddleStateUngrabbed) return NO;
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
    // Désactivation temporaire du lock sur les boutons pour étudier le comportement (à cause du bug de blocage en mode jump) 
	// NSAssert(state == kPaddleStateGrabbed, @"Paddle - Unexpected state!");
	state = kPaddleStateUngrabbed;
	[jumpButton setTexture:jumpButtonNormal]; 
	[pukeButton setTexture:pukeButtonNormal]; 
}

-(void)assignGameLayer:(JNPGameLayer *)gameLayer{
    ref=gameLayer;
}

-(void)menuPause {
	JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
	[audioManager play:jnpSndMenu];	
	[ref pauseSchedulerAndActions];
	[self pauseSchedulerAndActions];
	[gameScene showPauseLayer];
	
}

-(void)resume {
	[self resumeSchedulerAndActions];
	[ref resumeSchedulerAndActions];
	[gameScene hidePauseLayer];
}

- (void) dealloc
{
	UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.delegate = nil;		
	
	[super dealloc];
}

@end
