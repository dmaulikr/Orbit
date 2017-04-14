//
//  HUD.m
//  Orbit
//
//  Created by Ken Hung on 3/28/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//
//  KVOs GameState to update itself

#import "HUD.h"
#import "GameState.h"
#import "WeaponEntity.h"

@implementation HUD
@synthesize scoreLabel, weaponSpeedLabel, weaponDamageLabel;

- (id) initWithNode: (CCNode *) node {
    if (self = [super init]) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        self.scoreLabel = [CCLabelTTF labelWithString: @"" fontName: @"Arial" fontSize:22];
        [self.scoreLabel setColor:ccc3(255, 255, 255)];
        self.scoreLabel.position = ccp(120, screenSize.height - 10);
        [node addChild: self.scoreLabel z: 1];
        
        // Weapon Stats
        self.weaponDamageLabel = [CCLabelTTF labelWithString:@"W Damage: -" fontName: @"Arial" fontSize: 22];
        [self.weaponDamageLabel setColor: ccc3(255, 255, 255)];
        self.weaponDamageLabel.position = ccp(screenSize.width - 120, screenSize.height - 10);
        [node addChild: self.weaponDamageLabel z: 1];
        
        self.weaponSpeedLabel = [CCLabelTTF labelWithString: @"W Speed: -" fontName: @"Arial" fontSize: 22];
        [self.weaponSpeedLabel setColor:ccc3(255, 255, 255)];
        self.weaponSpeedLabel.position = ccp(self.weaponDamageLabel.position.x - 180, screenSize.height - 10);
        [node addChild: self.weaponSpeedLabel z: 1];
    }
    
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString: @"currentScore"]) {
        if ([object isKindOfClass: [GameState class]]) {
            GameState * gameState = (GameState*) object;
            
            [self updateScoreLabelWithCurrentScore: gameState.currentScore andGoalScore: gameState.goalScore];
        }
    } else if ([keyPath isEqualToString: @"speed"]) {
        if ([object isKindOfClass: [WeaponEntity class]]) {
            WeaponEntity * weaponEntity = (WeaponEntity*) object;
            
            [self updateWeaponSpeedLabelWithSpeed: weaponEntity.speed];
        }
    } else if ([keyPath isEqualToString: @"damage"]) {
        if ([object isKindOfClass: [WeaponEntity class]]) {
            WeaponEntity * weaponEntity = (WeaponEntity*) object;
            
            [self updateWeaponDamageLabelWithDamage: weaponEntity.damage];
        }
    }
}

- (void) updateScoreLabelWithCurrentScore: (NSInteger) currentScore andGoalScore: (NSInteger) goalScore {
    [self.scoreLabel setString: [NSString stringWithFormat: @"%d/%d", currentScore, goalScore]];
}

- (void) updateWeaponDamageLabelWithDamage: (CGFloat) damage {
    [self.weaponDamageLabel setString: [NSString stringWithFormat: @"W Damage %f", damage]];
}

- (void) updateWeaponSpeedLabelWithSpeed: (CGFloat) speed {
    [self.weaponSpeedLabel setString: [NSString stringWithFormat: @"W Speed %f", speed]];
}
@end
