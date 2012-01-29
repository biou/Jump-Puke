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
#import "JNPBasicLayer.h"

enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
@end


// ta mere elle mange des pruneaux

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
    [audioManager playMusic:1];
    
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
        
        // obtention des positions potentielles de super bonus ta mère
        CCTMXObjectGroup *bonusGroup = [_tileMap objectGroupNamed:@"bonus"];
        NSMutableArray *tableauObjets = [bonusGroup objects];
        int nomber = [tableauObjets count];
        
        // grande cagnotte tirage au sort parmis les positions possibles de bonus, pour obtenir un tableau de quelques points différents sur lesquels placer des cadeaux bonux
        NSMutableArray *electedBonusPositionsInMap = [NSMutableArray arrayWithCapacity:12];
        lesBonusDeTaMere = [NSMutableArray arrayWithCapacity:12];
        for (int ii=0; ii<12; ii++) {
            int kk = arc4random() % nomber;
            [electedBonusPositionsInMap insertObject:[tableauObjets objectAtIndex:kk] atIndex:ii];
            [tableauObjets removeObjectAtIndex:kk];
            nomber--;
        }
        
        // après le tirage au sort des positions, on y ajoute des sprites de bonus avec des images originales et également tirées au hasard! youpi super hahaha huhuhu hihihi
        for (NSMutableDictionary *nodule in electedBonusPositionsInMap) {
            CGPoint dasPunkt = ccp([[nodule valueForKey:@"x"] floatValue], [[nodule valueForKey:@"y"] floatValue]);
            CCSprite *newCollectibleBonusYoupiTralalaPouetPouet = [CCSprite spriteWithFile:[@"bonus_0" stringByAppendingFormat:@"%d.png",arc4random()%6+2]];
            newCollectibleBonusYoupiTralalaPouetPouet.position=dasPunkt;
            [self addChild:newCollectibleBonusYoupiTralalaPouetPouet];
            NSLog(@"Populate lesBonusDeTaMere");
            [lesBonusDeTaMere addObject:newCollectibleBonusYoupiTralalaPouetPouet];
        }
        [lesBonusDeTaMere retain];
        
        
        
        
        // obtention des positions potentielles de super bonus ta mère
        CCTMXObjectGroup *obstaclesGroup = [_tileMap objectGroupNamed:@"obstacles"];
        NSMutableArray *tableauObstacles = [obstaclesGroup objects];
        nomber = [tableauObstacles count];
        
        // grande cagnotte tirage au sort parmis les positions possibles d'obstacles, pour obtenir un tableau de quelques points différents sur lesquels placer des badboys
        NSMutableArray *electedObstaclesPositionsInMap = [NSMutableArray arrayWithCapacity:9];
        lesObstaclesDeTonPere = [NSMutableArray arrayWithCapacity:9];
        for (int ii=0; ii<9; ii++) {
            int kk = arc4random() % nomber;
            [electedObstaclesPositionsInMap insertObject:[tableauObstacles objectAtIndex:kk] atIndex:ii];
            [tableauObstacles removeObjectAtIndex:kk];
            nomber--;
        }
        
        // après le tirage au sort des positions, on y ajoute des sprites de méchants connards avec des images originales et également tirées au hasard! youpi super hahaha huhuhu hihihi
        for (NSMutableDictionary *nodule in electedObstaclesPositionsInMap) {
            CGPoint dasPunkt = ccp([[nodule valueForKey:@"x"] floatValue], [[nodule valueForKey:@"y"] floatValue]);
            CCSprite *newCollidableBadBoyYoupiTralalaPouetPouet = [CCSprite spriteWithFile:[@"ennemis_0" stringByAppendingFormat:@"%d.png",arc4random()%7+1]];
            newCollidableBadBoyYoupiTralalaPouetPouet.position=dasPunkt;
            [self addChild:newCollidableBadBoyYoupiTralalaPouetPouet];
            NSLog(@"Populate ton père");
            [lesObstaclesDeTonPere addObject:newCollidableBadBoyYoupiTralalaPouetPouet];
        }
        [lesObstaclesDeTonPere retain];
        
        
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
		elephantSize = 260.0;
		currentScale = 0.4;
        // Create ball body and shape
        CCSprite *playerSprite = [CCSprite spriteWithFile:@"elephant-normal.png"];
        playerSprite.scale=currentScale;
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
        currentCircle = &circle;
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.2f;
        ballShapeDef.restitution = 0.8f;
        playerBody->CreateFixture(&ballShapeDef);
        [self schedule:@selector(updatePlayerPosFromPhysics:)];
		[self schedule:@selector(updatePlayerSize:) interval:0.3];
        [self schedule:@selector(updateViewPoint:)];
        [self schedule:@selector(detectBonusPickup:)];

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
        

        particleSystem = [[CCParticleFire alloc] initWithTotalParticles:50];
        //[particleSystem setEmitterMode: kCCParticleModeRadius];
        particleSystem.startColor = (ccColor4F){200/255.f, 200/255.f, 200/255.f, 0.6f};
        particleSystem.life = 1;
        particleSystem.lifeVar = 1;
        particleSystem.angleVar = 50;
        particleSystem.startSize = 1.5;
        particleSystem.texture = [[CCTextureCache sharedTextureCache] addImage:@"player.png"];
        [self addChild:particleSystem z:10];
        
		
        [self scheduleUpdate];
	}
	return self;
}


-(void)gameover
{
	[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPBasicLayer scene:jnpGameover]]];
	
}

