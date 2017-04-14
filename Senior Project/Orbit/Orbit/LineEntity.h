//
//  LineEntity.h
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface LineEntity : Entity {
    
}

@property (nonatomic, assign) BOOL leftDirection;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side withNode: (CCNode *) node b2World: (b2World *) world HUD: (HUD *) playerHUD withStreak: (BOOL) enableSteak;
@end
