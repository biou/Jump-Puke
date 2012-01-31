//
//  JNPGameLayer.m
//  plop
//
//  Created by Alain Vagner on 04/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "JNPIntroBaseLayer.h"


// IntroBaseLayer implementation
@implementation JNPIntroBaseLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		JNPAudioManager *am = [JNPAudioManager sharedAM];
		// [am preload];
        
		// logo qui va s'animer
        CCSprite *logo = [CCSprite spriteWithFile:@"intro.png"];
		CGSize winsize = [[CCDirector sharedDirector] winSize];
		
		// fond d'écran		
		
        //logo.position = ccp(winsize.width/2 , winsize.height+(457/2) );
		logo.position = ccp(winsize.width/2 , winsize.height/2 );
		[self addChild:logo];
        
		// animation du logo
		//CGPoint location = ccp(winsize.width/2,winsize.height/2);
		//[logo runAction: [CCMoveTo actionWithDuration:1 position:location]];          

        // Pour éviter de saccader l'animation lors du chargement du son, on préload le son maintenant et on le schedule quand on veut. 
        // Aussi, on unload le son dans la méthode dealloc (j'imagine
        // à noter également qu'il faut éviter les sons en wav et qu'il est facile de convertir en .caf… j'amènerai un script pour faire cette
        // conversion tt seule
        [self schedule:@selector(introSound:) interval:0.65];
        [self schedule:@selector(toNextScene:) interval:3.8];
    }
    return self;
}

- (void) toNextScene:(ccTime) dt {
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.75f scene:[JNPMenuScene node]]];
}

- (void) introSound:(ccTime) dt {
    JNPAudioManager *am = [JNPAudioManager sharedAM];
	[am play:jnpSndLevel_Up];
    [self unschedule:@selector(introSound:)];
}


- (void)dealloc {
    
    // unload des sons préchargés dont on ne se servira plus.
    [super dealloc];
}

@end
