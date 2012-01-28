//
//  JNPPlayer.h
//  JumpNPuke
//
//  Created by Vincent on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsSprite.h"

@interface JNPPlayer : CCNode {
    b2Body *body;
	int radius;
    
}

@property (nonatomic, retain) CCSprite *sprite;

+(JNPPlayer*) jnpplayer;

-(b2Vec2) getPosition;
-(void) jump:(b2Vec2)impulse atPoint:(b2Vec2)point;
-(void) initialize:(b2World*)world parent:(CCNode*)parent;
-(void) changeScale:(float) size;

@end
