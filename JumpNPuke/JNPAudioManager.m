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
        // [self preload];
        [self schedule:@selector(backgroundMusicTick:) interval:0.83];
    }
   	return self;
}

// playMusic
-(void) playMusic:(int)stress {
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0];
    switch (stress) {
        case 1:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Theme1.aifc" loop:YES];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Theme2.aifc" loop:YES];
            break;
        case 3:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Theme3.aifc" loop:YES];
            break;
        case 4:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"musique/Theme4.aifc" loop:YES];
            break;
        default:
            break;
    }
}

// playNextMusic
-(void) playMusicWithStress:(int)stress {
    self.nextMusicStress = stress;
}

-(void) stopMusic {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void) pauseMusic {
	[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

-(void) resumeMusic {
	[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

-(void) playJump {
	int r = arc4random() % 3;
	r+=jnpSndJump1;
	[self play:r];
}

-(void) playPuke {
	int r = arc4random() % 5;
	r+=jnpSndPuke1;
	[self play:r];
}

// play
-(void) play:(int)soundType {
    switch (soundType) {
		case jnpSndNoSound:
			break;
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
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Jump1.caf"];
            break;
        case jnpSndJump2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Jump2.caf"];
            break;	
        case jnpSndJump3:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Jump3.caf"];
            break;				
		case jnpSndLevel_Up:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Checkpoint.caf"];				
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
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Puke1.caf"];			
			break;
		case jnpSndPuke2:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Puke2.caf"];			
			break;
		case jnpSndPuke3:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Puke3.caf"];			
			break;
		case jnpSndPuke4:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Puke4.caf"];			
			break;
		case jnpSndPuke5:
            [[SimpleAudioEngine sharedEngine] playEffect:@"sons-events/Puke5.caf"];			
			break;
        default:
			NSLog(@"--Sound not found\n");
            break;
    }
}

// preload files
-(void) preload {
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Bile.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Bonus.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Collision.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Game_Over.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Jump1.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Jump2.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Jump3.caf"];	
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Checkpoint.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Malus.caf"];		
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Menu.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Obstacle.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Puke1.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Puke2.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Puke3.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Puke4.caf"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sons-events/Puke5.caf"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Theme1.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Theme2.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Theme3.aifc"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"musique/Theme4.aifc"];
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
