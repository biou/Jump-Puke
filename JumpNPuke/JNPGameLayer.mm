//
//  JNPGameLayer.mm
//  Test22
//
//  Created by Vincent on 28/01/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// Import the interfaces
#import "JNPGameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "JNPBasicLayer.h"

enum {
	kTagParentNode = 1,
};


#pragma mark JNPGameLayer
#pragma mark -

id elephantNormalTexture,elephantPukeTexture, elephantJumpTexture;

static JNPControlLayer * controlLayer;
static CCScene *scene;

// ta mere elle mange des pruneaux

@implementation JNPGameLayer

#pragma mark Scene (conteneur de ce Layer)
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	JNPGameLayer * baseLayer = [JNPGameLayer node];
	controlLayer = [JNPControlLayer node];
	[controlLayer assignGameLayer:baseLayer];
	
    CCLayer *bgLayer = [CCLayer node];
    CGSize s = [CCDirector sharedDirector].winSize;
    
    // init du background
    CCSprite *bgpic = [CCSprite spriteWithFile:@"fondpapier.png"];
    bgpic.position = ccp(bgpic.position.x + s.width/2.0, bgpic.position.y+s.height/2.0);
    bgpic.opacity = 160;
    [bgLayer addChild:bgpic];
    [scene addChild:bgLayer z:-10];
    
    JNPAudioManager *audioManager = [JNPAudioManager sharedAM];
    [audioManager playMusic:1];
    
    [scene addChild:audioManager];
    [baseLayer setAudioManager:audioManager];
    
	// add layer as a child to scene
	[scene addChild: baseLayer];
	[scene addChild: controlLayer z:5 tag:2];
	
	// return the scene
	return scene;
}


#pragma mark -
#pragma mark Création du Layer

