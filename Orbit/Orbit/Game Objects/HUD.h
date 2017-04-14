//
//  HUD.h
//  Orbit
//
//  Created by Ken Hung on 3/28/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "KHSKButton.h"

@interface HUD : NSObject {
    
}

@property (nonatomic, assign) SKNode * rootNode;

// Game HUD
@property (nonatomic, retain) SKLabelNode * scoreLabel, * weaponSpeedLabel, * weaponDamageLabel;
@property (nonatomic, retain) SKLabelNode * scoreText, * weaponSpeedText, * weaponDamageText;

// Level Complete UI
@property (nonatomic, retain) SKSpriteNode * levelCompleteSprite;
@property (nonatomic, retain) SKLabelNode * levelCompleteScoreLabel, * levelCompleteScoreText;
@property (nonatomic, retain) KHSKButton * levelCompleteNextLevelButton, * levelCompleteMainMenuButton;
@property (nonatomic, assign) BOOL isLevelCompleteUIShowing;

// Game Over UI
@property (nonatomic, retain) SKSpriteNode * gameOverSprite;
@property (nonatomic, retain) SKLabelNode * gameOverLabel;
@property (nonatomic, retain) KHSKButton * gameOverTryAgainButton, * gameOverMainMenuButton;
@property (nonatomic, assign) BOOL isGameOverUIShowing;

@property (nonatomic, readonly) SEL actionNextLevel;
@property (nonatomic, readonly) SEL actionTryAgain;
@property (nonatomic, readonly) SEL actionMainMenu;
@property (nonatomic, readonly, weak) id targetNextLevel;
@property (nonatomic, readonly, weak) id targetTryAgain;
@property (nonatomic, readonly, weak) id targetMainMenu;

- (id) initWithNode: (SKNode*) node;

- (void) removeFromRootNode;

// Update Game HUD
- (void) updateScoreLabelWithCurrentScore: (NSInteger) currentScore andGoalScore: (NSInteger) goalScore;
- (void) updateWeaponDamageLabelWithDamage: (CGFloat) damage; 
- (void) updateWeaponSpeedLabelWithSpeed: (CGFloat) speed;

- (void) updateUIPositions;

- (void) setNextLevelTarget: (id)target selector: (SEL) selector;
- (void) setTryAgainTarget: (id)target selector: (SEL) selector;
- (void) setMainMenuTarget: (id)target selector: (SEL) selector;

- (void) shouldShowGameHUD: (BOOL) shouldShow withAnimation: (BOOL) animate;
- (void) shouldShowLevelCompleteUI: (BOOL) shouldShow withAnimation: (BOOL) animate;
- (void) shouldShowGameOverUI: (BOOL) shouldShow withAnimation: (BOOL) animate;
@end
