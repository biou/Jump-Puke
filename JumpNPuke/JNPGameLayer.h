//
//  JNPGameLayer.h
//  Test22
//
//  Created by Vincent on 28/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "JNPControlLayer.h"
#import "JNPAudioManager.h"
#import "JNPBasicLayer.h"
#import "JNPScore.h"
#import "MyContactListener.h"
#import "JNPScore.h"
#import "CCParallaxScrollNode.h"


#define KLIMITLEVELUP 24150 
#define KVMIN 155.0
#define KV2 180.0
#define KV3 260.0
#define KV4 400.0
#define RAYONITEMS 21
#define KREBONDISSEMENT 0.55
#define KFRICTION 0.2


//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// JNPGameLayer
@interface JNPGameLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref

    CCParticleFire *particleSystem;
    
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
 
    MyContactListener *_contactListener;
    
    b2Body *playerBody;

    float prevPlayerPosition;
    float prevPlayerPosition_y;
    float currentSpeed;
	float currentScale;
	float elephantSize;
	BOOL hasWon;
	BOOL enableParticles;
	b2CircleShape * currentCircle;

    JNPAudioManager *_audioManager;
    CCParallaxScrollNode *parallax;
    
    NSMutableArray *lesBonusDeTaMere;
    NSMutableArray *lesObstaclesDeTonPere;
    NSMutableArray *lesVomisDeTaGrandMere;
}


-(void)setAudioManager:(JNPAudioManager *)audioM;
-(void)tellPlayerToJump;
-(void)tellPlayerToPuke:(CGPoint)position;
-(void)restorePlayerTexture:(float)dt;
-(void)diminuerPlayerDeltaScale:(float)deltaScale;
-(void)diminuerPlayerDeltaScale:(float)deltaScale withEffect:(Boolean)effect;
-(void)checkCollisions: (ccTime) dt;
-(void)initPhysics;
-(void)playerGrowWithBonus;
-(void)gameover;


// returns a CCScene that contains the JNPGameLayer as the only child
+(CCScene *) scene;


@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic) b2Body *playerBody;

@end
