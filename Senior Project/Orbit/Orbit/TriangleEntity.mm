//
//  TriangleEntity.m
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "TriangleEntity.h"


@implementation TriangleEntity
@synthesize heightIncrement = heightIncrement_, widthIncrement = widthIncrement_, topRightDirection = topRightDirection_, 
    bottomRightDirection = bottomRightDirection_, middleLeftDirection = middleLeftDirection_;

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
        self.entityType = ENTITY_TYPE_TRIANGLE;
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        // m = (sh - sh/2 /sw) also accounting for the fact that sh - tri.content.h/2
        self.heightIncrement = ((screenSize.height - (self.sprite.contentSize.height / 2)) 
                                - ((screenSize.height - (self.sprite.contentSize.height / 2)) / 2)) / screenSize.width;
        self.widthIncrement = 1.0f;
        
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
    CCSprite * triangle = [CCSprite spriteWithFile:@"ph_triangle.png"
                                              rect:CGRectMake(0, 0, 72, 72)];
    triangle.position = position;
    triangle.rotation = -90;
 //   [triangle setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }]; 
    [node addChild: triangle];
    
    CCSprite * triangleHealth = [CCSprite spriteWithFile:@"ph_triangle_hp_bar.png"
                                                    rect:CGRectMake(0, 0, 72, 72)];
    triangleHealth.position = position;
    triangleHealth.rotation = -90;
    [node addChild: triangleHealth];
    
    self.healthSprite = triangleHealth;
    self.speed = 4.0f;
    self.topRightDirection = YES;
    self.bottomRightDirection = NO;
    self.middleLeftDirection = NO;
    
    b2BodyDef bodyDef4;
    bodyDef4.type = b2_staticBody;//b2_dynamicBody;
    //  bodyDef4.linearVelocity = b2Vec2(-10.0f, 0.0f);
    bodyDef4.position.Set(triangle.position.x/PTM_RATIO, triangle.position.y/PTM_RATIO);
    bodyDef4.userData = self;
    
    b2Body *body4 = world->CreateBody(&bodyDef4);
    
    // Define another box shape for our dynamic body.
    b2PolygonShape dynamicBox4;
    CGFloat tri_width = triangle.contentSize.width;
    b2Vec2 verts[] = {
        b2Vec2(0.0f - ((tri_width / 2) / PTM_RATIO), 0.0f - ((tri_width / 2) / PTM_RATIO)),
        b2Vec2((tri_width / PTM_RATIO) - ((tri_width / 2) / PTM_RATIO), 0.0f - ((tri_width / 2) / PTM_RATIO)),
        b2Vec2(((tri_width / 2) / PTM_RATIO) - ((tri_width / 2) / PTM_RATIO), tri_width / PTM_RATIO - ((tri_width / 2) / PTM_RATIO))
    };
    
    dynamicBox4.Set(verts, 3);
    //  dynamicBox4.SetAsBox(1.0f, 1.0f);//These are mid points for our 1m box
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef4;
    fixtureDef4.shape = &dynamicBox4;	
    fixtureDef4.density = 1.0f;
    fixtureDef4.friction = 0.3f;
    fixtureDef4.restitution = 1.0f;
    body4->CreateFixture(&fixtureDef4);
    
    self.body = body4;
    self.sprite = triangle;

    [self.animator destroyWarningAnimation];
    
    self.isValid = YES;
}

- (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node {
    self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_triangle.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
    self.streak.scale = 0.5f;
    self.streak.position = position;
    
    [node addChild: self.streak];
}

- (void) updatePosition: (ccTime) dt {
    [super updatePosition: dt];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CGFloat xPos = self.sprite.position.x;
    CGFloat yPos = self.sprite.position.y;
    
    if (xPos + (self.sprite.contentSize.width / 2) >= screenSize.width) {
        if (yPos + (self.sprite.contentSize.height / 2) >= screenSize.height) {
            self.topRightDirection = NO;
            self.bottomRightDirection = YES;
            self.middleLeftDirection = NO;
        } else if (yPos - (self.sprite.contentSize.height / 2) <= 0.0f) {
            self.topRightDirection = NO;
            self.bottomRightDirection = NO;
            self.middleLeftDirection = YES;   
        } else { // in between
            self.topRightDirection = NO;
            self.bottomRightDirection = YES;
            self.middleLeftDirection = NO;
        }
    } else if (xPos - (self.sprite.contentSize.width / 2) <= 0.0f) {
        self.topRightDirection = YES;
        self.bottomRightDirection = NO;
        self.middleLeftDirection = NO;
    }
    
    if (self.topRightDirection) {
        xPos += self.widthIncrement * self.speed;
        yPos += self.heightIncrement * self.speed; 
    } else if (self.bottomRightDirection) {
        yPos -= self.speed;
    } else if (self.middleLeftDirection) {
        xPos -= self.widthIncrement * self.speed;
        yPos += self.heightIncrement * self.speed; 
    }
    
    self.sprite.position = CGPointMake(xPos, yPos);
    self.healthSprite.position = self.sprite.position;
}

- (void) dealloc {
    [super dealloc];
}
@end
