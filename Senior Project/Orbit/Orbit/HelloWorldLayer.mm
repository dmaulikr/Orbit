//
//  HelloWorldLayer.mm
//  Orbit
//
//  Created by Ken Hung on 8/20/11.
//  Copyright Cal Poly - SLO 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Enums.h"
#import "Entity.h"
#import "SquareEntity.h"
#import "CircleEntity.h"
#import "PlusEntity.h"
#import "LineEntity.h"
#import "TriangleEntity.h"
#import "PathedEntity.h"

#import "OrbitShopLayer.h"
#import "MenuLayer.h"
#import "WinScreenLayer.h"

#import "Utils.h"
#import "Vector3D.h"
#import "GameHelper.h"
#import "GameObject.h"
#import "ObjectEntity.h"

#import "LevelObject.h"

#define VICTORY_KILL_NUM 3

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation HelloWorldLayer
@synthesize entities = entities_, playerEntity = playerEntity_, pathGrid = pathGrid_, gameState = gameState_, playerHUD = playerHUD_, levelFile = levelFile_, rootViewController = rootViewController_;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(CCScene *) sceneWithLevel: (LevelFile *) levelFile rootRef: (UIViewController *)viewController {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	layer.levelFile = levelFile;
    layer.rootViewController = viewController;
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


UITapGestureRecognizer * tappy, *tappy2;

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        self.levelFile = nil;
        
		// enable touches
		self.isTouchEnabled = YES;
        
		// enable accelerometer
	//	self.isAccelerometerEnabled = YES;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		// Define the gravity vector.
		b2Vec2 gravity;
	//	gravity.Set(0.0f, -10.0f);
        gravity.Set(0.0f, 0.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
	//	bool doSleep = true;
        bool doSleep = false;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
        
        listener = new MyContactListener();
        world->SetContactListener(listener);

		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;

		m_debugDraw->SetFlags(flags);		

		
		// Define the ground body.
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		// Call the body factory which allocates memory for the ground body
		// from a pool and creates the ground box shape (also from a pool).
		// The body is also added to the world.
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// top
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// left
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		
		// right
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		
		//Set up sprite
		/*
		CCSpriteBatchNode *batch = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:150];
		[self addChild:batch z:0 tag:kTagBatchNode];
		
		[self addNewSpriteWithCoords:ccp(screenSize.width/2, screenSize.height/2)];
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( screenSize.width/2, screenSize.height-50);
		*/
        
        // Inititalize list of entities
        self.entities = [[NSMutableArray alloc] init];
        
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)];
        recognizer.numberOfTapsRequired = 1;
        recognizer.numberOfTouchesRequired = 1;
        [[[CCDirector sharedDirector] openGLView] addGestureRecognizer: recognizer];
        recognizer.cancelsTouchesInView = NO;
        tappy = [recognizer retain];
        [recognizer release];
        
        recognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapTwo:)];
        recognizer.numberOfTapsRequired = 1;
        recognizer.numberOfTouchesRequired = 2;
        [[[CCDirector sharedDirector] openGLView] addGestureRecognizer: recognizer];
        recognizer.cancelsTouchesInView = NO;
        tappy2 = [recognizer retain];
        [recognizer release];
        
        [self addObserver: self forKeyPath: @"levelFile" options:NSKeyValueObservingOptionNew context: nil];
	}
	return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString: @"levelFile"]) {
        if (self.levelFile) {
            // Add Grid Layer
            self.pathGrid = [[GridLayer alloc] initWithScreenWidths: self.levelFile.levelWidths];
            
            [self addBoxesWithLevelFile: self.levelFile];
        } else {
            // Add Grid Layer
            self.pathGrid = [[GridLayer alloc] initWithScreenWidths: 4];
            
            // Add some geometry
            [self addRandomPolygons: 8];
            [self addRandomBoxes: 7];
        }
    }
    
    // Cull grid with world geoemtry
    [self.pathGrid cullGridWithWorld: world];
    [self addChild: self.pathGrid z:0];
    
    [self initGameComponents];
}

-(void) initHUD {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    // Init HUD first then GameState will refresh HUD when created
    self.playerHUD = [[HUD alloc] initWithNode: self];
    
    // Add Menu
    CCMenuItem * menuItem = [CCMenuItemFont itemFromString:@"Menu" target:self selector :@selector(onMenu:)];
    menuItem.position = ccp(screenSize.width / 2, screenSize.height - 10);
    CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
    menu.position = CGPointZero;
    //   [menu alignItemsVertically];
    [self addChild:menu];
}

