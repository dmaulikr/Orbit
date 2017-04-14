//
//  WeaponEntity.m
//  Orbit
//
//  Created by Ken Hung on 1/13/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "WeaponEntity.h"

@interface WeaponEntity (AnimateMethods)
    - (void) updatePositionCircular:(float)dt;
    - (void) updatePositionElipse:(float)dt;
    - (void) updatePositionSprialSling:(float)dt;
    - (void) updatePositionLissajousCurve:(float)dt;
- (void) updatePositionWithPoint: (CGPoint) point delta: (float)dt;
@end

@implementation WeaponEntity
@synthesize protectee = protectee_, rotation = rotation_, orbitDistance = orbitDistance_, rotateClockwise = rotateClockwise, weaponType = weaponType_;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withStreak: (BOOL) enableStreak {
    if (self = [super initAtPosition: position onSide: side withNode: node physicsWorld: world withStreak: enableStreak]) {
        // Set KVOs first becuase it will automatically handle some property setting across Entities.
        [self setKVO];
        
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_CIRCLE;
        
        [self createAnimator];
        [self createSpriteAndBody];
        
        // Set the animation sprite to anchor to the WeaponEntity
        self.animator.anchorNode = self.sprite;
        
        self.speed = 0.0;
        self.protectee = nil;
        self.orbitDistance = 0;
        self.rotateClockwise = NO;
        self.damage = self.sprite.xScale;
        self.weaponType = WEAPON_TYPE_CIRCULAR;
        
        self.isValid = NO;
        
        if (self.enableStreak) {
            [self createMotionStreak];
        }
    }
    
    return self;
}

- (void) showEntityWithAnimation {
    [self.animator createWarningAnimationAtPosition: self.initialPosition completion: ^{
        [self show];
    }];
}

- (void) createSpriteAndBody {
    self.sprite = [EntitySKSpriteNode spriteNodeWithImageNamed: @"ph_circle.png"];
    self.sprite.size = CGSizeMake(ENTITY_DEFAULT_SPRITE_WIDTH, ENTITY_DEFAULT_SPRITE_HEIGHT);
    self.sprite.position = self.initialPosition;
    self.sprite.scale = 0.5f;
    self.sprite.hidden = YES;
    self.sprite.entityContainer = self;
    [self.rootNode addChild: self.sprite];

    // Create the physics body for this Entity
    self.sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: (self.sprite.size.width - 10 * 0.5f) / 2];
    self.sprite.physicsBody.dynamic = YES;
    self.sprite.physicsBody.affectedByGravity = NO;
    
    [self setCollidable: NO];

    self.healthSprite = [SKSpriteNode spriteNodeWithImageNamed: @"ph_circle_hp_bar.png"];
    self.healthSprite.size = CGSizeMake(ENTITY_DEFAULT_HEALTH_SPRITE_WIDTH, ENTITY_DEFAULT_HEALTH_SPRITE_HEIGHT);
    self.healthSprite.hidden = YES;
    // our sprite node will auto scale the healthsprite
    [self.sprite addChild: self.healthSprite];
    
    self.isValid = YES;
    
    [self updateMetaData];
}

- (void) createMotionStreak {
    // TO DO: Implement
   /* self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_circle.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
    self.streak.scale = 0.5f;
    self.streak.position = position;
    
    [node addChild: self.streak];    */
}

- (void) show {
    [super show];
    [self setCollidable: YES];
}

- (void) hide {
    [super hide];
    [self setCollidable: NO];
}

- (void) update: (float) dt {
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
    
    // TO DO: Implement
    /*
    if (self.streak) {
        self.streak.position = self.sprite.position;
    }
     */
    
    [super update: dt];
}

#pragma mark --
#pragma mark Weapon Animation Methods
- (void) updatePositionCircular: (float) dt {
    self.rotation += self.speed;
    if (self.rotation >= 360) {
        self.rotation-=360;
    }
    
    float rotInRad = (M_PI/180) * self.rotation;
    
    CGFloat x = cos(rotInRad);
    CGFloat y = sin(rotInRad);
    
    [self updatePositionWithPoint: CGPointMake(x, y) delta: dt];
}

- (void) updatePositionElipse: (float) dt {
    CGFloat xRadius = 2, yRadius = 1;
    
    self.rotation += (self.speed * 0.7);
    if (self.rotation >= 360) {
        self.rotation-=360;
    }
    
    float rotInRad = (M_PI/180) * self.rotation;
    
    CGFloat x = xRadius * cos(rotInRad);
    CGFloat y = yRadius * sin(rotInRad);
    
    [self updatePositionWithPoint: CGPointMake(x, y) delta: dt];
}

- (void) updatePositionSprialSling: (float) dt {
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
    
    [self updatePositionWithPoint: CGPointMake(x, y) delta: dt];
}

- (void) updatePositionLissajousCurve: (float) dt {
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
    
    [self updatePositionWithPoint: CGPointMake(x, y) delta: dt];
}

- (void) updatePositionWithPoint: (CGPoint) point delta: (float)dt {
    SKSpriteNode * playerSprite = self.protectee.sprite;
    SKSpriteNode * playerWeaponSprite = self.sprite;
    
    // contentSize remains the same no matter scales or rotates
    // 10  buffer
    point.x *= (playerSprite.size.width * playerSprite.xScale) / 2 + (playerWeaponSprite.size.width * playerWeaponSprite.xScale) / 2 + self.orbitDistance;
    point.y *= (playerSprite.size.height * playerSprite.xScale) / 2 + (playerWeaponSprite.size.height * playerWeaponSprite.xScale) / 2 + self.orbitDistance;
    //  NSLog(@"x: %f y: %f", x, y);
    
    playerWeaponSprite.position = CGPointMake(playerSprite.position.x + point.x, playerSprite.position.y + point.y);
    [self.animator update: dt];
}

#pragma mark - Private Methods
- (BOOL) setKVO {
    BOOL result = NO;
    
    if (!self->didSetKVO) {
        result = [super setKVO];
        self->didSetKVO = YES;
        
        return result;
    }
    
    return false;
}

- (BOOL) clearKVO {
    BOOL result = NO;
    
    if (self->didSetKVO) {
        result = [super clearKVO];
        protectee_ = nil;
        self->didSetKVO = NO;
        
        return result;
    }
    
    return false;
}

- (void) clearObject {
    [super clearObject];
    
    self.protectee = nil;
    self.rotation = 0;
    self.orbitDistance = 0;
    self.weaponType = WEAPON_TYPE_NONE;
    self.rotateClockwise = NO;
}

@end
