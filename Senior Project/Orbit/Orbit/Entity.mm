//
//  Entity.m
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "Entity.h"
#import "WeaponEntity.h"

@implementation Entity
@synthesize sprite = sprite_, entitySide = entitySide_, entityType = entityType_, speed = speed_, isValid = isValid_,
    healthSprite = healthSprite_, health = health_, primaryWeapon = primaryWeapon_, body = body_, bodyDef = bodyDef_, 
    fixtureDef = fixtureDef_, polygonShape = polygonShape_, circleShape = circleShape_, streak = streak_, observer = observer_,
    damage = damage_, animator = animator_;

-(id) init
{
	if ((self = [super init])) {
        self.sprite = nil;
        self.healthSprite = nil;
        self.entitySide = ENTITY_SIDE_NONE;
        self.entityType = ENTITY_TYPE_NONE;
        self.speed = 0.0;
        self.isValid = YES;
        self.health = 1.0;
        self.primaryWeapon = nil;
        self.damage = 1.0;
        
        // Box2D inits
        self.body = nil;
        self.bodyDef = nil;
        self.fixtureDef = nil;
        self.polygonShape = nil;
        self.circleShape = nil;
        
        self.streak = nil;
        
        self.animator = nil;
        
        [self addObserver: self forKeyPath: @"health" options: NSKeyValueObservingOptionNew context: nil];
        [self addObserver: self forKeyPath: @"primaryWeapon" options: NSKeyValueObservingOptionNew context: nil];
        [self addObserver: self forKeyPath: @"healthSprite" options: NSKeyValueObservingOptionNew context: nil];
        [self addObserver: self forKeyPath: @"damage" options: NSKeyValueObservingOptionNew context: nil];
    }
    
    return self;
}
    
// Subclass to override functionality
- (void) updatePosition: (ccTime) dt {
    
}

- (void) draw {
    
}

- (void) initSpriteAndBodyAt: (CGPoint) position withNode: (CCNode *) node b2World: (b2World *) world {
    
}

- (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node {
    
}

- (void) inithAnimatorWithNode: (CCNode *) node {
    self.animator = [[Animation alloc] initWithNode: node];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString: @"health"]) {
        self.healthSprite.scale = self.health;
    }
    
    if ([keyPath isEqualToString: @"healthSprite"]) {
        self.health = self.healthSprite.scale;
    }
    
    if ([keyPath isEqualToString: @"primaryWeapon"]) {
        self.primaryWeapon.protectee = self;
    }
    
    if ([keyPath isEqualToString: @"damage"]) {
        self.primaryWeapon.sprite.scale = self.damage;
    }
    
    if (self.health <= 0) {

    }
}

- (void) dealloc {
    [self removeObserver: self forKeyPath: @"health"];
    [self removeObserver: self forKeyPath: @"primaryWeapon"];
    [self removeObserver: self forKeyPath: @"healthSprite"];
    [self removeObserver: self forKeyPath: @"damage"];
    
    [sprite_ release];
    [healthSprite_ release];
    [primaryWeapon_ release];
    
    if (streak_) {
        [streak_ release];
    }
    
    if (animator_) {
        [animator_ release];
    }
    
    observer_ = nil;
    
    [super dealloc];
}
@end