- (void) initAnimator {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"warnings.plist"];
}

- (void) initGameComponents {
    [self initHUD];
    
    [self initAnimator];
    
    // Init GameState
    self.gameState = [[GameState alloc] initWithHUD: self.playerHUD];
    [self.gameState setCurrentScore: 1600 withGoalScore:2000];
    
    [self initPlayer];
    
    [self schedule: @selector(initLine) interval: 3.0];
    [self schedule: @selector(initPlus) interval: 6.0];
    [self schedule: @selector(initSquare) interval: 5.0];
    [self schedule: @selector(initTriangle) interval: 5.0];
    [self initCircle];
    
    //[self schedule: @selector(initCircle) interval: 5.0];
    //  [self schedule: @selector(initPathed) interval:3.0];
    //    [self initPathed];
    
    [self schedule: @selector(updateEntitiesPosition:)];
    //     [self schedule: @selector(updateWeaponPosition:)];
    // Sync sprite positions with box positions
    [self schedule: @selector(updateSpriteToBox:)];
    [self schedule: @selector(tick:)];
    
#ifndef ORBIT_DEBUG_DISABLE_SCROLLING
    [self schedule: @selector(updateScrollingNodes)];
#endif
}

- (void) stopSpawning {
    // return;
    [self unschedule:@selector(initPlus)];
    [self unschedule:@selector(initSquare)];
    [self unschedule:@selector(initTriangle)];
    [self unschedule:@selector(initPathed)];
    [self unschedule:@selector(initLine)];
    [self unschedule:@selector(initCircle)];
}

- (void) spawnBoss {
    // return;
    [self schedule: @selector(initPathed) interval:1.5];
    
    self.gameState.hasSpawnedBoss = YES;
}

- (void) onMenu: (id) sender {
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:tappy];
    [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:tappy2];
    
    [tappy release];
    [tappy2 release];
    
    [[CCDirector sharedDirector] replaceScene: [MenuLayer sceneWithRootRef: self.rootViewController]];
}

