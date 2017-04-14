//
//  LineEntity.m
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "LineEntity.h"
#import "WeaponEntity.h"
#import "AppUtils.h"

@implementation LineEntity
@synthesize leftDirection = leftDirection_;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withStreak: (BOOL) enableStreak {
    if (self = [super initAtPosition: position onSide: side withNode: node physicsWorld: world withStreak: enableStreak]) {
        [self setKVO];
        
        self.isValid = NO;
        self.entitySide = side;
        self.entityType = ENTITY_TYPE_LINE;
        
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
    self.sprite = [EntitySKSpriteNode spriteNodeWithImageNamed: @"ph_line.png"];
    self.sprite.size = CGSizeMake(ENTITY_DEFAULT_SPRITE_WIDTH, ENTITY_DEFAULT_SPRITE_HEIGHT);
    self.sprite.position = self.initialPosition;
    self.sprite.entityContainer = self;
    [self.rootNode addChild: self.sprite];
    
    // Create the physics body for this Entity
    self.sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: CGSizeMake(ENTITY_DEFAULT_SPRITE_WIDTH - 10, (ENTITY_DEFAULT_SPRITE_WIDTH - 10) / 4)];
    self.sprite.physicsBody.dynamic = YES;
    self.sprite.physicsBody.affectedByGravity = NO;
   
    [self setCollidable: NO];
    
    self.sprite.hidden = YES;
    
    // Create and add health sprite
    // The healthSprite's position will be managed by the circle sprite.
    self.healthSprite = [SKSpriteNode spriteNodeWithImageNamed: @"ph_line_hp_bar.png"];
    self.healthSprite.size = CGSizeMake(ENTITY_DEFAULT_HEALTH_SPRITE_WIDTH, ENTITY_DEFAULT_HEALTH_SPRITE_HEIGHT);
    self.healthSprite.hidden = YES;
    [self.sprite addChild: self.healthSprite];
    
    self.speed = 2.0;
    self.leftDirection = YES;
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
     self.streak = [CCMotionStreak streakWithFade:0.75 minSeg:1 image:@"ph_line.png" width:64 length:64 color:ccc4(255, 255, 255, 255)];
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
    CGSize screenSize = [AppUtils getScreenSize];
    
    CGFloat xPos = self.sprite.position.x;
    if (xPos - (self.sprite.size.width / 2) <= 0) {
        self.leftDirection = NO;
    } else if (xPos + (self.sprite.size.width / 2) >= screenSize.width) {
        self.leftDirection = YES;
    }
    
    if (self.leftDirection) {
        xPos = self.sprite.position.x - self.speed;
    } else {
        xPos = self.sprite.position.x + self.speed;
    }
    
    self.sprite.position = CGPointMake(xPos, self.sprite.position.y);
    
    [self.animator update: dt];
    [self.primaryWeapon update: dt];
    
    [super update: dt];
}

- (void) updateMetaData {
    
}
@end
