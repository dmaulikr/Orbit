//
//  HUD.h
//  Orbit
//
//  Created by Ken Hung on 3/28/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class GameState;

@interface HUD : NSObject {
    
}

@property (nonatomic, retain) CCLabelTTF * scoreLabel, * weaponSpeedLabel, * weaponDamageLabel;

- (void) updateScoreLabelWithCurrentScore: (NSInteger) currentScore andGoalScore: (NSInteger) goalScore;
- (void) updateWeaponDamageLabelWithDamage: (CGFloat) damage; 
- (void) updateWeaponSpeedLabelWithSpeed: (CGFloat) speed;

- (id) initWithNode: (CCNode*) node;
@end