- (void) handleTap: (UIGestureRecognizer *) gesture {
    CGPoint location = [gesture locationInView: [[CCDirector sharedDirector] openGLView]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    //   NSLog(@"Touch Began");
    
    CCSprite * playerSprite = self.playerEntity.sprite;
    
    // If touch down is within the player
    if (location.x <= (playerSprite.position.x + playerSprite.contentSize.width/2) 
        && location.x >= (playerSprite.position.x - playerSprite.contentSize.width/2)
        && location.y <= (playerSprite.position.y + playerSprite.contentSize.height/2) 
        && location.y >= (playerSprite.position.y - playerSprite.contentSize.height/2)) {
        
        if (self.gameState.currentScore - 200 >= 0) {
            self.gameState.currentScore-=200;
            self.playerEntity.primaryWeapon.speed+=0.1;
 //           [self.weaponSpeedLabel setString: [NSString stringWithFormat: @"W Speed %f", self.playerEntity.primaryWeapon.speed]];
        }
    }
}

- (void) handleTapTwo: (UIGestureRecognizer *) gesture {
    CGPoint location = [gesture locationInView: [[CCDirector sharedDirector] openGLView]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    //   NSLog(@"Touch Began");
    
    CCSprite * playerSprite = self.playerEntity.sprite;
    
    // If touch down is within the player
    if (location.x <= (playerSprite.position.x + playerSprite.contentSize.width/2) 
        && location.x >= (playerSprite.position.x - playerSprite.contentSize.width/2)
        && location.y <= (playerSprite.position.y + playerSprite.contentSize.height/2) 
        && location.y >= (playerSprite.position.y - playerSprite.contentSize.height/2)) {
        
        if (self.gameState.currentScore - 300 >= 0) {
            self.gameState.currentScore-=300;

            self.playerEntity.damage += 0.05;//0.025;
            
            self.playerEntity.primaryWeapon.body->DestroyFixture(self.playerEntity.primaryWeapon.body->GetFixtureList());
            
            b2CircleShape dynamicBox2;
            //   dynamicBox2.SetAsBox(0.5f, 0.5f);//These are mid points for our 1m box
            dynamicBox2.m_radius = ((self.playerEntity.sprite.contentSize.width/2) / PTM_RATIO) 
                * self.playerEntity.sprite.scale;
            // Define the dynamic body fixture.
            b2FixtureDef fixtureDef2;
            fixtureDef2.shape = &dynamicBox2;	
            fixtureDef2.density = 100.0f;
            fixtureDef2.friction = 0.5f;
            self.playerEntity.primaryWeapon.body->CreateFixture(&fixtureDef2);
            //.m_radius = (self.playerWeaponEntity.sprite.contentSize.width/4) / PTM_RATIO;
            
   //         [self.weaponDamageLabel setString: [NSString stringWithFormat: @"W Damage %f", self.playerWeaponEntity.sprite.scale]];
        }
    }
}

-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	CCSpriteBatchNode *batch = (CCSpriteBatchNode*) [self getChildByTag:kTagBatchNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCSprite *sprite = [CCSprite spriteWithBatchNode:batch rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[batch addChild:sprite];
	
	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
}

- (void) cleanupWeaponRecurse: (Entity *) entity {
    // Make sure we don't try to destroy a weapon if it's already destroyed
    if (entity.primaryWeapon && entity.primaryWeapon.isValid) {
        [self cleanupWeaponRecurse: entity.primaryWeapon];
    }
    
    CGPoint exploPoint = entity.sprite.position;
    
    world->DestroyBody(entity.body);
    [self removeChild: entity.sprite cleanup: YES];
    [self removeChild: entity.healthSprite cleanup:YES];
    [self.entities removeObject: entity];
    
    [self animateParticleDeathAtPosition: exploPoint];
}

- (void) animateParticleDeathAtPosition: (CGPoint) position {
    CCParticleExplosion* explo = [[[CCParticleExplosion alloc] initWithTotalParticles: 100] autorelease];
    explo.autoRemoveOnFinish = YES;
    // Duration animation NOT doesn't affect radius
    explo.duration = 0.1f;
    explo.speed = 200.0f;
    // Seconds per particle to live and it's variance
    explo.life = 0.6f;
    explo.lifeVar = 0.2f;
    explo.startSize = 4.0f;
    explo.endSize = 0.5f;
    explo.position = position;
    
    [self addChild: explo z:0 tag: 984651];
}

#pragma mark
#pragma mark Add Sprites and Objects
- (void) initPlayer {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    self.playerEntity = [[PlayerEntity alloc] initAtPosition: ccp(30, screenSize.height/2) onSide: ENTITY_SIDE_SELF withNode: self b2World:world HUD: self.playerHUD withStreak: NO];
}

- (void) initPathed {
    if (self.gameState.spawnCount >= VICTORY_KILL_NUM) {
        [self stopSpawning];
        return;
    }
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    PathedEntity * pathedEntity = [[PathedEntity alloc] initAtPosition: ccp(screenSize.width * [self.pathGrid getCurrentScreenNumber] / 2, screenSize.height / 2) onSide: ENTITY_SIDE_ENEMY withNode: self b2World: world gameGrid: self.pathGrid HUD: nil withStreak: NO];
    
    WeaponEntity * wep = [[WeaponEntity alloc] initAtPosition: pathedEntity.sprite.position onSide: ENTITY_SIDE_ENEMY withNode: self b2World: world HUD: nil withStreak: YES];
    wep.speed = 5.0;
    wep.orbitDistance = 5;
    wep.weaponType = WEAPON_TYPE_ELIPSE;
    
    [self.entities addObject: wep];
    pathedEntity.primaryWeapon = wep;
    [wep release];
    
    [self.entities addObject: pathedEntity];
    [pathedEntity release];
    
    self.gameState.spawnCount++;
}

- (void) initLine {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    NSInteger height = arc4random() % ((NSInteger)screenSize.height);
    
    LineEntity * lineEntity = [[LineEntity alloc] initAtPosition: ccp(screenSize.width - 32, height) onSide: ENTITY_SIDE_ENEMY withNode: self  b2World: world HUD: nil withStreak: NO];
    
    [self.entities addObject: lineEntity];
    [lineEntity release];
}

- (void) initTriangle {
    CGSize screenSize = [CCDirector sharedDirector].winSize;

    TriangleEntity * triangleEntity = [[TriangleEntity alloc] initAtPosition: ccp(screenSize.width - 32, screenSize.height * (1.0/4.0)) onSide: ENTITY_SIDE_ENEMY withNode: self b2World:world HUD: nil withStreak: NO];
    
    [self.entities addObject: triangleEntity];
    [triangleEntity release];
}

- (void) initSquare {
    CGSize screenSize = [CCDirector sharedDirector].winSize;

    SquareEntity * squareEntity = [[SquareEntity alloc] initAtPosition: ccp(screenSize.width - 32, screenSize.height / 2) onSide: ENTITY_SIDE_ENEMY withNode: self b2World: world HUD:nil withStreak:NO];
    
    [self.entities addObject: squareEntity];
    [squareEntity release];
}

- (void) initPlus {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //PlusEntity * plusEntity = [[PlusEntity alloc] initWithSprite: plus entitySide: ENTITY_SIDE_ENEMY];
    PlusEntity * plusEntity = [[PlusEntity alloc] initAtPosition: ccp(screenSize.width/2, screenSize.height/2) onSide: ENTITY_SIDE_ENEMY  withNode: self b2World:world HUD:nil withStreak:NO];
    [self.entities addObject: plusEntity];
    [plusEntity release];
}

- (void) initCircle {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    CircleEntity * circleEntity = [[CircleEntity alloc] initAtPosition: ccp(screenSize.width / 2, screenSize.height - (32)) onSide: ENTITY_SIDE_ENEMY withNode:self b2World:world HUD:nil withStreak:NO];
    
    // Attach weapons
    WeaponEntity * wep = [[WeaponEntity alloc] initAtPosition: circleEntity.sprite.position onSide: ENTITY_SIDE_ENEMY withNode: self b2World: world HUD: nil withStreak:NO];
    wep.speed = 1.0f;
    wep.orbitDistance = 20;
    
    circleEntity.primaryWeapon = wep;
    
    [self.entities addObject: wep];
    
    WeaponEntity * wep2 = [[WeaponEntity alloc] initAtPosition: wep.sprite.position onSide: ENTITY_SIDE_ENEMY withNode: self b2World: world HUD: nil withStreak:YES];
    wep2.speed = 3.0f;
    wep2.orbitDistance = 12;
    
    wep.primaryWeapon = wep2;
    
    [self.entities addObject: wep2];
    
    [wep release];
    
    WeaponEntity * wep3 = [[WeaponEntity alloc] initAtPosition: wep2.sprite.position onSide: ENTITY_SIDE_ENEMY withNode: self b2World: world HUD: nil withStreak:YES];
    wep3.speed = 8.0f;
    wep3.orbitDistance = 3;
    
    wep2.primaryWeapon = wep3;
    
    [self.entities addObject: wep3];
    
    [wep2 release];
    [wep3 release];
    
    // Add to Entity Manager
    [self.entities addObject: circleEntity];
    [circleEntity release];
}

#pragma mark
#pragma mark Update Functions
-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
#ifdef ORBIT_DEBUG_COLLISION_BOXES
	world->DrawDebugData();
#endif
	
    for (Entity * entity in self.entities) {
        if (entity.isValid || entity.entityType == ENTITY_TYPE_WALL) [entity draw];
    }
    
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

-(void) tick: (ccTime) dt
{
    // once player reaches goal, kill all roaming entities -- for demo
    if (self.gameState.hasReachedScore && !self.gameState.hasSpawnedBoss) {
        // must account for extra screen between transitions
        BOOL isGridSnapped = (NSInteger)self.pathGrid.position.x % (NSInteger)[self.pathGrid getOneScreenWidth] == 0 
        && ceil(fabs(self.pathGrid.position.x) / [self.pathGrid getOneScreenWidth] + 0.000001) == 1;//<= self.pathGrid.numberOfScreens;
        
        if (isGridSnapped && !self.gameState.hasSpawnedBoss) {
            [self unschedule:@selector(updateScrollingNodes)]; // stop scrolling
            // start spawning pathed bosses
            [self performSelector: @selector(spawnBoss) withObject:nil afterDelay:2.0];
            self.gameState.hasSpawnedBoss = YES;
        }
        
        for (Entity * entity in self.entities) {
            if (entity.entitySide & ENTITY_SIDE_ENEMY && entity.entityType != ENTITY_TYPE_PATHED) {
                entity.isValid = NO;
                entity.health = 0.0f;
            }
            
            // stop objects from scrolling
            if (entity.entityType == ENTITY_TYPE_WALL && isGridSnapped) {
                entity.isValid = NO;
            }
        }
        
        [self stopSpawning];
    }
    
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
            Entity * myActor = (Entity *)b->GetUserData();
			myActor.sprite.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}

- (void) updateScrollingNodes {
    [self.pathGrid updatePosition];
}

- (void) updateSpriteToBox: (ccTime) dt {
    // Animate player death and clean up
    if (!self.playerEntity.isValid && !self.playerEntity.isGameOver) {
        self.gameState.currentScore-=100;
        // self.playerEntity.isValid = YES;
        [self cleanupWeaponRecurse: self.playerEntity];
        self.playerEntity.isGameOver = YES;
        
        [self performSelector: @selector(onMenu:) withObject:nil afterDelay: 3.0];
    }

    self.playerEntity.primaryWeapon.isValid = YES;
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL) {
            Entity * entity = (Entity *)b->GetUserData();
            
            if (entity.entityType == ENTITY_TYPE_NONE || entity.entityType == ENTITY_TYPE_WALL) {
                continue;
            }
            
            if (entity.isValid) {
                b2Vec2 b2Position = b2Vec2(entity.sprite.position.x/PTM_RATIO,
                                           entity.sprite.position.y/PTM_RATIO);
                float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(entity.sprite.rotation);
                
                b->SetTransform(b2Position, b2Angle);
            } else {
                // Remove invalid entities from our list, remove the associated sprite from our layer and remove
                // the body from our world
                if (!(entity.entitySide & ENTITY_SIDE_SELF)) {
                    entity.health -= 0.6 * self.playerEntity.primaryWeapon.damage;
                    if (entity.health <= 0) {
                        // Demo - win condition
                        if (entity.entityType == ENTITY_TYPE_PATHED) {
                            self.gameState.bossKillCount++;
                        }
                        
                        [self cleanupWeaponRecurse: entity];
                        self.gameState.currentScore+=100;
                        
                    } else {
                        entity.isValid = YES;
                    }
                }
            }
        }
    }
    
    if (self.gameState.bossKillCount >= VICTORY_KILL_NUM) {
        // HAVE to remove these otherwise we crash
        [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:tappy];
        [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:tappy2];
        
        [tappy release];
        [tappy2 release];
        
        [[CCDirector sharedDirector] replaceScene:[WinScreenLayer sceneWithRootRef:self.rootViewController]];     
    }
}

- (void) updateEntitiesPosition: (ccTime) dt {    
    for (Entity * entity in self.entities) {
        if (entity.isValid) [entity updatePosition: dt];
    }
    
    // for updating weapon position
    [self.playerEntity updatePosition: dt];
 //   [self updateSpriteToBox: dt];
}

#pragma mark
#pragma mark Add Geometry
-(void) addBoxesWithLevelFile: (LevelFile *) levelFile {
    if (self.levelFile) {
        for (LevelObject * obj in self.levelFile.objectList) {
            CGRect objDim = obj.objectDimension;
            CGSize screenSize = [CCDirector sharedDirector].winSize;
            // Must readjust for flipped y-axis between Box2D and UIView
            // Also adjust scaling of objects 
            // NOT SURE WHY - 120, 0.05 polygonsize
            CGRect dim = CGRectMake(objDim.origin.x, (screenSize.height - objDim.origin.y) - 120, objDim.size.width/PTM_RATIO/0.05, objDim.size.height/PTM_RATIO/0.05);
            
            [self addBoxAtPoint: ccp(dim.origin.x, dim.origin.y) size: ccp(dim.size.width, dim.size.height)];
        }
    }
}

-(void) addRandomPolygons:(int)num {
	for(int i=0; i<num; i++){
		float x = (float)(arc4random()%((int)self.pathGrid.gameAreaSize.x*PTM_RATIO));
		float y = (float)(arc4random()%((int)self.pathGrid.gameAreaSize.y*PTM_RATIO));	
		
        // temporarily prevents geometry on spawn point
        if (x <= 150) {
            i--;
            continue;
        }
        
		[self addPolygonAtPoint:ccp(x,y)];
	}
}

-(void) addRandomBoxes:(int)num {
	for(int i=0; i<num; i++){
		float x = (float)(arc4random()%((int)self.pathGrid.gameAreaSize.x*PTM_RATIO));
		float y = (float)(arc4random()%((int)self.pathGrid.gameAreaSize.y*PTM_RATIO));	
		
        // temporarily prevents geometry on spawn point
        if (x <= 150) {
            i--;
            continue;
        }
        
		[self addBoxAtPoint:ccp(x,y) size:ccp((float)(arc4random()%200)+100.0f,(float)(arc4random()%50)+30.0f)];
	}
}

/* Adding a polygon */
-(void) addPolygonAtPoint:(CGPoint)p {
	//Random collection of points
	NSMutableArray *points = [[NSMutableArray alloc] init];
	for(int i=0; i<(arc4random()%5+3); i++){
		float x = (float)(arc4random()%100)+10;
		float y = (float)(arc4random()%100)+10;
		Vector3D *v = [Vector3D x:x y:y z:0];
		[points addObject:v];
	}
	
	//Convex polygon points
	NSMutableArray *convexPolygon = [GameHelper convexHull:points];
	
	//Convex Polygon
	float polygonSize = 0.05f;
    
	int32 numVerts = convexPolygon.count;
	b2Vec2 *vertices;
	vertices = new b2Vec2[convexPolygon.count];
	
	NSMutableArray *vertexArray = [[NSMutableArray alloc] init];
	
	CGPoint maxSize = ccp(0,0);
	for(int i=0; i<convexPolygon.count; i++){
		Vector3D *v = [convexPolygon objectAtIndex:i];
		vertices[i].Set(v.x*polygonSize, v.y*polygonSize);
		[vertexArray addObject:[NSValue valueWithCGPoint:ccp(v.x*PTM_RATIO*polygonSize, v.y*PTM_RATIO*polygonSize)]];
		
		//Figure out max polygon size
		if(maxSize.x < v.x*polygonSize){ maxSize.x = v.x*polygonSize; }
		if(maxSize.y < v.y*polygonSize){ maxSize.y = v.y*polygonSize; }
	}
	
	//Keep polygon in game area
	if(p.x/PTM_RATIO + maxSize.x > self.pathGrid.gameAreaSize.x){ p.x = (self.pathGrid.gameAreaSize.x - maxSize.x)*PTM_RATIO; }
	if(p.y/PTM_RATIO + maxSize.y > self.pathGrid.gameAreaSize.y){ p.y = (self.pathGrid.gameAreaSize.y - maxSize.y)*PTM_RATIO; }
	if(p.x < 0){ p.x = 0; }
	if(p.y < 0){ p.y = 0; }
    
	//GameMisc *obj = [[GameMisc alloc] init];
    ObjectEntity *obj = [[ObjectEntity alloc] init];
	//obj.gameArea = self;
	//obj.tag = GO_TAG_WALL;
    
    obj.bodyDef = new b2BodyDef();
	obj.bodyDef->type = b2_staticBody;
	obj.bodyDef->position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	obj.bodyDef->userData = obj;
	obj.body = world->CreateBody(obj.bodyDef);
	
	obj.polygonShape = new b2PolygonShape();
	obj.polygonShape->Set(vertices, numVerts);
    
    obj.fixtureDef = new b2FixtureDef();
	obj.fixtureDef->shape = obj.polygonShape;
	
	obj.body->CreateFixture(obj.fixtureDef);
    
    obj.gameAreaSize = self.pathGrid.gameAreaSize;
    obj.numberOfScreens = self.pathGrid.numberOfScreens;

    obj.m_debugDraw = m_debugDraw;
    [self.entities addObject: obj];
}

/* Adding a polygon */
-(void) addBoxAtPoint:(CGPoint)p size:(CGPoint)s {
	//Random collection of points
	NSMutableArray *points = [[NSMutableArray alloc] init];
	float x = s.x; float y = s.y;
	
	[points addObject:[Vector3D x:0 y:0 z:0]];
	[points addObject:[Vector3D x:x y:0 z:0]];
	[points addObject:[Vector3D x:x y:y z:0]];
	[points addObject:[Vector3D x:0 y:y z:0]];
    
	float polygonSize = 0.05f;
    
	int32 numVerts = points.count;
	b2Vec2 *vertices;
	vertices = new b2Vec2[points.count];
	
	NSMutableArray *vertexArray = [[NSMutableArray alloc] init];
	
	CGPoint maxSize = ccp(0,0);
	for(int i=0; i<points.count; i++){
		Vector3D *v = [points objectAtIndex:i];
		vertices[i].Set(v.x*polygonSize, v.y*polygonSize);
		[vertexArray addObject:[NSValue valueWithCGPoint:ccp(v.x*PTM_RATIO*polygonSize, v.y*PTM_RATIO*polygonSize)]];
		
		//Figure out max polygon size
		if(maxSize.x < v.x*polygonSize){ maxSize.x = v.x*polygonSize; }
		if(maxSize.y < v.y*polygonSize){ maxSize.y = v.y*polygonSize; }
	}
	
	//Keep polygon in game area
	if(p.x/PTM_RATIO + maxSize.x > self.pathGrid.gameAreaSize.x){ p.x = (self.pathGrid.gameAreaSize.x - maxSize.x)*PTM_RATIO; }
	if(p.y/PTM_RATIO + maxSize.y > self.pathGrid.gameAreaSize.y){ p.y = (self.pathGrid.gameAreaSize.y - maxSize.y)*PTM_RATIO; }
	if(p.x < 0){ p.x = 0; }
	if(p.y < 0){ p.y = 0; }
    
	//GameMisc *obj = [[GameMisc alloc] init];
    ObjectEntity *obj = [[ObjectEntity alloc] init];
//	obj.gameArea = self;
//	obj.tag = GO_TAG_WALL;
    
    obj.bodyDef = new b2BodyDef();
	obj.bodyDef->type = b2_staticBody;
	obj.bodyDef->position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	obj.bodyDef->userData = obj;
	obj.body = world->CreateBody(obj.bodyDef);
	
	obj.polygonShape = new b2PolygonShape();
	obj.polygonShape->Set(vertices, numVerts);
    
    obj.fixtureDef = new b2FixtureDef();
	obj.fixtureDef->shape = obj.polygonShape;
	obj.fixtureDef->restitution = 0.0f;
	obj.fixtureDef->friction = 1.0f;
	
	obj.body->CreateFixture(obj.fixtureDef);

    obj.gameAreaSize = self.pathGrid.gameAreaSize;
    obj.numberOfScreens = self.pathGrid.numberOfScreens;

    obj.m_debugDraw = m_debugDraw;
    [self.entities addObject: obj];
}

#pragma mark 
#pragma mark Device Input
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
 //   NSLog(@"Touch Began");
    
    CCSprite * playerSprite = self.playerEntity.sprite;
    
    // If touch down is within the player
    if (location.x <= (playerSprite.position.x + playerSprite.contentSize.width/2) 
        && location.x >= (playerSprite.position.x - playerSprite.contentSize.width/2)
        && location.y <= (playerSprite.position.y + playerSprite.contentSize.height/2) 
        && location.y >= (playerSprite.position.y - playerSprite.contentSize.height/2)) {
        isMoving = YES;
    
       // [[CCDirector sharedDirector] resume];
        self.playerEntity.isWeaponPowered = YES;
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
 //   NSLog(@"Touch Moved w: %f h: %f", location.x, location.y);
    if (isMoving) {
        self.playerEntity.sprite.position = location;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  //  NSLog(@"Touch Ended");
    isMoving = NO;
  //  self.playerEntity.isWeaponPowered = NO;
    
    //[[CCDirector sharedDirector] pause];
    
    /*
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		[self addNewSpriteWithCoords: location];
	}
    */
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
	//#define kFilterFactor 0.05f
#define kFilterFactor 1.0f	// don't use filter. the code is here just as an example
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	// accelerometer values are in "Portrait" mode. Change them to Landscape left
	// multiply the gravity by 10
	b2Vec2 gravity( -accelY * 10, accelX * 10);
	
	world->SetGravity( gravity );
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"levelFile"];
    
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;

    delete listener;
    
    //[entities_ dealloc];// ???
    [entities_ release];
    [playerEntity_ release];
    [pathGrid_ release];
    [gameState_ release];
    [playerHUD_ release];
    [levelFile_ release];
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
