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
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tribal_1.wav" loop:YES];
            break;
        case 2:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tribal_2.wav" loop:YES];
            break;
        case 3:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tribal_3.wav" loop:YES];
            break;
        case 4:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tribal_4.wav" loop:YES];
            break;
        case 5:
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Tribal_5.wav" loop:YES];
            break;
        default:
            break;
    }
}

// playNextMusic
-(void) playMusicWithStress:(int)stress {
    self.nextMusicStress = stress;
}

// play
-(void) play:(int)soundType {
    switch (soundType) {
        case jnpSndDummy:
            [[SimpleAudioEngine sharedEngine] playEffect:@"gameboy-startup.wav"];
            break;
        case jnpSndJump:
            [[SimpleAudioEngine sharedEngine] playEffect:@"jump.mp3"];
            break;
        case jnpSndDie:
            [[SimpleAudioEngine sharedEngine] playEffect:@"gameover.mp3"];
            break;
        default:
            break;
    }
}

// preload files
-(void) preload {
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"calm.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"calm.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Tribal_1.wav"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Tribal_2.wav"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Tribal_3.wav"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Tribal_4.wav"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Tribal_5.wav"];
}

// called every 0.5 sec
-(void) backgroundMusicTick:(ccTime)time {
    self.counter = self.counter + 1;
    
    if (self.nextMusicStress == -1 || (self.counter % 10 == 0 && self.nextMusicStress != 0)) {
        //NSLog(@"time has come to play next music with stress %d", self.nextMusicStress);
        int stress = self.nextMusicStress;
        self.nextMusicStress = 0;
        [self playMusic:stress];
    }
}


@end
