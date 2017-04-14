//
//  SquareEntity.m
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "SquareEntity.h"

@implementation SquareEntity
@synthesize rightDirection = rightDirection_, leftDirection = leftDirection_, upDirection = upDirection_, 
    downDirection = downDirection_;

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
        self.entityType = ENTITY_TYPE_SQUARE;
        
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
    CCSprite * square = [CCSprite spriteWithFile:@"ph_square.png" rect:CGRectMake(0, 0, 72, 72)];
    square.position = position;
  //  [square setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }]; 
    [node addChild: square];
    
    CCSprite * squareHealth = [CCSprite spriteWithFile: @"ph_square_hp_bar.png" rect:CGRectMake(0, 0, 72, 72)];
    squareHealth.position = position;
    [node addChild:squareHealth];
    
    self.healthSprite = squareHealth;
    self.rightDirection = NO;
    self.leftDirection = NO;
    self.upDirection = NO;
    self.downDirection = YES;
    self.speed = 3.0f;
    
    b2BodyDef bodyDef3;
    bodyDef3.type = b2_staticBody;//b2_dynamicBody;
    
    bodyDef3.position.Set(square.position.x/PTM_RATIO, square.position.y/PTM_RATIO);
    bodyDef3.userData = self;
    
    b2Body *body3 = world->CreateBody(&bodyDef3);
    
    // Define another box shape for our dynamic body.
    b2PolygonShape dynamicBox3;
    dynamicBox3.SetAsBox(1.0f, 1.0f);//These are mid points for our 1m box
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef3;
    fixtureDef3.shape = &dynamicBox3;	
    fixtureDef3.density = 1.0f;
    fixtureDef3.friction = 0.3f;
    fixtureDef3.restitution = 1.0f;
    body3->CreateFixture(&fixtureDef3);
    
    self.body = body3;
    self.sprite = square;
    
    [self.animator destroyWarningAnimation];
    
    self.isValid = YES;
}

- (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node {
    self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_square.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
    self.streak.scale = 0.5f;
    self.streak.position = position;
    
    [node addChild: self.streak];
}

- (void) updatePosition: (ccTime) dt {
    [super updatePosition: dt];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CGFloat xPos = self.sprite.position.x;
    CGFloat yPos = self.sprite.position.y;
    
    CGFloat squareWidth = self.sprite.contentSize.width;
    CGFloat squareHeight = self.sprite.contentSize.height;
    
    if (self.upDirection) {
        yPos += self.speed;
        
        if (yPos + squareHeight/2 >= screenSize.height) {
            self.rightDirection = YES;
            self.upDirection = NO;
        }
    } else if (self.downDirection) {
        yPos -= self.speed;
        
        if (yPos - squareHeight/2 <= 0) {
            self.leftDirection = YES;
            self.downDirection = NO;
        }
    } else if (self.rightDirection) {
        xPos += self.speed;
        
        if (xPos + squareWidth/2 >= screenSize.width) {
            self.downDirection = YES;
            self.rightDirection = NO;
        }
    } else if (self.leftDirection) {
        xPos -= self.speed;
        
        if (xPos - squareWidth/2 <= 0) {
            self.upDirection = YES;
            self.leftDirection = NO;
        }
    }
    
    self.sprite.position = CGPointMake(xPos, yPos);
    self.healthSprite.position = self.sprite.position;
}

- (void) dealloc {
    [super dealloc];
}
@end
