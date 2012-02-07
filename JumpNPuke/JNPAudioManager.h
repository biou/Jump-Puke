//
//  JNPAudioManager.h
//  PawAppsExample_SimpleAudioEngine
//
//  Created by Vincent on 27/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "CCNode.h"





#define jnpSndBile 0
#define jnpSndBonus 1
#define jnpSndCollision 2
#define jnpSndDie 3
#define jnpSndJump1 4
#define jnpSndJump2 5
#define jnpSndLevel_Up 6
#define jnpSndMalus 7
#define jnpSndMenu 8
#define jnpSndObstacle 9
#define jnpSndPuke1 10
#define jnpSndPuke2 11
#define jnpSndPuke3 12
#define jnpSndPuke4 13
#define jnpSndPuke5 14


@interface JNPAudioManager : CCNode {
    int counter;
    int nextMusicStress;
}

-(void) playMusicWithStress:(int)stress;
-(void) playMusic:(int)stress;
-(void) stopMusic;
-(void) play:(int)soundType;
-(void) preload;
-(void) playJump;
-(void) playPuke;
+(JNPAudioManager *) sharedAM;

@property (nonatomic) int counter;
@property (nonatomic) int nextMusicStress;

@end
