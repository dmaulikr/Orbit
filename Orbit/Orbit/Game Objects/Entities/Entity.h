//
//  Entity.h
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//
// Base class for all entity objects.
//
// Aside from the usual init* methods, the create* methods will handle creating and intialializing sprites.
// Entities are created with their isValid flag set to false. When animations are done, show method will
// set the isValid flag to true and thus the Entity becomes collidable.
//

#import <Foundation/Foundation.h>
#import "Enums.h"
#import "Utils.h"
#import "Animation.h"
#import "EntityConstants.h"
#import "EntitySKSpriteNode.h"

// NOTE: These are forward declarations becuase they have link dependencies on Entity.h. If we import it it will cause
// a circular dependency that will prevent building. You will have to import WeaponEntity.h in each
// subclass that needs it.
@class WeaponEntity;

@interface Entity : NSObject {
    // Flag for creating and removing self KVO from several properties.
    BOOL didSetKVO;
}

// Object Spite.
@property (nonatomic, assign) EntitySKSpriteNode * sprite;
// Object Health Sprite.
@property (nonatomic, assign) SKSpriteNode * healthSprite;
// Object Faction (is the object friendly?).
@property (nonatomic, assign) EntitySide entitySide;
// Object Type.
@property (nonatomic, assign) EntityType entityType;
// Object's Weapon.
@property (nonatomic, retain) WeaponEntity * primaryWeapon;
// Object movement speed.
@property (nonatomic, assign) CGFloat speed;
// Object health value.
@property (nonatomic, assign) CGFloat health;
// Weapon damage value. TO DO: !!!!!!!!!! This should be moved to WeaponEntity !!!!!!!!!!!!
@property (nonatomic, assign) CGFloat damage;
// Score Value
@property (nonatomic, assign) NSInteger scoreValue;
// Object validity flag for delayed destruction.
@property (nonatomic, assign) BOOL isValid;

// Parent Node Reference
@property (nonatomic, assign) SKNode * rootNode;
// Physics World Reference
@property (nonatomic, assign) SKPhysicsWorld * physicsWorld;
// Initial Position
@property (nonatomic, assign) CGPoint initialPosition;

// TO DO: @property (nonatomic, retain) CCMotionStreak * streak;
// Animation manager.
@property (nonatomic, retain) Animation * animator;

@property (nonatomic, assign) BOOL enableStreak;

// Initializers
- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withStreak: (BOOL) enableStreak;

// Create Fucntions
- (void) showEntityWithAnimation;
- (void) createSpriteAndBody;
- (void) createPrimaryWeapon;
- (void) createMotionStreak;
- (void) createAnimator;

// Object Cleanup
// This can be called to nil out all properties and cleanup all callbacks.
- (void) clearObject;

// Abstract functions - Game Loop calls.
- (void) update: (float) dt;
// Update Entity metadata in response to states changes. e.g. device orientation.
- (void) updateMetaData;

// KVO - Returns YES if setting or clearing was successfull.
- (BOOL) setKVO;
- (BOOL) clearKVO;

- (void) hide;
- (void) show;

- (void) setCollidable: (BOOL) isCollidable;

// Adds this entity's score value with all sub-entities and weapon score values.
- (NSInteger) getTotalScoreValue;
@end
