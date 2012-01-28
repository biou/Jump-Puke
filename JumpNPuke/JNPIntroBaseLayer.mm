//
//  HelloWorldLayer.m
//  plop
//
//  Created by Alain Vagner on 04/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "JNPIntroBaseLayer.h"

CCSprite *logo;

// IntroBaseLayer implementation
@implementation JNPIntroBaseLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {

		// logo qui va s'animer
        logo = [CCSprite spriteWithFile: @"intro.png"];
		CGSize winsize = [[CCDirector sharedDirector] winSize];
		
		// fond d'écran
		//CCSprite * bg = [CCSprite spriteWithFile:@"intro-back.png"];
		//bg.position = ccp(winsize.width/2, winsize.height/2);
		//[self addChild:bg z:0];
		
		NSLog(@"winsize.width: %f\n", winsize.width);
		NSLog(@"winsize.height: %f\n", winsize.height);	
		
		
        logo.position = ccp(winsize.width/2 , winsize.height+(457/2) );
		[self addChild:logo];
        
		// animation du logo
		CGPoint location = ccp(winsize.width/2,winsize.height/2);
		[logo runAction: [CCMoveTo actionWithDuration:1 position:location]];          

		// Pour éviter de saccader l'animation lors du chargement du son, on préload le son maintenant et on le schedule quand on veut. Aussi, on unload le son dans la méthode dealloc (j'imagine que c'est nécessaire, je ne l'ai lu nulle part mais c'est logique.
        // à noter également qu'il faut éviter les sons en wav et qu'il est facile de convertir en .caf… j'amènerai un script pour faire cette conversion tt seule
        //[[SimpleAudioEngine sharedEngine] preloadEffect:@"gameboy-startup.wav"];
		[self schedule:@selector(introSound:) interval:0.65];
		[self schedule:@selector(toNextScene:) interval:3.8];
    
    }
	return self;
}
                                 
- (void) toNextScene:(ccTime) dt {
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.75f scene:[JNPMenuScene node]]];
}

- (void) introSound:(ccTime) dt {
	//[[SimpleAudioEngine sharedEngine] playEffect:@"gameboy-startup.wav"];
	[self unschedule:@selector(introSound:)];
}



- (void)dealloc {
    
    // unload des sons préchargés dont on ne se servira plus.
    //[[SimpleAudioEngine sharedEngine] unloadEffect:@"gameboy-startup.wav"];
    
    [super dealloc];
}


@end