-(id) init
{
	if( (self=[super init])) {
        
        /**** parallax ****/
        parallax = [CCParallaxScrollNode node];
        CCSprite *clouds1 = [CCSprite spriteWithFile:@"paralaxe1.png"];
        CCSprite *clouds2 = [CCSprite spriteWithFile:@"paralaxe2.png"];
        CCSprite *clouds1bis = [CCSprite spriteWithFile:@"paralaxe1.png"];
        CCSprite *clouds2bis = [CCSprite spriteWithFile:@"paralaxe2.png"];
        float totalWidth = 4 * clouds1.contentSize.width;
        [parallax addChild:clouds1 z:0 Ratio:ccp(1.3,1) Pos:ccp(0,0) ScrollOffset:ccp(totalWidth,0)];
        [parallax addChild:clouds2 z:0 Ratio:ccp(0.6,1) Pos:ccp(0,0) ScrollOffset:ccp(totalWidth,0)];
        [parallax addChild:clouds1bis z:0 Ratio:ccp(1.3,1) Pos:ccp(clouds1.contentSize.width,0) ScrollOffset:ccp(totalWidth,0)];
        [parallax addChild:clouds2bis z:0 Ratio:ccp(0.6,1) Pos:ccp(clouds2.contentSize.width,0) ScrollOffset:ccp(totalWidth,0)];
        // Add to layer, sprite, etc.
        [scene addChild:parallax z:-1];
        
        /******************/
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		hasWon = NO;
       
		// init de la Map avant box2d
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map.tmx"];
        //self.background = [_tileMap layerNamed:@"background"];
        [self addChild:_tileMap z:0];
        
        // obtention des positions potentielles de super bonus ta mère
        CCTMXObjectGroup *bonusGroup = [_tileMap objectGroupNamed:@"bonus"];
        NSMutableArray *tableauObjets = [bonusGroup objects];
        int nomber = [tableauObjets count];
        
        
        // initiailisation des bonus collectables
        lesBonusDeTaMere = [NSMutableArray array];

        
        JNPScore *s = [JNPScore jnpscore];
        NSMutableArray *tmpVomis = s.vomis;
        
        // s'il y a trop de vomi, on en supprime jusqu'à ce qu'il ne reste plus que 20 vomis
        if ([tmpVomis count]>20) {
            while ([tmpVomis count]>20) {
                [tmpVomis removeObjectAtIndex:(arc4random()%[tmpVomis count])];
            }
        }
        
        int inheritedVomiCounter = 0;
        for (CCSprite *sprout in tmpVomis) {
            inheritedVomiCounter++;
            [self addChild:sprout];
            [lesBonusDeTaMere addObject:sprout];
        }
        
        // S'il y a moins de 12 vomis, on ajoute des bonus aléatoirement sur la map parmis de positions prévues;
        int maxBonus = 12;
        maxBonus -= inheritedVomiCounter;
        
        
        // grande cagnotte tirage au sort parmis les positions possibles de bonus, pour obtenir un tableau de quelques points différents sur lesquels placer des cadeaux bonux
        NSMutableArray *electedBonusPositionsInMap = [NSMutableArray arrayWithCapacity:12];
        if (maxBonus>0) {
            for (int ii=0; ii<maxBonus; ii++) {
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
                
                [lesBonusDeTaMere addObject:newCollectibleBonusYoupiTralalaPouetPouet];
            }
            
        }
        
        
		
        [lesBonusDeTaMere retain];
        
        // initialisation de textures
		elephantNormalTexture = [[[CCTextureCache sharedTextureCache] addImage:@"elephant-normal.png"] retain];
		elephantPukeTexture = [[[CCTextureCache sharedTextureCache] addImage:@"elephant-puke.png"] retain];	
		elephantJumpTexture = [[[CCTextureCache sharedTextureCache] addImage:@"elephant-saute.png"] retain];
        
        
        
        // initialisation des vomis de ta grand mere
        lesVomisDeTaGrandMere = [NSMutableArray array];
        [lesVomisDeTaGrandMere retain];

        
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
            [lesObstaclesDeTonPere addObject:newCollidableBadBoyYoupiTralalaPouetPouet];
        }
        [lesObstaclesDeTonPere retain];
        
        
		// enable events
		
		self.isTouchEnabled = YES;
		
		// init physics
		[self initPhysics];
		
		// create reset button
		//[self createMenu];
		
		//Set up sprite
        //[self initPlayer];
        
     
		// ajout de la tete de serpent
		// il est 5h23, je fais ce que je veux !
		// FIXME à ajuster
        CCSprite *serpent = [CCSprite spriteWithFile:@"serpent.png"];
        serpent.position=ccp(KLIMITLEVELUP-192.0, winSize.height/2);
        [self addChild:serpent z:10];		
		
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
        ballShapeDef.density = 0.50/currentScale;
        ballShapeDef.friction = RAYONITEMS;
        ballShapeDef.restitution = KREBONDISSEMENT;
        playerBody->CreateFixture(&ballShapeDef);
        [self schedule:@selector(updatePlayerPosFromPhysics:)];
		[self schedule:@selector(updatePlayerSize:) interval:0.3];
        [self schedule:@selector(updateViewPoint:)];
        [self schedule:@selector(detectBonusPickup:)];
        [self schedule:@selector(updateTime:) interval:1];
        [self schedule:@selector(detectObstacleCollision:)];

        
        
        // détection du modèle d'ipad pou savoir si on active les fioritures particulantes ou pas, qui rendent un peu joli sur ipad 2 mais pas bien du tout du tout sur iPad 1.
        const char * deviceStr = (const char *)glGetString(GL_RENDERER);
        if (!strcmp(deviceStr, "PowerVR SGX 535")) {
            // iPad 1
            enableParticles = NO;
        }
        else {
            // iPad 2 or later
            enableParticles = YES;
        }
        
        

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
        
		if (enableParticles) {
			particleSystem = [[CCParticleFire alloc] initWithTotalParticles:50];
			//[particleSystem setEmitterMode: kCCParticleModeRadius];
			particleSystem.startColor = (ccColor4F){200/255.f, 200/255.f, 200/255.f, 0.6f};
			particleSystem.life = 1;
			particleSystem.lifeVar = 1;
			particleSystem.angleVar = 50;
			particleSystem.startSize = 1.5;
			particleSystem.texture = [[CCTextureCache sharedTextureCache] addImage:@"particle.png"];
			[self addChild:particleSystem z:10];
		}
		
        [self scheduleUpdate];
	}
	return self;
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

-(void)setAudioManager:(JNPAudioManager *)audioM {
    _audioManager = audioM;
}




#pragma mark Méthodes schedulées dans l'init

-(void)updateTime:(float)dt
{
	JNPScore * s = [JNPScore jnpscore];
	[s decrementTime];
    [controlLayer showTime:[s getTime]];
}

