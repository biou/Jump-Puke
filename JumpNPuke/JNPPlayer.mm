//
//  JNPPlayer.m
//  JumpNPuke
//
//  Created by Vincent on 28/01/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "JNPPlayer.h"

#define PTM_RATIO 32

static JNPPlayer * singleton = nil;

@implementation JNPPlayer

@synthesize sprite;

-(id) init
{
	if( (self=[super init])) {
        
    }
   	return self;
}

+(JNPPlayer*)jnpplayer
{
    if (singleton == nil) {
        @synchronized(self) {
            if (singleton == nil) {
                singleton = [[JNPPlayer alloc] init];
            }
        }
    }
    return singleton;
}

-(void) initialize:(b2World*)world parent:(CCNode*)parent
{
    self.sprite = [PhysicsSprite spriteWithFile:@"elephants/elephant-normal.png"];
    
    CGSize s = [CCDirector sharedDirector].winSize;
    CGPoint p = ccp(s.width/2, s.height/2);
    
    self.position = ccp(p.x, p.y);
	
    // Create ball body and shape
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    ballBodyDef.userData = self;
    body = world->CreateBody(&ballBodyDef);
    body->SetUserData(self.sprite);
    [parent addChild:self.sprite];
    [self.sprite setPhysicsBody:body];
    
	[self changeScale:67.0];

}



-(void) changeScale:(float) size 
{
	radius = size;

	self.sprite.scale=0.5;
    
    CGSize mySize;
    mySize.width=20.0;
    mySize.height=20.0;
    self.sprite.scaleX=0.3;
    
    b2CircleShape circle;
    circle.m_radius = size/PTM_RATIO;
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.2f;
    ballShapeDef.restitution = 0.8f;
    body->CreateFixture(&ballShapeDef);	
	
}

-(b2Vec2) getPosition
{
    return body->GetPosition();
}

-(void) jump:(b2Vec2)impulse atPoint:(b2Vec2)point {
    body->ApplyLinearImpulse(impulse, point);
}

-(void) dealloc
{
	body = nil;
    self.sprite = nil;
    [super dealloc];
}

@end
