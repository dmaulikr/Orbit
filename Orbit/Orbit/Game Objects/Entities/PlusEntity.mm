//
//  PlusEntity.m
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "PlusEntity.h"


@implementation PlusEntity
@synthesize topRightDirection = topRightDirection_, topLeftDirection = topLeftDirection_, bottomRightDirection = bottomRightDirection_, 
    bottomLeftDirection = bottomLeftDirection_, inwardDirection = inwardDirection_, isInCenter = isInCetner_;
@synthesize heightIncrement, widthIncrement;

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
        self.entityType = ENTITY_TYPE_PLUS;
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        if (screenSize.width > screenSize.height) {
            self.heightIncrement = screenSize.height/screenSize.width;
            self.widthIncrement = 1.0f;
        } else {
            self.heightIncrement = 1.0f;
            self.widthIncrement = screenSize.width/screenSize.height;
        }
        
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
    CCSprite * plus = [CCSprite spriteWithFile: @"ph_plus.png" rect: CGRectMake(0, 0, 72, 72)];
    plus.position = position;
    plus.rotation = 45;
 //   [plus setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }]; 
    [node addChild: plus];
    
    CCSprite * plusHealth = [CCSprite spriteWithFile: @"ph_plus_hp_bar.png" rect: CGRectMake(0, 0, 72, 72)];
    plusHealth.position = position;
    plusHealth.rotation = 45;
    [node addChild: plusHealth];
    
    self.healthSprite = plusHealth;
    self.topLeftDirection = NO;
    self.topRightDirection = YES;
    self.bottomLeftDirection = NO;
    self.bottomRightDirection = NO;
    self.isInCenter = YES;
    self.inwardDirection = YES;
    
    b2BodyDef bodyDef5;
    bodyDef5.type = b2_staticBody;//b2_dynamicBody;
    
    bodyDef5.position.Set(plus.position.x/PTM_RATIO, plus.position.y/PTM_RATIO);
    bodyDef5.userData = self;
    
    b2Body *body5 = world->CreateBody(&bodyDef5);
    
    b2PolygonShape dynamicBoxX1;
    CGFloat plusWidth = plus.contentSize.width / 7;
    CGFloat plusShift = (plus.contentSize.width / 2) / PTM_RATIO;
    b2Vec2 vertsX1[] = {
        b2Vec2(0.0f - plusShift, (plusWidth * 4) / PTM_RATIO - plusShift),
        b2Vec2(0.0f - plusShift, (plusWidth * 3) / PTM_RATIO  - plusShift),
        b2Vec2((plusWidth * 7) / PTM_RATIO - plusShift, (plusWidth * 3) / PTM_RATIO - plusShift),
        b2Vec2((plusWidth * 7) / PTM_RATIO - plusShift, (plusWidth * 4) / PTM_RATIO - plusShift),
    };
    
    dynamicBoxX1.Set(vertsX1, 4);
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDefX1;
    fixtureDefX1.shape = &dynamicBoxX1;	
    fixtureDefX1.density = 1.0f;
    fixtureDefX1.friction = 0.3f;
    fixtureDefX1.restitution = 1.0f;
    body5->CreateFixture(&fixtureDefX1);
    
    b2PolygonShape dynamicBoxX2;
    b2Vec2 vertsX2[] = {
        b2Vec2((plusWidth * 3) / PTM_RATIO - plusShift, 0.0f - plusShift),
        b2Vec2((plusWidth * 4) / PTM_RATIO - plusShift, 0.0f - plusShift),
        b2Vec2((plusWidth * 4) / PTM_RATIO - plusShift, (plusWidth * 7) / PTM_RATIO - plusShift),
        b2Vec2((plusWidth * 3) / PTM_RATIO - plusShift, (plusWidth * 7) / PTM_RATIO - plusShift),
    };
    
    dynamicBoxX2.Set(vertsX2, 4);
    
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDefX2;
    fixtureDefX2.shape = &dynamicBoxX2;	
    fixtureDefX2.density = 1.0f;
    fixtureDefX2.friction = 0.3f;
    fixtureDefX2.restitution = 1.0f;
    body5->CreateFixture(&fixtureDefX2);
    
    self.body = body5;
    self.sprite = plus;

    [self.animator destroyWarningAnimation];
    
    self.isValid = YES;
}

