//
//  MenuBaseLayer.m
//  plop
//
//  Created by Alain Vagner on 22/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPMenuBaseLayer.h"
#import "AppDelegate.h"
#import "GCHelper.h"

JNPAudioManager * audioManager;

@implementation JNPMenuBaseLayer

- (id)init {
    self = [super init];
    if (self) {
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Intro.aifc" loop:YES];
        
		// logo qui va s'animer
        CCSprite * logo = [CCSprite spriteWithFile: @"fond-menu.png"];
		CGSize winsize = [[CCDirector sharedDirector] winSize];
        logo.position = ccp(winsize.width/2 , winsize.height/2 );
		[self addChild:logo z:0];	
		
		
		
		// http://www.cocos2d-iphone.org/wiki/doku.php/prog_guide:lesson_3._menus_and_scenes
        // [self setUpMenus];
        
		CCMenuItemImage *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"start-over.png"
            selectedImage: @"start.png"
            target:self
            selector:@selector(menu1)];
        CCMenuItemImage *menuItem2 = [CCMenuItemImage itemWithNormalImage:@"credits.png"
        selectedImage: @"credits-over.png"
        target:self
        selector:@selector(menu2)];
        
        CCMenuItemImage *menuItem3 = [CCMenuItemImage itemWithNormalImage:@"help.png"
            selectedImage: @"help-on.png"
            target:self
            selector:@selector(menu3)];
		
		// FIXME changer le graphisme du bouton leaderboard
		CCMenuItemImage *menuItem4 = [CCMenuItemImage itemWithNormalImage:@"scores.png"
			selectedImage: @"scores-over.png"
			target:self
			selector:@selector(menu4)];
        
        
		CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
		BOOL userAuth = [[GCHelper sharedInstance] isUserAuthenticated];
        if (userAuth) {
			NSLog(@"user authenticated, we add the menu item\n");
			[myMenu addChild:menuItem4];
		}
		[myMenu addChild:menuItem2];
        		
        // Arrange the menu items vertically
        [myMenu alignItemsVertically];

		myMenu.position = ccp(winsize.width/2, 280);
        
        // add the menu to your scene
        [self addChild:myMenu];
        
        CCMenu * myMenu2 = [CCMenu menuWithItems:menuItem3, nil];

        [myMenu2 alignItemsHorizontally];		
        myMenu2.position = ccp(70, 113);
        [self addChild:myMenu2];
        
        
		// increment level
		JNPScore * sc = [JNPScore jnpscore];
		[sc setLevel:1];
		[sc setScore:0];
		
        // Il ne sert à rien d'activer le "Touch" sur ce Layer car le menu, lui, est TouchEnabled.
        // self.isTouchEnabled = YES;		
    }
    return self;
}



-(void)menu1 {
	[self startMenuAction];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:[JNPGameLayer scene]]];
    
}

-(void)menu2 {
	[self startMenuAction];	
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPBasicLayer scene:jnpCredits]]];    
}

-(void)menu3 {
	[self startMenuAction];
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPBasicLayer scene:jnpHelp]]];    
}

-(void)menu4 {
	[self startMenuAction];
	[[GCHelper sharedInstance] displayLeaderboard];
}

-(void)startMenuAction {
	[self unscheduleAllSelectors];
	[self unscheduleUpdate];
	JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
	[audioManager play:jnpSndMenu];	
}

@end
