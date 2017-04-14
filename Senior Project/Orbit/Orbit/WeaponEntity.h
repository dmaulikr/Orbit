//
//  WeaponEntity.h
//  Orbit
//
//  Created by Ken Hung on 1/13/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "Entity.h"

@class HUD;

@interface WeaponEntity : Entity {
    
}

@property (nonatomic, assign) Entity * protectee;
@property (nonatomic, assign) CGFloat rotation, orbitDistance;
@property (nonatomic, assign) WeaponType weaponType;
@property (nonatomic, assign) BOOL rotateClockwise;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (CCNode *) node b2World: (b2World *) world HUD: (HUD *) playerHUD withStreak: (BOOL) enableSteak;
@end
