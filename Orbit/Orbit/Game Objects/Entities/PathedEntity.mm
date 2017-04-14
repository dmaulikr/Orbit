//
//  PathedEntity.m
//  Orbit
//
//  Created by Ken Hung on 2/12/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "PathedEntity.h"
#import "GameWaypoint.h"
#import "GameHelper.h"
#import "AStarNode.h"
#import "AStarPathNode.h"
#import "Utils.h"

#define WAYPOINT_DIST_THRESHOLD 16.0f
#define TIMES_BLOCKED_FAIL 2

@interface PathedEntity ()
    -(void) processWaypoints;
    -(void) runWithVector:(CGPoint)v withSpeedMod:(float)speedMod withConstrain:(bool)constrain;
    -(void) stopRunning;
    -(CGPoint) getNormalVectorFromDirection:(int)dir;
@end

@implementation PathedEntity
@synthesize gridLayer, waypoints, direction, runSpeed, lastVelocity;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (CCNode *) node b2World: (b2World *) world gameGrid: (GridLayer *) grid HUD: (HUD *) playerHUD withStreak: (BOOL) enableSteak {
    if (self = [super init]) {
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_PATHED;
        self.gridLayer = grid;
        self.waypoints = [[NSMutableArray alloc] init];
        
        // Show animation, then delay an invoation to init and show this entity
        [super inithAnimatorWithNode: node];
        [self.animator createWarningAnimationAtPosition: position];
        // [self initSpriteAndBodyAt: position withNode:node b2World:world];
        
        self.isValid = NO; // dont draw or update until spawn animation finishes
        
        NSMethodSignature * signature = [self methodSignatureForSelector: @selector(initSpriteAndBodyAt:withNode:b2World:)];
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature: signature];
        [invocation setTarget: self];
        [invocation setSelector:@selector(initSpriteAndBodyAt:withNode:b2World:)];
        [invocation setArgument: &position atIndex: 2];
        [invocation setArgument: &node atIndex: 3];
        [invocation setArgument: &world atIndex: 4];
        
        [NSTimer scheduledTimerWithTimeInterval: 0.6 invocation:invocation  repeats:NO];
        
        // Init WeaponEntity
        //      CGPoint weaponPosition = ccp(position.x + (position.x * 0.5), position.y);
        
        //      self.primaryWeapon = [[WeaponEntity alloc] initAtPosition: weaponPosition withNode: node b2World: world HUD: playerHUD withStreak:YES];
        //      self.primaryWeapon.speed = 8.0f;
        //      self.primaryWeapon.orbitDistance = 28;
        
        if (enableSteak) {
            [self initMotionStreakAt: self.sprite.position withNode: node];
        }
    }
    
    return self;
}

- (void) initSpriteAndBodyAt: (CGPoint) position withNode: (CCNode *) node b2World: (b2World *) world {
    CCSprite * pathed = [CCSprite spriteWithFile: @"ph_line.png" rect: CGRectMake(0, 0, 72, 72)];
    pathed.position = position;
  //  [pathed setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }]; 
    [node addChild: pathed];
    
    CCSprite * pathedHealth = [CCSprite spriteWithFile: @"ph_line_hp_bar.png" rect: CGRectMake(0, 0, 72, 72)];
    pathedHealth.position = position;
    [node addChild: pathedHealth];
    
    self.healthSprite = pathedHealth;
    self.speed = 4;
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(pathed.position.x/PTM_RATIO, pathed.position.y/PTM_RATIO);
    bodyDef.userData = self;
    
    b2Body * body = world->CreateBody(&bodyDef);
    
    b2PolygonShape dynamicBox;
    dynamicBox.SetAsBox(1.0f, 0.25f);//These are mid points for our 1m box
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    fixtureDef.restitution = 1.0f;
    body->CreateFixture(&fixtureDef);
    
    self.body = body;
    self.sprite = pathed;
    
    [self.animator destroyWarningAnimation];
    
    // Add an initial point to move to
    [self addWaypoint];
    
    self.isValid = YES;
}

