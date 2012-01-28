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
