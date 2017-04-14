//
//  PathedEntity.h
//  Orbit
//
//  Created by Ken Hung on 2/12/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "Entity.h"
#import "GridLayer.h"

@interface PathedEntity : Entity {
    float runSpeed;
    int direction;
    float32 lastAngularVelocity;
    CGPoint lastVelocity;
    int timesBlocked;
    
    CGPoint originalPosition;
}

@property (nonatomic, assign) GridLayer * gridLayer;
@property (nonatomic, retain) NSMutableArray * waypoints;
@property (readwrite, assign) CGPoint lastVelocity;

@property (readwrite, assign) int direction;
@property (readwrite, assign) float runSpeed;

// Slightly different init with GridLayer
- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (CCNode *) node b2World: (b2World *) world gameGrid: (GridLayer *) grid HUD: (HUD *) playerHUD withStreak: (BOOL) enableSteak;

- (void) addWaypoint;
@end