-(void)updatePlayerSize:(float)dt {
	if (fabs(currentScale) > 0.08) {
        [self diminuerPlayerDeltaScale:0.002 withEffect:NO];
		
	} else {
		currentScale = 0.0;
		[self gameover];
		
	}
	
}

// Détection du ramassage des bonus par parcours de la liste des bonus présents dans le level et calcul de la distance entre le joueur et le bonus.
-(void)detectBonusPickup:(float)dt {
    
    // Pour chaque bonus existant
    for (CCSprite *schpritz in lesBonusDeTaMere) {
        
        // Calcul des distances
        CGPoint bonusPosition = schpritz.position;
        CGPoint playeurPosition = ((CCSprite *)playerBody->GetUserData()).position;
        CGPoint soubstraction = ccpSub(bonusPosition, playeurPosition);
        float distanceCarree = soubstraction.x * soubstraction.x + soubstraction.y * soubstraction.y;
        float dist = sqrtf(distanceCarree);
        float contentSize = ((CCSprite *)playerBody->GetUserData()).contentSize.width*((CCSprite *)playerBody->GetUserData()).scale;
        
        // Condition de ramassage du bonus. Le contenu du "if" est l'action en cas de ramassage
        if (dist < contentSize/2 + RAYONITEMS) {
            
            // Suppression du bonus de la carte et de la liste des bonus
            [self removeChild:schpritz cleanup:NO];
            [lesBonusDeTaMere removeObject:schpritz];
            
            // Action sur le sprite du joueur
            [self playerGrowWithBonus];
            
            // Action sur le score
			JNPScore * s = [JNPScore jnpscore];
			[s incrementScore:500];
            [controlLayer showScore:[s getScore]];
            
            // Son de ramassage du bonus
            [_audioManager play:jnpSndBonus];
            return;
        }
    }
}


// Détection du ramassage d'un obstacle par parcours de la liste des obstacles présents dans le level et calcul de la distance entre le joueur et l'item. Code identique au bonus juste au dessus.
-(void)detectObstacleCollision:(float)dt {
    for (CCSprite *schpritz in lesObstaclesDeTonPere) {
        CGPoint obstaclePosition = schpritz.position;
        CGPoint playeurPosition = ((CCSprite *)playerBody->GetUserData()).position;
        CGPoint soubstraction = ccpSub(obstaclePosition, playeurPosition);
        float distanceCarree = soubstraction.x * soubstraction.x + soubstraction.y * soubstraction.y;
        float dist = sqrtf(distanceCarree);
        float contentSize = ((CCSprite *)playerBody->GetUserData()).contentSize.width*((CCSprite *)playerBody->GetUserData()).scale;
        
        if (dist < contentSize/2 + RAYONITEMS) {
            [self removeChild:schpritz cleanup:NO];
            [lesObstaclesDeTonPere removeObject:schpritz];
            [self diminuerPlayerDeltaScale:0.04];	
            [_audioManager play:jnpSndMalus];
            return;
        }
    }
}



// Auto scroll selon la position
-(void)updateViewPoint:(float)dt {
    float currentPlayerPosition = ((CCSprite *)playerBody->GetUserData()).position.x;
    float currentPlayerPosition_y = ((CCSprite *)playerBody->GetUserData()).position.y;
    self.position = ccp(200-currentPlayerPosition, self.position.y);
    
    float dp = currentPlayerPosition - prevPlayerPosition;
    float v = dp/dt;
    currentSpeed=v;
    
    JNPScore *s = [JNPScore jnpscore];
    float leveldifficulty = 100.0+45.0*[s getLevel];
    
    if (v<leveldifficulty) {
        float zeForce = (leveldifficulty - v + [controlLayer getAccelY]*300)/200;
        b2Vec2 force = b2Vec2(zeForce, 0.0f);
        playerBody->ApplyLinearImpulse(force, playerBody->GetPosition());
    }
    
    if (v<KVMIN) {
        [_audioManager playMusicWithStress:1];
    } else if (v<KV2) {
        [_audioManager playMusicWithStress:2];
    } else if (v<KV3) {
        [_audioManager playMusicWithStress:3];
    } else {
        [_audioManager playMusicWithStress:4];
    }
    
    [self checkCollisions:dt];
    
    float speedFactor = [[NSString stringWithFormat:@"%d", fabs(currentSpeed)] length] * 0.1;
    // NSLog(@"%f", speedFactor);
    
    [parallax updateWithVelocity:ccp(-speedFactor, 0.001 * speedFactor) AndDelta:dt];
    
    prevPlayerPosition = currentPlayerPosition;
    prevPlayerPosition_y = currentPlayerPosition_y;
}