- (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node {
    self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_plus.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
    self.streak.scale = 0.5f;
    self.streak.position = position;
    
    [node addChild: self.streak];
}

- (void) updatePosition: (ccTime) dt {
    [super updatePosition: dt];
    
    CGPoint pos = self.sprite.position;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGFloat plusSize = self.sprite.contentSize.width / 2;
    
    // At center, switch directions
    if (pos.x <= (screenSize.width / 2) + plusSize / 2
        && pos.x >= (screenSize.width / 2) - plusSize / 2
        && pos.y <= (screenSize.height / 2) + plusSize / 2
        && pos.y >= (screenSize.height / 2) - plusSize / 2) {
        
        if (!self.isInCenter) {
            if (self.topLeftDirection) {
                self.topLeftDirection = NO;
                self.topRightDirection = YES;
            } else if (self.topRightDirection) {
                self.topRightDirection = NO;
                self.bottomRightDirection = YES;
            } else if (self.bottomLeftDirection) {
                self.bottomLeftDirection = NO;
                self.topLeftDirection = YES;
            } else if (self.bottomRightDirection) {
                self.bottomRightDirection = NO;
                self.bottomLeftDirection = YES;
            }
            
            self.inwardDirection = YES;
            self.isInCenter = YES;
        }
    } else if (pos.x >= (screenSize.width - plusSize) && pos.y >= (screenSize.height - plusSize)) { // at top right
        // error correction
        self.topLeftDirection = NO;
        self.topRightDirection = YES;
        self.bottomLeftDirection = NO;
        self.bottomRightDirection = NO;
        
        self.inwardDirection = NO;
    } else if (pos.x <= (0.0f + plusSize) && pos.y >= (screenSize.height - plusSize)) { // at top left
        // error correction
        self.topLeftDirection = YES;
        self.topRightDirection = NO;
        self.bottomLeftDirection = NO;
        self.bottomRightDirection = NO;
        
        self.inwardDirection = NO;
    } else if (pos.x >= (screenSize.width - plusSize) && pos.y <= (0.0f + plusSize)) { // at bottom right
        // error correction
        self.topLeftDirection = NO;
        self.topRightDirection = NO;
        self.bottomLeftDirection = NO;
        self.bottomRightDirection = YES;
        
        self.inwardDirection = NO;
    } else if (pos.x <= (0.0f + plusSize) && pos.y <= (0.0f + plusSize)) { // at bottom left
        // error correction
        self.topLeftDirection = NO;
        self.topRightDirection = NO;
        self.bottomLeftDirection = YES;
        self.bottomRightDirection = NO;
        
        self.inwardDirection = NO;
    } else {
        self.isInCenter = NO;
    }
    
    if (self.topLeftDirection) {
        if (self.inwardDirection)
            self.sprite.position = CGPointMake(pos.x - self.widthIncrement, pos.y + self.heightIncrement);
        else
            self.sprite.position = CGPointMake(pos.x + self.widthIncrement, pos.y - self.heightIncrement);
    } else if (self.topRightDirection) {
        if (self.inwardDirection)
            self.sprite.position = CGPointMake(pos.x + self.widthIncrement, pos.y + self.heightIncrement);
        else
            self.sprite.position = CGPointMake(pos.x - self.widthIncrement, pos.y - self.heightIncrement);
    } else if (self.bottomLeftDirection) {
        if (self.inwardDirection)
            self.sprite.position = CGPointMake(pos.x - self.widthIncrement, pos.y - self.heightIncrement);
        else
            self.sprite.position = CGPointMake(pos.x + self.widthIncrement, pos.y + self.heightIncrement);
    } else if (self.bottomRightDirection) {
        if (self.inwardDirection)
            self.sprite.position = CGPointMake(pos.x + self.widthIncrement, pos.y - self.heightIncrement);
        else 
            self.sprite.position = CGPointMake(pos.x - self.widthIncrement, pos.y + self.heightIncrement);
    }
    
    self.healthSprite.position = self.sprite.position;
}

- (void) dealloc {
    [super dealloc];
}
@end
