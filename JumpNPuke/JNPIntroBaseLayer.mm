//
//  HelloWorldLayer.m
//  plop
//
//  Created by Alain Vagner on 04/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "JNPIntroBaseLayer.h"

#import "AppDelegate.h"


//------------------------
//This is the helper class to load the JNPIntroBaseLayer
//
@implementation JNPIntroBaseLayerLoader
@synthesize introLayer;

-(void) main 
{
	[introLayer
	 performSelectorOnMainThread:@selector(loadResources:)
	 withObject:self
	 waitUntilDone:YES];	
}
@end
//------------------------



// IntroBaseLayer implementation
@implementation JNPIntroBaseLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {

		// logo qui va s'animer
        CCSprite *logo = [CCSprite spriteWithFile:@"intro.png"];
		CGSize winsize = [[CCDirector sharedDirector] winSize];
		
		// fond d'écran
		//CCSprite * bg = [CCSprite spriteWithFile:@"intro-back.png"];
		//bg.position = ccp(winsize.width/2, winsize.height/2);
		//[self addChild:bg z:0];
		
		NSLog(@"winsize.width: %f\n", winsize.width);
		NSLog(@"winsize.height: %f\n", winsize.height);	
		
		
        //logo.position = ccp(winsize.width/2 , winsize.height+(457/2) );
		logo.position = ccp(winsize.width/2 , winsize.height/2 );
		[self addChild:logo];
        
		// animation du logo
		//CGPoint location = ccp(winsize.width/2,winsize.height/2);
		//[logo runAction: [CCMoveTo actionWithDuration:1 position:location]];          

        JNPIntroBaseLayerLoader *loader = [[JNPIntroBaseLayerLoader alloc] init];
		loader.introLayer = self;
		[[(AppController*)[[UIApplication sharedApplication] delegate] queue] addOperation:loader];
		[loader release];
    
    }
	return self;
}


- (void)dealloc {
    
    [super dealloc];
}



-(BOOL) loadResources:(id)sender
{
    
	NSLog(@"Loading resources");
	
    JNPAudioManager *am = [[JNPAudioManager alloc] init];
    [am preload];
	
	//Report back to the delegate that the loading is done. 
	[(AppController*)[[UIApplication sharedApplication] delegate] 	  
	   performSelectorOnMainThread:@selector(reportProgressDone:)
	   withObject:self
	   waitUntilDone:YES];
	
	return YES;
}	


@end
