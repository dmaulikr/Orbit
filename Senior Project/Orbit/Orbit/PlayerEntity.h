//
//  PlayerEntity.h
//  Orbit
//
//  Created by Ken Hung on 1/10/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "Entity.h"
@class HUD;

@interface PlayerEntity : Entity {

}

@property (nonatomic, assign) BOOL isGameOver, isWeaponPowered;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (CCNode *) node b2World: (b2World *) world HUD: (HUD *) playerHUD withStreak: (BOOL) enableSteak;
@end
