//
//  PlayerEntity.m
//  Orbit
//
//  Created by Ken Hung on 1/10/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "PlayerEntity.h"
#import "WeaponEntity.h"

@implementation PlayerEntity
@synthesize isGameOver, isWeaponPowered;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withStreak: (BOOL) enableStreak {
    if (self = [super initAtPosition: position onSide: side withNode: node physicsWorld: world withStreak: enableStreak]) {
        [self setKVO];
        
        self.isValid = NO;
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_CIRCLE;
        
        self.isGameOver = NO;
        self.isWeaponPowered = NO;
        
        [self createAnimator];
        [self createSpriteAndBody];
        [self createPrimaryWeapon];
        
        self.animator.anchorNode = self.sprite;
        
        if (self.enableStreak) {
            [self createMotionStreak];
        }
    }
    
    return self;
}

- (void) showEntityWithAnimation {
    [self.animator createWarningAnimationAtPosition: self.initialPosition completion: ^{
        [self show];
        
        if (self.primaryWeapon) {
            [self.primaryWeapon showEntityWithAnimation];
        }
    }];
}

- (void) createSpriteAndBody {
    // Create and add unit sprite
    self.sprite = [EntitySKSpriteNode spriteNodeWithImageNamed: @"ph_circle.png"];
    self.sprite.size = CGSizeMake(ENTITY_DEFAULT_SPRITE_WIDTH, ENTITY_DEFAULT_SPRITE_HEIGHT);
    self.sprite.position = self.initialPosition;
    self.sprite.entityContainer = self;
    [self.rootNode addChild: self.sprite];
    
    // Create the physics body for this Entity
    self.sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: (self.sprite.size.width - 10) / 2];
    self.sprite.physicsBody.dynamic = YES;
    self.sprite.physicsBody.affectedByGravity = NO;
    
    [self setCollidable: NO];
    
    self.sprite.hidden = YES;
    self.isValid = YES;
    
    [self updateMetaData];
}

- (void) createPrimaryWeapon {
    // Init WeaponEntity
   CGPoint weaponPosition = CGPointMake(self.initialPosition.x, self.initialPosition.y);

    self.primaryWeapon = [[WeaponEntity alloc] initAtPosition: weaponPosition onSide: self.entitySide withNode: self.rootNode physicsWorld: self.physicsWorld withStreak: self.enableStreak];
    self.primaryWeapon.speed = 8.0f;
    self.primaryWeapon.orbitDistance = 28;
}

- (void) createMotionStreak {
    /* TO DO: Implement
    self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_circle.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
    self.streak.scale = 0.5f;
    self.streak.position = position;
    
    [node addChild: self.streak];    
     */
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
    if (self.isWeaponPowered) {
        [self.primaryWeapon update: dt];
    }
    
    /* 
    // TO DO: Implement
    if (self.streak) {
        self.streak.position = self.sprite.position;
    }
    */
    
    [super update: dt];
}

- (void) updateMetaData {
    // Update conditional parameters.
}

@end