-(void)updatePlayerSize:(float)dt {
	if (fabs(currentScale) > 0.08) {
		currentScale -= 0.0038;
        
		if (playerBody->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)playerBody->GetUserData();
            ballData.scale=currentScale;
            playerBody->DestroyFixture(playerBody->GetFixtureList());
            b2CircleShape circle;
            circle.m_radius = elephantSize*currentScale/2/PTM_RATIO;
            b2FixtureDef ballShapeDef;
            ballShapeDef.shape = &circle;
            ballShapeDef.density = 0.5f * currentScale;
            ballShapeDef.friction = 0.2f;
            ballShapeDef.restitution = 0.8f;
            playerBody->CreateFixture(&ballShapeDef);
		}        
	} else {
		currentScale = 0.0;
		NSLog(@"trop petit");
		[self gameover];
		
	}
	
}



-(void)playerGetBiggerBecauseHeJustAteOneBonusYeahDudeYouKnow {
		currentScale += 0.15;
        
		if (playerBody->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)playerBody->GetUserData();
            ballData.scale=currentScale;
            playerBody->DestroyFixture(playerBody->GetFixtureList());
            b2CircleShape circle;
            circle.m_radius = elephantSize*currentScale/2/PTM_RATIO;
            b2FixtureDef ballShapeDef;
            ballShapeDef.shape = &circle;
            ballShapeDef.density = 0.5f * currentScale;
            ballShapeDef.friction = 0.2f;
            ballShapeDef.restitution = 0.8f;
            playerBody->CreateFixture(&ballShapeDef);
            
		}        

	
}




-(void)detectBonusPickup:(float)dt {
    for (CCSprite *schpritz in lesBonusDeTaMere) {
        CGPoint bonusPosition = schpritz.position;
        CGPoint playeurPosition = ((CCSprite *)playerBody->GetUserData()).position;
        CGPoint soubstraction = ccpSub(bonusPosition, playeurPosition);
        float distanceCarree = soubstraction.x * soubstraction.x + soubstraction.y * soubstraction.y;
        float dist = sqrtf(distanceCarree);
        float contentSize = ((CCSprite *)playerBody->GetUserData()).contentSize.width*((CCSprite *)playerBody->GetUserData()).scale;
        if (dist < contentSize/2 +25) {
            [self removeChild:schpritz cleanup:NO];
            [lesBonusDeTaMere removeObject:schpritz];
            NSLog(@"You just picked up an item, baby! YEAH!");
            [self playerGetBiggerBecauseHeJustAteOneBonusYeahDudeYouKnow];
            [_audioManager play:1];
            return;
        }
    }
}



// c'est toi Soyouz !!!

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
    //for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {    
	b2Body * b = playerBody;
		if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                    b->GetPosition().y * PTM_RATIO);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }        
    //}
    
}

-(void)tellPlayerToJump {
    b2Vec2 force = b2Vec2(7.2f, 27.0);
    playerBody->ApplyLinearImpulse(force, playerBody->GetPosition());
}

// il y a vraiment des commentaires de merde dans ce code

-(void) dealloc
{
	delete world;
	world = NULL;
    [lesBonusDeTaMere release];
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	

// c'est toi le commentaire

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

    /*****************************************************************/
    // Create contact listener
    _contactListener = new MyContactListener();
    world->SetContactListener(_contactListener);
    
    
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
    
    [self checkCollisions];
}

-(void) checkCollisions
{
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin(); 
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;

        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();

        CCSprite *playerSpriteA = (CCSprite*)bodyB->GetUserData();
        //CCSprite *playerSpriteB = (CCSprite*)bodyB->GetUserData();
        NSLog(@"----------------------");
        NSLog(@"%f , %f", playerSpriteA.position.x, playerSpriteA.position.y);
        NSLog(@"%f , %f", bodyB->GetPosition().x, bodyB->GetPosition().y);
        
        //NSLog(@"%f , %f", playerSpriteB.position.x, playerSpriteB.position.y);
        //NSLog(@"%@", bodyA);
        //NSLog(@"%@", bodyB);
        NSLog(@"----------------------");
        
        //particleSystem.sourcePosition = playerSpriteA.position;

        
        float speedFactor = [[NSString stringWithFormat:@"%d", currentSpeed] length];
        particleSystem.sourcePosition = ccp( playerSpriteA.position.x - 450 , playerSpriteA.position.y );
        particleSystem.startSizeVar = 0.9 * speedFactor;
        particleSystem.lifeVar = 3 * speedFactor;
        particleSystem.life = 2 * speedFactor;

        //particleSystem.sourcePosition = ccp(bodyB->GetPosition().x, bodyB->GetPosition().y);
        
        //CGPoint p1 = [[CCDirector sharedDirector] convertToUI:ccp(bodyB->GetPosition().x, bodyB->GetPosition().y)];
        //particleSystem.sourcePosition = ccp( p1.x, p1.y );

        /*CGPoint p2 = [[CCDirector sharedDirector] convertToGL:playerSpriteA.position];
        particleSystem.sourcePosition = ccp( 1024 - p2.y, 768 - p2.y );*/

        
        [particleSystem resetSystem];
        
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();

            NSLog(@"%@ , %@", spriteA, spriteB);
            
            if (spriteA.tag == 1 && spriteB.tag == 2) {

            } else if (spriteA.tag == 2 && spriteB.tag == 1) {

            } 
        }        
    }
    
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
