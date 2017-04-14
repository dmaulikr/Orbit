//
//  CircleEntity.m
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "CircleEntity.h"
#import "WeaponEntity.h"
#import "AppUtils.h"

@implementation CircleEntity
- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withStreak: (BOOL) enableStreak {
    if (self = [super initAtPosition: position onSide: side withNode: node physicsWorld: world withStreak: enableStreak]) {
        [self setKVO];
        
        self.isValid = NO;
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_CIRCLE;
        
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
    // self.animator.warningAnimationDuration = 2.0;
    
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
    
    // Create and add health sprite
    // The healthSprite's position will be managed by the circle sprite.
    self.healthSprite = [SKSpriteNode spriteNodeWithImageNamed: @"ph_circle_hp_bar.png"];
    self.healthSprite.size = CGSizeMake(ENTITY_DEFAULT_HEALTH_SPRITE_WIDTH, ENTITY_DEFAULT_HEALTH_SPRITE_HEIGHT);
    self.healthSprite.hidden = YES;
    [self.sprite addChild: self.healthSprite];
    
    self.speed = 1.0;
    self.isValid = YES;
    
    [self updateMetaData];
}

- (void) createPrimaryWeapon {
    // Init WeaponEntity
    CGPoint weaponPosition = CGPointMake(self.initialPosition.x, self.initialPosition.y);
    self.primaryWeapon = [[WeaponEntity alloc] initAtPosition: weaponPosition onSide: self.entitySide withNode: self.rootNode physicsWorld: self.physicsWorld withStreak: self.enableStreak];
    self.primaryWeapon.speed = 3.0f;
    self.primaryWeapon.orbitDistance = 28;
    // self.primaryWeapon.animator.warningAnimationDuration = 3.0;
}

- (void) createMotionStreak {
    /*
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

#pragma mark - Overriden Methods
- (void) update: (float) dt {
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
    
    [self.animator update: dt];
    [self.primaryWeapon update: dt];
    
    [super update: dt];
}

- (void) updateMetaData {
    CGSize screenSize = [AppUtils getScreenSize];
    self->centerPoint.x = screenSize.width / 2;
    self->centerPoint.y = screenSize.height / 2;
    // Add addition shift according to half sprite width becuase the sprite is centered on center of sprite.
    // TO DO: Don't assume Sprite is Square
    // Clamp sprite animation to within screen bounds.
    if (screenSize.width < screenSize.height)
        self->radius = screenSize.width / 2 - (self.sprite.size.width / 2);
    else
        self->radius = screenSize.height / 2 - (self.sprite.size.height / 2);
}
@end
