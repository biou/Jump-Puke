//
//  JNPAudioManager.m
//  PawAppsExample_SimpleAudioEngine
//
//  Created by Vincent on 27/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "JNPAudioManager.h"
#import "SimpleAudioEngine.h"
#import "CCNode.h"

@implementation JNPAudioManager
@synthesize counter;
@synthesize nextMusicStress;



#pragma mark Singleton

static JNPAudioManager *sharedAM = nil;

// Init
+ (JNPAudioManager *) sharedAM
{
	@synchronized(self)     {
		if (!sharedAM)
			sharedAM = [[JNPAudioManager alloc] init];
	}
	return sharedAM;
}

+ (id) alloc
{
	@synchronized(self)     {
		NSAssert(sharedAM == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super alloc];
	}
	return nil;
}

// Memory
- (void) dealloc
{
	sharedAM = nil;
	[super dealloc];
}

+(void) end
{
	sharedAM = nil;
}



#pragma mark AudioManager

-(id) init
{
	if( (self=[super init])) {
        self.counter = 0;
        self.nextMusicStress = -1;
        [self preload];
        [self schedule:@selector(backgroundMusicTick:) interval:0.83];
    }
   	return self;
}

// playMusic
-(void) playMusic:(int)stress {
    switch (stress) {
        case 1:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Tribal_1.aifc" loop:YES];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Tribal_2.aifc" loop:YES];
            break;
        case 3:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Tribal_3.aifc" loop:YES];
            break;
        case 4:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Tribal_4.aifc" loop:YES];
            break;
        case 5:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Tribal_5.aifc" loop:YES];
            break;
        default:
            break;
    }
}

// playNextMusic
-(void) playMusicWithStress:(int)stress {
    self.nextMusicStress = stress;
}

-(void) playJump {
	int r = arc4random() % 2;
	r+=4;
	[self play:r];
}

-(void) playPuke {
	int r = arc4random() % 5;
	r+=10;
	[self play:r];
}

// play
-(void) play:(int)soundType {
    switch (soundType) {			
		case jnpSndBile:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Bile.caf"];			
			break;
		case jnpSndBonus:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Bonus.caf"];			
			break;
		case jnpSndCollision:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Collision.caf"];		
			break;	
        case jnpSndDie:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Game_Over.caf"];
            break;	
        case jnpSndJump1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Jump_1.caf"];
            break;
        case jnpSndJump2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Jump_2.caf"];
            break;			
		case jnpSndLevel_Up:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Level_Up.caf"];				
			break;
		case jnpSndMalus:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Malus.caf"];			
			break;
		case jnpSndMenu:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Menu.caf"];			
			break;		
		case jnpSndObstacle:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Obstacle.caf"];			
			break;
		case jnpSndPuke1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Puke_1.caf"];			
			break;
		case jnpSndPuke2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Puke_2.caf"];			
			break;
		case jnpSndPuke3:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Puke_3.caf"];			
			break;
		case jnpSndPuke4:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Puke_4.caf"];			
			break;
		case jnpSndPuke5:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/OPuke_5.caf"];			
			break;

        default:
            break;
    }
}

// preload files
-(void) preload {
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Bile.caf"];			
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Bonus.caf"];			
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Collision.caf"];		
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Game_Over.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Jump_1.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Jump_2.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Level_Up.caf"];				
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Malus.caf"];			
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Menu.caf"];			
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Obstacle.caf"];			
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Puke_1.caf"];			
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Puke_2.caf"];			
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Puke_3.caf"];			
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Puke_4.caf"];			
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/OPuke_5.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Tribal_1.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Tribal_2.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Tribal_3.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Tribal_4.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Tribal_5.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Intro.aifc"];	
}

// called every 0.5 sec
-(void) backgroundMusicTick:(ccTime)time {
    self.counter = self.counter + 1;
    
    if (self.nextMusicStress == -1 || (self.counter % 10 == 0 && self.nextMusicStress != 0)) {
        int stress = self.nextMusicStress;
        self.nextMusicStress = 0;
        [self playMusic:stress];
    }
}



@end
