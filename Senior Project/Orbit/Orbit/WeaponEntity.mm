//
//  WeaponEntity.m
//  Orbit
//
//  Created by Ken Hung on 1/13/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "WeaponEntity.h"
#import "HUD.h"

@interface WeaponEntity (AnimateMethods)
    - (void) updatePositionCircular:(ccTime)dt;
    - (void) updatePositionElipse:(ccTime)dt;
    - (void) updatePositionSprialSling:(ccTime)dt;
    - (void) updatePositionLissajousCurve:(ccTime)dt;
    - (void) updatePositionWithPoint: (CGPoint) point;

    - (void) initSpriteAndBodyAt: (CGPoint) position withNode: (CCNode *) node b2World: (b2World *) world;
    - (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node;
@end

@implementation WeaponEntity
@synthesize protectee = protectee_, rotation = rotation_, orbitDistance = orbitDistance_, rotateClockwise = rotateClockwise, weaponType = weaponType_;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (CCNode *) node b2World: (b2World *) world HUD: (HUD *) playerHUD withStreak: (BOOL) enableSteak {
    if (self = [super init]) {
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_CIRCLE;
        
        [super inithAnimatorWithNode: node];
        [self initSpriteAndBodyAt: position withNode:node b2World:world];
        
        self.speed = 1.0;
        self.protectee = nil;
        self.orbitDistance = 10;
        self.rotateClockwise = NO;
        self.damage = self.sprite.scale;
        self.weaponType = WEAPON_TYPE_CIRCULAR;
        
        if (playerHUD) {
            self.observer = playerHUD;
            [self addObserver: playerHUD forKeyPath:@"damage" options:NSKeyValueObservingOptionNew context: nil];
            [self addObserver: playerHUD forKeyPath:@"speed" options:NSKeyValueObservingOptionNew context: nil];            
        }
        
        if (enableSteak) {
            [self initMotionStreakAt: self.sprite.position withNode: node];
        }
    }
    
    return self;
}

- (void) initSpriteAndBodyAt: (CGPoint) position withNode: (CCNode *) node b2World: (b2World *) world {
    CCSprite * playerWeapon = [CCSprite spriteWithFile: @"ph_circle.png" rect: CGRectMake(0, 0, 72, 72)];
    playerWeapon.position = position;
    playerWeapon.scale = 0.5f;
 //   [playerWeapon setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }]; 
    [node addChild: playerWeapon];
    
    CCSprite * weaponHealth = [CCSprite spriteWithFile: @"ph_circle_hp_bar.png" rect: CGRectMake(0, 0, 72, 72)];
    weaponHealth.position = position;
    weaponHealth.scale = 0.5f;
    
    b2BodyDef bodyDef2;
    
    if (self.entitySide & ENTITY_SIDE_ENEMY) {
        bodyDef2.type = b2_staticBody;
        [node addChild: weaponHealth];
        self.healthSprite = weaponHealth;
    } else {
        bodyDef2.type = b2_dynamicBody;
    }
    
    bodyDef2.position.Set(playerWeapon.position.x/PTM_RATIO, playerWeapon.position.y/PTM_RATIO);
    bodyDef2.userData = self;

    b2Body *body2 = world->CreateBody(&bodyDef2);
    
    // Define another box shape for our dynamic body.
    //  b2PolygonShape dynamicBox2;
    b2CircleShape dynamicBox2;
    //   dynamicBox2.SetAsBox(0.5f, 0.5f);//These are mid points for our 1m box
    dynamicBox2.m_radius = ((playerWeapon.contentSize.width/2) / PTM_RATIO) * playerWeapon.scale;
    // Define the dynamic body fixture.
    b2FixtureDef fixtureDef2;
    fixtureDef2.shape = &dynamicBox2;	
    fixtureDef2.density = 100.0f;
    fixtureDef2.friction = 0.5f;
    body2->CreateFixture(&fixtureDef2);
    
    self.body = body2;
    self.sprite = playerWeapon;
}

- (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node {
    self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_circle.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
    self.streak.scale = 0.5f;
    self.streak.position = position;
    
    [node addChild: self.streak];    
}

- (void) updatePosition: (ccTime) dt {
    [super updatePosition: dt];
    
    if (self.protectee) {
        switch (self.weaponType) {
            case WEAPON_TYPE_CIRCULAR:
                [self updatePositionCircular: dt];
                break;
            case WEAPON_TYPE_ELIPSE:
                [self updatePositionElipse: dt];
                break;
            case WEAPON_TYPE_LISSAJOUS:
                [self updatePositionLissajousCurve: dt];
                break;
            case WEAPON_TYPE_SPIRAL_SLING:
                [self updatePositionSprialSling: dt];
                break;
            case WEAPON_TYPE_NONE:
                [self updatePositionCircular: dt];
                break;
            default:
                [self updatePositionCircular: dt];
                break;
        }
    }
    
    if (self.streak) {
        self.streak.position = self.sprite.position;
    }
}

#pragma mark --
#pragma mark AnimateMethods
- (void) updatePositionCircular:(ccTime)dt {
    self.rotation += self.speed;
    if (self.rotation >= 360) {
        self.rotation-=360;
    }
    
    float rotInRad = (M_PI/180) * self.rotation;
    
    CGFloat x = cos(rotInRad);
    CGFloat y = sin(rotInRad);
    
    [self updatePositionWithPoint: CGPointMake(x, y)];
}

- (void) updatePositionElipse:(ccTime)dt {
    CGFloat xRadius = 2, yRadius = 1;
    
    self.rotation += (self.speed * 0.7);
    if (self.rotation >= 360) {
        self.rotation-=360;
    }
    
    float rotInRad = (M_PI/180) * self.rotation;
    
    CGFloat x = xRadius * cos(rotInRad);
    CGFloat y = yRadius * sin(rotInRad);
    
    [self updatePositionWithPoint: CGPointMake(x, y)];
}

- (void) updatePositionSprialSling:(ccTime)dt {
    CGFloat xRadius = 1, yRadius = 1;
    
    // BUG: orbitDistance causes weapon player collision due to it's dependance on speed
    if (!self.rotateClockwise) {
        self.orbitDistance += ((xRadius / (360 * 2)) * 80) * fabs((self.speed * 0.4));
        self.rotation += (self.speed * 0.3) + self.orbitDistance * 0.1;
    } else {
        self.orbitDistance -= ((xRadius / (360 * 2)) * 80) * fabs((self.speed * 0.4));
        self.rotation -= (self.speed * 0.4) + self.orbitDistance * 0.1;
    }
    
    if (self.rotation >= 360 * 2 || self.rotation <= 0) {
        self.rotateClockwise = !self.rotateClockwise;
    }
    
    float rotInRad = (M_PI/180) * self.rotation;
    
    CGFloat x = xRadius * cos(rotInRad);
    CGFloat y = yRadius * sin(rotInRad);
    
    [self updatePositionWithPoint: CGPointMake(x, y)];
}

- (void) updatePositionLissajousCurve:(ccTime)dt {
    self.rotation += (self.speed * 0.4);
    if (self.rotation >= 360) {
        self.rotation-=360;
    }
    
    CGFloat x, y, A, B, Wx, Wy, Sx, Sy;
    
    A = 2;
    B = 2;
    Wx = 3;
    Wy = 1;
    Sx = 0;
    Sy = 0;
    
    float rotInRad = (M_PI/180) * self.rotation;
    
    x = A * cos(2 * rotInRad) + 0.5 * cos(19 * rotInRad);//A * cos(Wx * rotInRad - Sx);
    y = B * sin(2 * rotInRad) + 0.5 * sin(17 * rotInRad);//B * sin(Wy * rotInRad - Sy);
    
    [self updatePositionWithPoint: CGPointMake(x, y)];
}

- (void) updatePositionWithPoint: (CGPoint) point {
    CCSprite * playerSprite = self.protectee.sprite;
    CCSprite * playerWeaponSprite = self.sprite;
    
    // contentSize remains the same no matter scales or rotates
    // 10  buffer
    point.x *= (playerSprite.contentSize.width * playerSprite.scale) / 2 + (playerWeaponSprite.contentSize.width * playerWeaponSprite.scale) / 2 + self.orbitDistance;
    point.y *= (playerSprite.contentSize.height * playerSprite.scale) / 2 + (playerWeaponSprite.contentSize.height * playerWeaponSprite.scale) / 2 + self.orbitDistance;
    //  NSLog(@"x: %f y: %f", x, y);
    
    playerWeaponSprite.position = CGPointMake(playerSprite.position.x + point.x, playerSprite.position.y + point.y);
    
    self.healthSprite.position = self.sprite.position;
}

- (void) dealloc {
    if (self.observer) {
        [self removeObserver: self.observer forKeyPath: @"damage"];
        [self removeObserver: self.observer forKeyPath: @"speed"];
    }
    
    protectee_ = nil;
    [super dealloc];
}

@end
