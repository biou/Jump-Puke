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

#define jnpSndDummy 0
#define jnpSndJump 1
#define jnpSndDie 2
#define jnpSndBile 3
#define jnpSndBonus 4
#define jnpSndCollision 5
#define jnpSndLevel_Up 6
#define jnpSndMenu 7
#define jnpSndObstacle 8

@interface JNPAudioManager : CCNode {
    int counter;
    int nextMusicStress;
}

-(void) playMusicWithStress:(int)stress;
-(void) playMusic:(int)stress;
-(void) play:(int)soundType;

@property (nonatomic) int counter;
@property (nonatomic) int nextMusicStress;

@end