-(void)updatePlayerPosFromPhysics:(float)dt {
    
	b2Body * b = playerBody;
    if (b->GetUserData() != NULL) {
        CCSprite *ballData = (CCSprite *)b->GetUserData();
        ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                b->GetPosition().y * PTM_RATIO);
        ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        float y = b->GetPosition().y;
        float x = b->GetPosition().x;
        if (y < 0) {
            [self gameover];
        }
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        if (y* PTM_RATIO > size.height) {
            [self gameover];
        }
        
        if (x * PTM_RATIO > KLIMITLEVELUP) {
            // on vient de passer le checkpoint !
            // empêcher le game over
            hasWon=YES;
            [controlLayer setVisible:NO];
            [controlLayer setIsTouchEnabled:NO];
            // transition vers niveau suivant (voir comment on peut faire sans tout réinitialiser
            [self unscheduleAllSelectors];
            [self unscheduleUpdate];
            
            JNPScore * s = [JNPScore jnpscore];
            s.vomis=lesVomisDeTaGrandMere;
            
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPBasicLayer scene:jnpNewLevel]]];
        }
        
    }        
    //}
    
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

-(void) checkCollisions: (ccTime) dt
{
    float currentPlayerPosition = ((CCSprite *)playerBody->GetUserData()).position.x;
    float currentPlayerPosition_y = ((CCSprite *)playerBody->GetUserData()).position.y;
        
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin(); 
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        b2Body *bodyB = contact.fixtureB->GetBody();
        
        CCSprite *playerSpriteA = (CCSprite*)bodyB->GetUserData();
        
        float speedFactor = [[NSString stringWithFormat:@"%d", currentSpeed] length];        
        
		if (enableParticles) {
			particleSystem.sourcePosition = ccp( playerSpriteA.position.x - 450 , playerSpriteA.position.y );
			particleSystem.startSizeVar = 0.9 * speedFactor;
			particleSystem.lifeVar = 3 * speedFactor;
			particleSystem.life = 2 * speedFactor;
		}
        
                
        // not toooooo much boingboing
        if (fabs(prevPlayerPosition - currentPlayerPosition) >= 1
            && fabs(prevPlayerPosition_y - currentPlayerPosition_y) >= 1) {

            [_audioManager playJump];
			if (enableParticles) {
				[particleSystem resetSystem];
			}
        }
    }
    
}



#pragma mark -
#pragma mark Gestion du Sprite Player


-(void)tellPlayerToJump {
    float adjustedForce = 44.0 + (140.0 * currentScale);
    // NSLog(@"CURRENTSCALE = %f  ADJUSTED FORCE = %f",currentScale, adjustedForce);
    
    b2Vec2 force = b2Vec2(0.25*adjustedForce, adjustedForce); //18
    playerBody->ApplyLinearImpulse(force, playerBody->GetPosition());
	
	b2Body * b = playerBody;
	if (b->GetUserData() != NULL) {
		CCSprite *ballData = (CCSprite *)b->GetUserData();
		[ballData setTexture:elephantJumpTexture];
        [self unschedule:@selector(restorePlayerTexture:)];
		[self schedule:@selector(restorePlayerTexture:) interval:0.3];
	}	
}


-(void)tellPlayerToPuke:(CGPoint)position {	
	// animation
	b2Body * b = playerBody;
	if (b->GetUserData() != NULL) {
		CCSprite *ballData = (CCSprite *)b->GetUserData();
		[ballData setTexture:elephantPukeTexture];
        [self unschedule:@selector(restorePlayerTexture:)];	
		[self schedule:@selector(restorePlayerTexture:) interval:0.3];
        
        // ajout du vomi !
        CGPoint dasPunkt = ccp(ballData.position.x,ballData.position.y);
        CCSprite *vomi = [CCSprite spriteWithFile:[@"bonus_0" stringByAppendingFormat:@"%d.png",arc4random()%6+2]];
        vomi.position=dasPunkt;
        [self addChild:vomi];
        [lesVomisDeTaGrandMere addObject:vomi];
    }
    
	// son
	[_audioManager playPuke];	
	
	[self diminuerPlayerDeltaScale:0.055];
    
}


