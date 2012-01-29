//
//  JNPDeath.h
//  JumpNPuke
//
//  Created by Alain Vagner on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JNPAudioManager.h"
#import "JNPMenuScene.h"

#define jnpGameover 0
#define jnpCredits 1

@interface JNPBasicLayer : CCLayer {

}

// returns a CCScene that contains the JNPDeath layer as the only child
+(CCScene *) scene:(int)m;

@end
