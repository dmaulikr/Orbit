//
//  CircleEntity.m
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "CircleEntity.h"


@implementation CircleEntity

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
        self.entityType = ENTITY_TYPE_CIRCLE;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        self->centerPoint.x = screenSize.width / 2;
        self->centerPoint.y = screenSize.height / 2;
        
        if (screenSize.width < screenSize.height) // assume sprite is square
            self->radius = screenSize.width / 2 - (self.sprite.contentSize.width / 2);
        else
            self->radius = screenSize.height / 2 - (self.sprite.contentSize.width / 2);
        
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
    // Create and add unit sprite
    CCSprite * circle = [CCSprite spriteWithFile: @"ph_circle.png" rect: CGRectMake(0, 0, 72, 72)];
    circle.position = position;
 //   [circle setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }]; 
    [node addChild: circle];
    
    // Create and add health sprite
    CCSprite * circleHealth = [CCSprite spriteWithFile: @"ph_circle_hp_bar.png" rect: CGRectMake(0, 0, 72, 72)];
    circleHealth.position = position;
    [node addChild: circleHealth];
    
    self.healthSprite = circleHealth;
    self.speed = 1.0;
    
    // ===== Create Box2D body and fixtures for collision detection =====
    
    // Define the dynamic body.
    b2BodyDef bodyDef;
    bodyDef.type = b2_staticBody;
    
    bodyDef.position.Set(circle.position.x/PTM_RATIO, circle.position.y/PTM_RATIO);
    bodyDef.userData = self; 
    
    b2Body *body = world->CreateBody(&bodyDef);
    
    // Define another box shape for our dynamic body.
    //   b2PolygonShape dynamicBox;
    b2CircleShape dynamicBox;
    //dynamicBox.SetAsBox(1.0f, 1.0f);//These are mid points for our 1m box
    // dynamicBox.SetAsCircle();
    dynamicBox.m_radius = (circle.contentSize.width/2) / PTM_RATIO;
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    fixtureDef.restitution = 1.0f;
    body->CreateFixture(&fixtureDef);
    
    // Add body to Entity
    self.body = body;
    self.sprite = circle;

    [self.animator destroyWarningAnimation];
    
    self.isValid = YES;
}

- (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node {
    self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_circle.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
    self.streak.scale = 0.5f;
    self.streak.position = position;
    
    [node addChild: self.streak];
}

- (void) updatePosition: (ccTime) dt {
    [super updatePosition: dt];
    
    self->rotation += self.speed;
    
    if (self->rotation >= 360) {
        self->rotation-=360;
    }
    
    float rotInRad = (M_PI/180) * self->rotation;
    
    CGFloat x = cos(rotInRad);
    CGFloat y = sin(rotInRad);
    
    x *= self->radius;
    y *= self->radius;
    
    self.sprite.position = CGPointMake(self->centerPoint.x + x, self->centerPoint.y + y);
    self.healthSprite.position = self.sprite.position;
    
    [self.primaryWeapon updatePosition: dt];
}

- (void) dealloc {
    [super dealloc];
}
@end
