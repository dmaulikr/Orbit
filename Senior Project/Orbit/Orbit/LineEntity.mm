//
//  LineEntity.m
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "LineEntity.h"
#import "WeaponEntity.h"

@implementation LineEntity
@synthesize leftDirection = leftDirection_;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (CCNode *) node b2World: (b2World *) world HUD: (HUD *) playerHUD withStreak: (BOOL) enableSteak {
    if (self = [super init]) {
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
        
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_LINE;
        
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
    CCSprite * line = [CCSprite spriteWithFile: @"ph_line.png" rect: CGRectMake(0, 0, 72, 72)];
    line.position = position;
  //  [line setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }]; 
    [node addChild: line];
    
    CCSprite * lineHealth = [CCSprite spriteWithFile: @"ph_line_hp_bar.png" rect: CGRectMake(0, 0, 72, 72)];
    lineHealth.position = position;
    [node addChild: lineHealth];
    
    self.healthSprite = lineHealth;
    self.speed = 2.0;
    self.leftDirection = YES;
    
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    bodyDef.position.Set(line.position.x/PTM_RATIO, line.position.y/PTM_RATIO);
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
    self.sprite = line;
    
    [self.animator destroyWarningAnimation];
    
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
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CGFloat xPos = self.sprite.position.x;
    if (xPos - (self.sprite.contentSize.width / 2) <= 0) {
        self.leftDirection = NO;
    } else if (xPos + (self.sprite.contentSize.width / 2) >= screenSize.width) {
        self.leftDirection = YES;
    }
    
    if (self.leftDirection) {
        xPos = self.sprite.position.x - self.speed;
    } else {
        xPos = self.sprite.position.x + self.speed;
    }
    
    self.sprite.position = CGPointMake(xPos, self.sprite.position.y);
    self.healthSprite.position = self.sprite.position;
}

- (void) dealloc {
    [super dealloc];
}
@end