- (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node {
    self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_line.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
    self.streak.scale = 0.5f;
    self.streak.position = position;
    
    [node addChild: self.streak];
}

- (void) updatePosition: (ccTime) dt {
    [super updatePosition: dt];
    
  /*  self->rotation += self.speed;
    
    if (self->rotation >= 360) {
        self->rotation-=360;
    }
    
    float rotInRad = (M_PI/180) * self->rotation;
    
    CGFloat x = cos(rotInRad);
    CGFloat y = sin(rotInRad);
    
    x *= self->radius;
    y *= self->radius;
    
    self.sprite.position = CGPointMake(self->centerPoint.x + x, self->centerPoint.y + y);
   */
    if ([self.waypoints count] == 0) {
        [self addWaypoint];
    }

    [self processWaypoints];
    self.healthSprite.position = self.sprite.position;
    
    [self.primaryWeapon updatePosition: dt];
}

- (void) draw {
#ifdef ORBIT_DEBUG_ENABLE_PATHING
    //Draw waypoints
	glColor4ub(255,255,0,32);
	CGPoint selfPosition = ccp(self.body->GetPosition().x*PTM_RATIO, self.body->GetPosition().y*PTM_RATIO);
	if(self.waypoints.count == 1){
		GameWaypoint *gw = (GameWaypoint*)[self.waypoints objectAtIndex:0];
		ccDrawLine(selfPosition, gw.position);
	}else if(self.waypoints.count > 1){
		for(int i=0; i<self.waypoints.count-1; i++){			
			GameWaypoint *gw = (GameWaypoint*)[self.waypoints objectAtIndex:i];
			GameWaypoint *gwNext = (GameWaypoint*)[self.waypoints objectAtIndex:i+1];
			
			if(i == 0){
				//From self to first waypoint
				ccDrawLine(selfPosition, gw.position);
				ccDrawLine(gw.position, gwNext.position);
			}else{
				//From this waypoint to next one
				ccDrawLine(gw.position, gwNext.position);
			}	
		}
	}
	glColor4ub(255,255,255,255);

    glColor4ub(255,0,0,255);
    for (GameWaypoint * wp in self.waypoints) {
     //   NSLog(@"%f %f", wp.position.x, wp.position.y);
        ccDrawCircle(wp.position, 35, 0, 4, NO);
    }
    glColor4ub(255,255,255,255);
#endif
}

-(void) processWaypoints {
	bool removeFirstWaypoint = NO;
	
	//The actor's position onscreen
	CGPoint worldPosition = CGPointMake(self.body->GetPosition().x * PTM_RATIO, self.body->GetPosition().y * PTM_RATIO);
	
	//Process waypoints 
	for(GameWaypoint *wp in waypoints){
		float distanceToNextPoint = [GameHelper distanceP1:worldPosition toP2:CGPointMake(wp.position.x, wp.position.y)];
		
		//If we didn't make progress to the next point, increment timesBlocked
		if(distanceToNextPoint >= wp.lastDistance){
			timesBlocked++;
			
			//Drop this waypoint if we failed to move a number of times
			if(timesBlocked > TIMES_BLOCKED_FAIL){
				distanceToNextPoint = 0.0f;
			}
		}else{
			//If we are just starting toward this point we run our pre-callback
			wp.lastDistance = distanceToNextPoint;
			[wp processPreCallback];
		}
        
		//If we are close enough to the waypoint we move onto the next one
		if(distanceToNextPoint <= WAYPOINT_DIST_THRESHOLD){
			removeFirstWaypoint = YES;
			[self stopRunning];
			
			//Run post callback
			[wp processPostCallback];
		}else{
			//Keep running toward the waypoint
			float speedMod = wp.speedMod;
			
			//Slow down close to the waypoint
			if(distanceToNextPoint < [self runSpeed]/PTM_RATIO){
				speedMod = (distanceToNextPoint)/([self runSpeed]/PTM_RATIO);
			}
			[self runWithVector:ccp(wp.position.x - worldPosition.x, wp.position.y - worldPosition.y) withSpeedMod:speedMod withConstrain:NO ];
			break;
		}
	}
	if(removeFirstWaypoint){
		[waypoints removeObjectAtIndex:0];
		timesBlocked = 0;
	}
}

-(void) runWithVector:(CGPoint)v withSpeedMod:(float)speedMod withConstrain:(bool)constrain {	
	//Change animation depending on angle
	float radians = [GameHelper vectorToRadians:v];
	float degrees = [GameHelper radiansToDegrees:radians];
	CGPoint constrainedVector;	//Vector constained to only the 8 angles
	CGPoint unconstrainedVector = [GameHelper radiansToVector:radians];	//Unconstrained vector
    
	degrees += 90.0f;
    
	if(degrees >= 337.5f || degrees < 22.5f){
		direction = LEFT;
	}else if(degrees >= 22.5f && degrees < 67.5f){
		direction = UP_LEFT;
	}else if(degrees >= 67.5f && degrees < 112.5f){
		direction = UP;
	}else if(degrees >= 112.5f && degrees < 157.5f){
		direction = UP_RIGHT;
	}else if(degrees >= 157.5f && degrees < 202.5f){
		direction = RIGHT;
	}else if(degrees >= 202.5f && degrees < 247.5f){
		direction = DOWN_RIGHT;
	}else if(degrees >= 247.5f && degrees < 292.5f){
		direction = DOWN;
	}else{
		direction = DOWN_LEFT;
	}
	
	constrainedVector = [self getNormalVectorFromDirection:direction];
    
	if(constrain){
            self.sprite.position = ccp(self.sprite.position.x + constrainedVector.x * self.speed, self.sprite.position.y + constrainedVector.y * self.speed);
	//	self.body->SetLinearVelocity(b2Vec2(constrainedVector.x*runSpeed*speedMod, constrainedVector.y*runSpeed*speedMod));
	}else{
            self.sprite.position = ccp(self.sprite.position.x + constrainedVector.x * self.speed, self.sprite.position.y + constrainedVector.y * self.speed);
	//	self.body->SetLinearVelocity(b2Vec2(unconstrainedVector.x*runSpeed*speedMod, unconstrainedVector.y*runSpeed*speedMod));
	}
	
	if(lastAngularVelocity != 0.0f && lastAngularVelocity == self.body->GetAngularVelocity()){
		self.body->SetAngularVelocity(0.0f);
	}
	lastAngularVelocity = self.body->GetAngularVelocity();
	lastVelocity = ccp(self.body->GetLinearVelocity().x, self.body->GetLinearVelocity().y);
}

-(void) stopRunning {
	self.body->SetLinearVelocity(b2Vec2(0.0f,0.0f));
}

-(CGPoint) getNormalVectorFromDirection:(int)dir{
	CGPoint v;
	if(dir == LEFT){
		v = ccp(-1,0);
	}else if(dir == UP_LEFT){
		v = ccp(-0.7071067812,0.7071067812);
	}else if(dir == UP){
		v = ccp(0,1);
	}else if(dir == UP_RIGHT){
		v = ccp(0.7071067812,0.7071067812);
	}else if(dir == RIGHT){
		v = ccp(1,0);
	}else if(dir == DOWN_RIGHT){
		v = ccp(0.7071067812,-0.7071067812);
	}else if(dir == DOWN){
		v = ccp(0,-1);
	}else if(dir == DOWN_LEFT){
		v = ccp(-0.7071067812,-0.7071067812);
	}
	return v;
}

- (void) addWaypoint {
    //Convert touch coordinate to physical coordinate
    NSInteger height = arc4random() % ((NSInteger)self.gridLayer.gameAreaSize.y*PTM_RATIO);
    
    // rand 0 - 1 screen length
    NSInteger randOneScreenLength = arc4random() % (NSInteger)([self.gridLayer getOneScreenWidth]);
    NSInteger width = (([self.gridLayer getOneScreenWidth] * [self.gridLayer getCurrentScreenNumber]) + randOneScreenLength);
	// NSInteger width = (arc4random() % (NSInteger)(self.gridLayer.gameAreaSize.x*PTM_RATIO));
    
    NSLog(@"Waypoint Added: %d %d %f %d %d", width, height, [self.gridLayer getOneScreenWidth], [self.gridLayer getCurrentScreenNumber], randOneScreenLength);
    NSLog(@"grid position: %f", self.gridLayer.position.x);
    
    CGPoint endPoint = ccp(width, height);//[self convertTouchCoord:point];
    
	if(endPoint.x < 0 || endPoint.y < 0 || endPoint.x >= self.gridLayer.gameAreaSize.x*PTM_RATIO || endPoint.y >= self.gridLayer.gameAreaSize.y*PTM_RATIO){
		return;
	}
	
	//Actor position
	CGPoint actorPosition = ccp(self.body->GetPosition().x*PTM_RATIO, self.body->GetPosition().y*PTM_RATIO);
	
	//We use the last waypoint position if applicable
	if(self.waypoints.count > 0){
		actorPosition = [[self.waypoints objectAtIndex:self.waypoints.count-1] position];
	}
	
	//Starting node
	AStarNode *startNode = [[self.gridLayer.grid objectAtIndex:(int)(actorPosition.x/self.gridLayer.nodeSpace)] objectAtIndex:(int)(actorPosition.y/self.gridLayer.nodeSpace)];
    
	//Make sure the start node is actually properly connected
	if(startNode.neighbors.count == 0){
		bool found = NO; float n = 1;
		while(!found){
			//Search the nodes around this point for a properly connected starting node
			for(float x = -n; x<= n; x+= n){
				for(float y = -n; y<= n; y+= n){
					if(x == 0 && y == 0){ continue; }
					float xIndex = ((int)(actorPosition.x/self.gridLayer.nodeSpace))+x;
					float yIndex = ((int)(actorPosition.y/self.gridLayer.nodeSpace))+y;
					if(xIndex >= 0 && yIndex >= 0 && xIndex < self.gridLayer.gridSizeX && yIndex < self.gridLayer.gridSizeY){
						AStarNode *node = [[self.gridLayer.grid objectAtIndex:xIndex] objectAtIndex:yIndex];
						if(node.neighbors.count > 0){
							startNode = node;
							found = YES;
							break; break;
						}
					}					
				}
			}
			n += 1;
		}
	}
	
	//End node
	AStarNode *endNode = [[self.gridLayer.grid objectAtIndex:(int)(endPoint.x/self.gridLayer.nodeSpace)] objectAtIndex:(int)(endPoint.y/self.gridLayer.nodeSpace)];	
    
	//Run the pathfinding algorithm
	NSMutableArray *foundPath = [AStarPathNode findPathFrom:startNode to:endNode];
	
	if(!foundPath){
	//	[self showMessage:@"No Path Found"];
        NSLog(@"No Path Found");
    }else{
	//	[self showMessage:@"Found Path"];
        NSLog(@"Path Found");
		//Add found path as a waypoint set to the actor
		for(int i=foundPath.count-1; i>=0; i--){
			CGPoint pathPoint = [[foundPath objectAtIndex:i] CGPointValue];
			[self.waypoints addObject: [GameWaypoint createWithPosition:pathPoint withSpeedMod:1.0f]];
		}
	}
	
	[foundPath release]; 
    foundPath = nil;
}

- (void) dealloc {
    gridLayer = nil;
    [waypoints release];
    
    [super dealloc];
}
@end
