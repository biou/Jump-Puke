//
//  JNPPauseLayer.mm
//  JumpNPuke
//
//  Created by Alain Vagner on 13/02/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPPauseLayer.h"

#import "JNPMenuBaseLayer.h"


@implementation JNPPauseLayer

@synthesize controlLayer;
@synthesize scene;

- (id)init {
    self = [super init];
    if (self) {
		CGSize winsize = [[CCDirector sharedDirector] winSize];
		
		CCMenuItemImage *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"resume-off.png"
															selectedImage: @"resume-on.png"
																   target:self
																 selector:@selector(menu1)];
		CCMenuItemImage *menuItem2 = [CCMenuItemImage itemWithNormalImage:@"quit-off.png"
															selectedImage: @"quit-on.png"
																   target:self
																 selector:@selector(menu2)];
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
		// Arrange the menu items vertically
		[myMenu alignItemsVertically];
		
		myMenu.position = ccp(winsize.width/2, 280);
		
		// add the menu to your scene
		[self addChild:myMenu];
		
        
    }
    return self;
}

-(void)startMenuAction {
	[self unscheduleUpdate];
	JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
	[audioManager play:jnpSndMenu];	
}

-(void)menu1 {
	[self startMenuAction];
	[controlLayer resume];
}

-(void)menu2 {
	[self startMenuAction];	
	[[CCDirector sharedDirector] resume];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPMenuBaseLayer scene]]];    
}



@end