-(void)restorePlayerTexture:(float)dt {
	b2Body * b = playerBody;
    if (b->GetUserData() != NULL) {
		CCSprite *ballData = (CCSprite *)b->GetUserData();
		[ballData setTexture:elephantNormalTexture];
	}
	[self unschedule:@selector(restorePlayerTexture:)];	
}



-(void)playerGrowWithBonus {
		currentScale += 0.15;
        
		if (playerBody->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)playerBody->GetUserData();
            ballData.scale=currentScale;
            playerBody->DestroyFixture(playerBody->GetFixtureList());
            b2CircleShape circle;
            circle.m_radius = elephantSize*currentScale/2/PTM_RATIO;
            b2FixtureDef ballShapeDef;
            ballShapeDef.shape = &circle;
            ballShapeDef.density = 0.50/currentScale; //0.5f * currentScale;
            ballShapeDef.friction = RAYONITEMS;
            ballShapeDef.restitution = KREBONDISSEMENT;
            playerBody->CreateFixture(&ballShapeDef);
            
		}        

	
}




-(void)diminuerPlayerDeltaScale:(float)deltaScale {
    [self diminuerPlayerDeltaScale:deltaScale withEffect:YES];
}

-(void)diminuerPlayerDeltaScale:(float)deltaScale withEffect:(Boolean)effect {
    // diminuer taille
    
    if (currentScale > deltaScale) {
        currentScale -= deltaScale;
    } else {
        currentScale = 0.1f;
    }
	
	if (playerBody->GetUserData() != NULL) {
		CCSprite *ballData = (CCSprite *)playerBody->GetUserData();
		ballData.scale=currentScale;
		playerBody->DestroyFixture(playerBody->GetFixtureList());
		b2CircleShape circle;
		circle.m_radius = elephantSize*currentScale/2/PTM_RATIO;
		b2FixtureDef ballShapeDef;
		ballShapeDef.shape = &circle;
		ballShapeDef.density = 0.50/currentScale; //0.5f * currentScale;
        ballShapeDef.friction = RAYONITEMS;
        ballShapeDef.restitution = KREBONDISSEMENT;
		playerBody->CreateFixture(&ballShapeDef);
		if (effect) {
            
            playerBody->ApplyTorque(50.0);
            
            // Effets visuels
            // Création d'un sprite avec l'image de l'éléphant, puis scale et alpha animés
            CGPoint currentPlayerPosition = ballData.position;
            CCSprite *effetVisuel = [CCSprite spriteWithFile:@"elephant-normal.png"];
            effetVisuel.position = currentPlayerPosition;
            effetVisuel.rotation = ballData.rotation;
            effetVisuel.color = ccc3(255.0, 180.0, 180.0);
            effetVisuel.opacity = 90.0;
            [self addChild:effetVisuel];
            
            float newScale = ballData.scale * 1.5;
            if (newScale>1.0) {
                newScale *= 0.7;
            }
            if (newScale>2.0) {
                newScale *= 0.7;
            }
            
            id actionScale = [CCScaleBy actionWithDuration:0.4 scale:ballData.scale];
            id actionOpacity = [CCActionTween actionWithDuration:0.25 key:@"opacity" from:90 to:0];
            id actionDone = [CCCallFuncN actionWithTarget:self 
                                                 selector:@selector(delSprite:)];
            
            [effetVisuel runAction:actionOpacity];
            [effetVisuel runAction:[CCSequence actions:actionScale, actionDone, nil]];
        }
	}   
}

-(void)delSprite:(id)sender {
    [self removeChild:sender cleanup:YES];
}




-(void)gameover
{
	if (!hasWon) {
		[self unscheduleAllSelectors];
		[self unscheduleUpdate];
		[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [JNPBasicLayer scene:jnpGameover]]];
	}
	
}



#pragma mark -



#pragma mark DRAW DEBUG DATA ICI !!!
-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	// [super draw];
    
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	//world->DrawDebugData();	
	
	kmGLPopMatrix();
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


#pragma mark -
#pragma mark dealloc, getters, setters



// il y a vraiment des commentaires de merde dans ce code

-(void) dealloc
{
	delete world;
	world = NULL;
    [lesBonusDeTaMere release];
	[lesObstaclesDeTonPere release];
    [lesVomisDeTaGrandMere release];

	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	


@synthesize playerBody;
@synthesize tileMap = _tileMap;
@synthesize background = _background;



@end
