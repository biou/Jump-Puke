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


@implementation JNPPlayer

@synthesize sprite;

-(id) init
{
	if( (self=[super init])) {
    
    }
   	return self;
}

-(void) initialize:(b2World*)world parent:(CCNode*)parent
{
    self.sprite = [PhysicsSprite spriteWithFile:@"player.png"];
    
    CGSize s = [CCDirector sharedDirector].winSize;
    CGPoint p = ccp(s.width/2, s.height/2);
    
    self.position = ccp(p.x, p.y);
	
    // Create ball body and shape
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(100/PTM_RATIO, 100/PTM_RATIO);
    ballBodyDef.userData = self;
    body = world->CreateBody(&ballBodyDef);
    body->SetUserData(self.sprite);
    [parent addChild:self.sprite];
    [self.sprite setPhysicsBody:body];
    
    b2CircleShape circle;
    circle.m_radius = 26.0/PTM_RATIO;
    
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

@end
