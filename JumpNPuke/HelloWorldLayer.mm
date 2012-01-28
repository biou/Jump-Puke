//
//  HelloWorldLayer.mm
//  Test22
//
//  Created by Vincent on 28/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"


enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation HelloWorldLayer

@synthesize playerBody;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer * baseLayer = [HelloWorldLayer node];
	JNPControlLayer * controlLayer = [JNPControlLayer node];
    [controlLayer assignGameLayer:baseLayer];
	
    CCLayer *bgLayer = [CCLayer node];
    CGSize s = [CCDirector sharedDirector].winSize;
    
    // init du background
    CCSprite *bgpic = [CCSprite spriteWithFile:@"fondpapier.png"];
    bgpic.position = ccp(bgpic.position.x + s.width/2.0, bgpic.position.y+s.height/2.0);
    bgpic.opacity = 160;
    [bgLayer addChild:bgpic];
    [scene addChild:bgLayer];
    
    JNPAudioManager *audioManager = [[[JNPAudioManager alloc] init] autorelease];
    [scene addChild:audioManager];
    [baseLayer setAudioManager:audioManager];
    
	// add layer as a child to scene
	[scene addChild: baseLayer];
	[scene addChild: controlLayer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        
        
        
        // init de la Map avant box2d
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map.tmx"];
        self.background = [_tileMap layerNamed:@"background"];
        [self addChild:_tileMap z:0];
        
        
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		// init physics
		[self initPhysics];
		
		// create reset button
		[self createMenu];
		
		//Set up sprite
        //[self initPlayer];
        
       
		// taille en pixels de l'éléphant : 260px
		float elephantSize = 260.0;
        // Create ball body and shape
        CCSprite *playerSprite = [CCSprite spriteWithFile:@"elephants/elephant-normal.png"];
        playerSprite.scale=0.2;
        playerSprite.position=ccp(400, 400);
        [self addChild:playerSprite];
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(400.0/PTM_RATIO, 400.0/PTM_RATIO);
        ballBodyDef.userData = playerSprite;
        playerBody = world->CreateBody(&ballBodyDef);
        playerBody->SetUserData(playerSprite);
        //[self.sprite setPhysicsBody:body];
        
        b2CircleShape circle;
        circle.m_radius = elephantSize*playerSprite.scale/2/PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.2f;
        ballShapeDef.restitution = 0.8f;
        playerBody->CreateFixture(&ballShapeDef);
        [self schedule:@selector(updatePlayerPosFromPhysics:)];
		[self schedule:@selector(updatePlayerSize:) interval:0.3];
		
#if 1
		// Use batch node. Faster
		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
		spriteTexture_ = [parent texture];
#else
		// doesn't use batch node. Slower
		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
		CCNode *parent = [CCNode node];
#endif
		[self addChild:parent z:0 tag:kTagParentNode];
		
        [self scheduleUpdate];
        [self schedule:@selector(updateViewPoint:)];
	}
	return self;
}

-(void)updatePlayerSize:(float)dt {
 
}


-(void)updateViewPoint:(float)dt {
    float currentPlayerPosition = ((CCSprite *)playerBody->GetUserData()).position.x;
    self.position = ccp(200-currentPlayerPosition, self.position.y);
    
    float dp = currentPlayerPosition - prevPlayerPosition;
    float v = dp/dt;
    currentSpeed=v;
    
    if (v<140) {
        float zeForce = (140 - v)/200;
        b2Vec2 force = b2Vec2(zeForce, 0.0f);
        playerBody->ApplyLinearImpulse(force, playerBody->GetPosition());
    }
    
    //NSLog(@"music speed set to %f", v);
    
    if (v<KVMIN) {
        [_audioManager playMusicWithStress:1];
    } else if (v<KV2) {
        [_audioManager playMusicWithStress:2];
    } else if (v<KV3) {
        [_audioManager playMusicWithStress:3];
    } else if (v<KV4) {
        [_audioManager playMusicWithStress:4];
    } else {
        [_audioManager playMusicWithStress:5];
    }
    
    prevPlayerPosition = currentPlayerPosition;
}

-(void)updatePlayerPosFromPhysics:(float)dt {
    
    // world->Step(dt, 10, 10);
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {    
        if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                    b->GetPosition().y * PTM_RATIO);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }        
    }
    
}

-(void)tellPlayerToJump {
    b2Vec2 force = b2Vec2(3.0f, 27.0f);
    playerBody->ApplyLinearImpulse(force, playerBody->GetPosition());
}



-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
	}];
	
	// Achievement Menu Item using blocks
	CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
		
		
		GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
		achivementViewController.achievementDelegate = self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:achivementViewController animated:YES];
	}];
	
	// Leaderboard Menu Item using blocks
	CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
		
		
		GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
		leaderboardViewController.leaderboardDelegate = self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:leaderboardViewController animated:YES];
	}];
	
	CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, reset, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild: menu z:-1];	
}

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -30.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		

    /*****************************************************************/
    
	CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"box"];
	NSMutableDictionary * objPoint;
    
	int x, y;	
	for (objPoint in [objects objects]) {
        x = [[objPoint valueForKey:@"x"] intValue];
		y = [[objPoint valueForKey:@"y"] intValue];
        
        NSString *poly = [objPoint objectForKey:@"polylinePoints"];
        NSArray *points = [poly componentsSeparatedByString:@" "];

        NSString *p1s = [points objectAtIndex:0];
        NSArray *p1 = [p1s componentsSeparatedByString:@","];
        float p1x = x + [[p1 objectAtIndex:0] floatValue];
        float p1y = y - [[p1 objectAtIndex:1] floatValue];
        
        NSString *p2s = [points objectAtIndex:1];
        NSArray *p2 = [p2s componentsSeparatedByString:@","];
        float p2x = [[p2 objectAtIndex:0] floatValue] + x;
        float p2y = y - [[p2 objectAtIndex:1] floatValue];
        
        // NSLog(@"Adding a fixture x=%d y=%d p1x=%f p1y=%f p2x=%f p2y=%f, p2xstr=%@", x, y, p1x, p1y, p2x, p2y, [p2 objectAtIndex:0]);
        
        groundBox.Set(b2Vec2(p1x/PTM_RATIO,p1y/PTM_RATIO), b2Vec2(p2x/PTM_RATIO,p2y/PTM_RATIO));
        //groundBox.Set(b2Vec2(64/PTM_RATIO,64/PTM_RATIO), b2Vec2(256/PTM_RATIO,64/PTM_RATIO));
        groundBody->CreateFixture(&groundBox,0);
        
        
    }

	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
}


#pragma mark DRAW DEBUG DATA ICI !!!
-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
    
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
}

-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);	
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}



-(void)setAudioManager:(JNPAudioManager *)audioM {
    _audioManager = audioM;
}


#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}




@synthesize tileMap = _tileMap;
@synthesize background = _background;



@end
