//
//  PlayerEntity.m
//  Orbit
//
//  Created by Ken Hung on 1/10/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "PlayerEntity.h"
#import "HUD.h"
#import "WeaponEntity.h"

@implementation PlayerEntity
@synthesize isGameOver, isWeaponPowered;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (CCNode *) node b2World: (b2World *) world HUD: (HUD *) playerHUD withStreak: (BOOL) enableSteak {
    if (self = [super init]) {
        [super inithAnimatorWithNode: node];
        [self initSpriteAndBodyAt: position withNode:node b2World:world];
        
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_CIRCLE;
        
        self.isGameOver = NO;
        self.isWeaponPowered = NO;
        
        // Init WeaponEntity
        CGPoint weaponPosition = ccp(position.x + (position.x * 0.5), position.y);
        
        self.primaryWeapon = [[WeaponEntity alloc] initAtPosition: weaponPosition onSide: self.entitySide | ENTITY_SIDE_WEAPON withNode: node b2World: world HUD: playerHUD withStreak:YES];
        self.primaryWeapon.speed = 8.0f;
        self.primaryWeapon.orbitDistance = 28;
        
        if (enableSteak) {
            [self initMotionStreakAt: self.sprite.position withNode: node];
        }
    }
    
    return self;
}

- (void) initSpriteAndBodyAt: (CGPoint) position withNode: (CCNode *) node b2World: (b2World *) world {
    // ----- Setup Sprite
    CCSprite * player = [CCSprite spriteWithFile:@"ph_circle.png" rect:CGRectMake(0, 0, 72, 72)];
    player.position = position;
    player.scale = 1.0;//0.75; // for precision?
  //  [player setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }]; 
    [node addChild: player];
    
    // ----- Define the dynamic body.
    //Set up a 1m squared box in the physics world
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    
    bodyDef.position.Set(player.position.x/PTM_RATIO, player.position.y/PTM_RATIO);
    bodyDef.userData = self; // entities should keep this alive

    b2Body *body = world->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    //   b2PolygonShape dynamicBox;
    b2CircleShape dynamicBox;
    //dynamicBox.SetAsBox(1.0f, 1.0f);//These are mid points for our 1m box
    // dynamicBox.SetAsCircle();
    dynamicBox.m_radius = (player.contentSize.width/2) / PTM_RATIO * player.scale * 0.8; // sprite hit box adjustment
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    fixtureDef.isSensor = true;
    body->CreateFixture(&fixtureDef);
    
    self.body = body;
    self.sprite = player;
}

- (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node {
    self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_circle.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
    self.streak.scale = 0.5f;
    self.streak.position = position;
    
    [node addChild: self.streak];    
}

- (void) updatePosition: (ccTime) dt {
    if (self.isValid) {
        [super updatePosition: dt];
        
        if (self.isWeaponPowered)
            [self.primaryWeapon updatePosition: dt];
        
        if (self.streak) {
            self.streak.position = self.sprite.position;
        }
    }
}

- (void) dealloc {
    [super dealloc];
}

@end
