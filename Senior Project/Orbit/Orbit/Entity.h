//
//  Entity.h
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Enums.h"
#import "Box2D.h"
#import "b2Body.h"
#import "Utils.h"
#import "Animation.h"

@class WeaponEntity;
@class HUD;

@interface Entity : NSObject {

}

@property (nonatomic, retain) CCSprite * sprite;
@property (nonatomic, retain) CCSprite * healthSprite;
@property (nonatomic, readwrite) EntitySide entitySide;
@property (nonatomic, readwrite) EntityType entityType;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat health;
@property (nonatomic, assign) CGFloat damage;
@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, retain) WeaponEntity * primaryWeapon;

// Box2D Pointers
@property (nonatomic, assign) b2Body * body;
@property (nonatomic, assign) b2BodyDef *bodyDef;
@property (nonatomic, assign) b2FixtureDef *fixtureDef;
@property (nonatomic, assign) b2PolygonShape *polygonShape;
@property (nonatomic, assign) b2CircleShape *circleShape;

@property (nonatomic, retain) CCMotionStreak * streak;

@property (nonatomic, assign) HUD * observer;

// Animation
@property (nonatomic, retain) Animation * animator;

// Abstract functions
- (void) updatePosition: (ccTime) dt;
- (void) draw;
- (void) initSpriteAndBodyAt: (CGPoint) position withNode: (CCNode *) node b2World: (b2World *) world;
- (void) initMotionStreakAt: (CGPoint) position withNode: (CCNode *) node;
- (void) inithAnimatorWithNode: (CCNode *) node;
@end
