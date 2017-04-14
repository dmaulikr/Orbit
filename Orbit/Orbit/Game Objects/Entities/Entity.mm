//
//  Entity.m
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "Entity.h"
#import "WeaponEntity.h"

@interface Entity (Private)

@end

@implementation Entity
@synthesize entitySide = entitySide_, entityType = entityType_, speed = speed_, isValid = isValid_, healthSprite = healthSprite_, health = health_, primaryWeapon = primaryWeapon_,/*  TO DO: streak = streak_,*/ damage = damage_, animator = animator_, rootNode = rootNode_, physicsWorld = physicsWorld_, initialPosition = initialPosition_, enableStreak = enableStreak_, scoreValue = scoreValue_;

- (id) init
{
	if ((self = [super init])) {

    }
    
    return self;
}

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withStreak: (BOOL) enableStreak {
    if (self = [self init]) {
        self.physicsWorld = world;
        self.rootNode = node;
        
        self.entitySide = side;
        self.initialPosition = position;
        self.enableStreak = enableStreak;
    }
    
    return self;
}

- (void) clearObject {
    [self clearKVO];
    
    self.healthSprite.physicsBody = nil;
    // Have to set SKTexture manually in order for it to be removed from scene.
    self.healthSprite.texture = nil;
    self.healthSprite = nil;
    self.sprite.physicsBody = nil;
    self.sprite.texture = nil;
    self.sprite.entityContainer = nil;
    self.sprite = nil;
    self.entitySide = ENTITY_SIDE_NONE;
    self.entityType = ENTITY_TYPE_NONE;
    [self.primaryWeapon clearObject];
    self.primaryWeapon = nil;
    // self.speed = 0;
    // self.health = 0;
    // self.damage = 0;
    self.isValid = NO;
    [self.animator destroyWarningAnimations];
    self.animator = nil;
    self.rootNode = nil;
    self.physicsWorld = nil;
    // self.initialPosition = CGPointZero;
    self.enableStreak = NO;
    // self.scoreValue = 0;
    
    [self.sprite removeFromParent];
    [self.healthSprite removeFromParent];
    
    // TO DO: Fix
    // streak_ = nil;
}
    
#pragma mark - Overridable Methods
- (void) update: (float) dt {
    
}

- (void) updateMetaData {
    
}

- (void) showEntityWithAnimation {
    
}

- (void) createSpriteAndBody {
    
}

- (void) createMotionStreak {
    
}

- (void) createPrimaryWeapon {
    
}

- (void) createAnimator {
    self.animator = [[Animation alloc] initWithNode: self.rootNode];
}

- (void) hide {
    self.sprite.hidden = YES;
    self.healthSprite.hidden = YES;
    self.isValid = NO;
}

- (void) show {
    self.sprite.hidden = NO;
    self.healthSprite.hidden = NO;
    self.isValid = YES;
}

- (void) setCollidable: (BOOL) isCollidable {
    if (self.sprite && self.sprite.physicsBody) {
        if (isCollidable) {
            // What are you?
            self.sprite.physicsBody.categoryBitMask = self.entitySide;
            // What can collide with you? (apply physics)
            self.sprite.physicsBody.collisionBitMask = ENTITY_TYPE_NONE;
            // What can cause collision callbacks with you?
            self.sprite.physicsBody.contactTestBitMask = self.entitySide ^ ENTITY_SIDE_ALL;
        } else {
            self.sprite.physicsBody.categoryBitMask = ENTITY_SIDE_NONE;
            self.sprite.physicsBody.collisionBitMask = ENTITY_TYPE_NONE;
            self.sprite.physicsBody.contactTestBitMask = ENTITY_SIDE_NONE;
        }
    }
}

- (NSInteger) getTotalScoreValue {
    return self.scoreValue + (self.primaryWeapon && self.primaryWeapon.isValid ? [self.primaryWeapon getTotalScoreValue] : 0);
}

#pragma mark - Key Value Observer
/**
 * This is how we keep health and the health sprite variables in sync.
 */
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // NOTE: The use of xScale. This assumes all sprites are equilateral.
    if ([keyPath isEqualToString: @"health"]) {
        if (self.health <= 0) {
            [Animation createScoreTextAnimationInNode: self.rootNode atPosition: self.sprite.position withText: [NSString stringWithFormat: @"+ %d", [self getTotalScoreValue]] completion: nil];
            
            self.isValid = NO;
            [self setCollidable: NO];
            [self clearObject];
            return;
        }
        
        self.healthSprite.xScale = self.health;
        self.healthSprite.yScale = self.health;
    }
    
    if ([keyPath isEqualToString: @"healthSprite"]) {
        self.health = self.healthSprite.xScale;
    }
    
    if ([keyPath isEqualToString: @"primaryWeapon"]) {
        self.primaryWeapon.protectee = self;
    }
    
    if ([keyPath isEqualToString: @"damage"]) {
        self.primaryWeapon.sprite.xScale = self.damage;
    }
}

#pragma mark - Private Functions
- (BOOL) setKVO {
    if (!self->didSetKVO) {
        [self addObserver: self forKeyPath: @"health" options: NSKeyValueObservingOptionNew context: nil];
        [self addObserver: self forKeyPath: @"primaryWeapon" options: NSKeyValueObservingOptionNew context: nil];
        [self addObserver: self forKeyPath: @"healthSprite" options: NSKeyValueObservingOptionNew context: nil];
        [self addObserver: self forKeyPath: @"damage" options: NSKeyValueObservingOptionNew context: nil];
        
        self->didSetKVO = YES;
        
        return YES;
    }
    
    return NO;
}

- (BOOL) clearKVO {
    if (self->didSetKVO) {
        [self removeObserver: self forKeyPath: @"health"];
        [self removeObserver: self forKeyPath: @"primaryWeapon"];
        [self removeObserver: self forKeyPath: @"healthSprite"];
        [self removeObserver: self forKeyPath: @"damage"];
        
        self->didSetKVO = NO;
        
        return YES;
    }
    
    return NO;
}

- (void) dealloc {
    // Eventhough we cant call dealloc manually it appears it's still called by ARC.
    // This is the best place to handle things like removing observers.
    // DON'T call [super dealloc], ARC calls it for you already.
    [self clearKVO];
}
@end
