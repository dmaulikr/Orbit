//
//  HUD.m
//  Orbit
//
//  Created by Ken Hung on 3/28/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//
//  KVOs GameState to update itself

#import "HUD.h"
#import "WeaponEntity.h"
#import "AppUtils.h"
#import "TextureUtils.h"
#import <objc/message.h>

#define HUD_TEXT_MARGIN 5

@interface HUD (Private)
    - (void) createAndSetupGameHUD;
    - (void) createAndSetupLevelCompleteUI;
    - (void) createAndSetupGameOverUI;

    - (void) nextLevelAction: (id) sender;
    - (void) tryAgainAction: (id) sender;
    - (void) mainMenuAction: (id) sender;
@end

@implementation HUD
@synthesize scoreLabel = scoreLabel_, weaponSpeedLabel = weaponSpeedLabel_, weaponDamageLabel = weaponDamageLabel_, rootNode = rootNode_, scoreText = scoreText_, weaponSpeedText = weaponSpeedText_, weaponDamageText = weaponDamageText_;
@synthesize levelCompleteSprite = levelCompleteSprite_,
    levelCompleteScoreLabel = levelCompleteScoreLabel_,
    levelCompleteScoreText = levelCompleteScoreText_,
    levelCompleteNextLevelButton = levelCompleteNextLevelButton_,
    levelCompleteMainMenuButton = levelCompleteMainMenuButton_,
    isLevelCompleteUIShowing = isLevelCompleteUIShwoing_;
@synthesize gameOverSprite = gameOverSprite_,
    gameOverLabel = gameOverLabel_,
    gameOverTryAgainButton = gameOverTryAgainButton_,
    gameOverMainMenuButton = gameOverMainMenuButton_,
    isGameOverUIShowing = isGameOverUIShowing_;
@synthesize actionNextLevel = actionNextLevel_,
    actionTryAgain = actionTryAgain_,
    actionMainMenu = actionMainMenu_;
@synthesize targetNextLevel = targetNextLevel_,
    targetTryAgain = targetTryAgain_,
    targetMainMenu = targetMainMenu_;

- (id) initWithNode: (SKNode *) node {
    if (self = [super init]) {
        self.rootNode = node;
        
        [self createAndSetupGameHUD];
        [self createAndSetupGameOverUI];
        [self createAndSetupLevelCompleteUI];
    }
    
    return self;
}

- (void) createAndSetupGameHUD {
    CGSize screenSize = [AppUtils getScreenSize];
    
    // Score
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    self.scoreLabel.text = @"Score: ";
    self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.scoreLabel.fontSize = 18;
    self.scoreLabel.fontColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha: 1.0];
    self.scoreLabel.position = CGPointMake(HUD_TEXT_MARGIN, screenSize.height - self.scoreLabel.frame.size.height - HUD_TEXT_MARGIN);
    self.scoreLabel.hidden = YES;
    [self.rootNode addChild: self.scoreLabel];
    
    self.scoreText = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    self.scoreText.text = @"0";
    self.scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.scoreText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.scoreText.fontSize = 18;
    self.scoreText.fontColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha: 1.0];
    self.scoreText.position = CGPointMake(self.scoreLabel.position.x + self.scoreLabel.frame.size.width + HUD_TEXT_MARGIN, self.scoreLabel.position.y);
    self.scoreText.hidden = YES;
    [self.rootNode addChild: self.scoreText];
    
    // Weapon Damage
    self.weaponDamageLabel = [SKLabelNode labelNodeWithFontNamed: @"Ariel"];
    self.weaponDamageLabel.text = @"Weapon Damage: ";
    self.weaponDamageLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.weaponDamageLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.weaponDamageLabel.fontSize = 18;
    self.weaponDamageLabel.fontColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha:1.0];
    self.weaponDamageLabel.position = CGPointMake(screenSize.width / 4, screenSize.height - self.weaponDamageLabel.frame.size.height - HUD_TEXT_MARGIN);
    self.weaponDamageLabel.hidden = YES;
    [self.rootNode addChild: self.weaponDamageLabel];
    
    self.weaponDamageText = [SKLabelNode labelNodeWithFontNamed: @"Ariel"];
    self.weaponDamageText.text = @"0";
    self.weaponDamageText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.weaponDamageText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.weaponDamageText.fontSize = 18;
    self.weaponDamageText.fontColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha:1.0];
    self.weaponDamageText.position = CGPointMake(self.weaponDamageLabel.position.x + self.weaponDamageLabel.frame.size.width + HUD_TEXT_MARGIN, self.weaponDamageLabel.position.y);
    self.weaponDamageText.hidden = YES;
    [self.rootNode addChild: self.weaponDamageText];
    
    // Weapon Speed
    self.weaponSpeedLabel = [SKLabelNode labelNodeWithFontNamed: @"Ariel"];
    self.weaponSpeedLabel.text = @"Weapon Speed: ";
    self.weaponSpeedLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.weaponSpeedLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.weaponSpeedLabel.fontSize = 18;
    self.weaponSpeedLabel.fontColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    self.weaponSpeedLabel.position = CGPointMake(screenSize.width * 2 / 3, self.weaponDamageText.position.y);
    self.weaponSpeedLabel.hidden = YES;
    [self.rootNode addChild: self.weaponSpeedLabel];
    
    self.weaponSpeedText = [SKLabelNode labelNodeWithFontNamed: @"Ariel"];
    self.weaponSpeedText.text = @"0";
    self.weaponSpeedText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.weaponSpeedText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.weaponSpeedText.fontSize = 18;
    self.weaponSpeedText.fontColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    self.weaponSpeedText.position = CGPointMake(self.weaponSpeedLabel.position.x + self.weaponSpeedLabel.frame.size.width + HUD_TEXT_MARGIN, self.weaponSpeedLabel.position.y);
    self.weaponSpeedText.hidden = YES;
    [self.rootNode addChild: self.weaponSpeedText];
}

- (void) createAndSetupLevelCompleteUI {
    CGSize screenSize = [AppUtils getScreenSize];
    CGFloat xMargin = screenSize.width * 0.5;
    CGFloat yMargin = screenSize.height * 0.25;
    
    NSMutableArray * vertices = [[NSMutableArray alloc] init];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(screenSize.width - xMargin, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(screenSize.width - xMargin, screenSize.height - yMargin)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, screenSize.height - yMargin)]];
    
    // TO DO: This will be a HUGE texture
    CGSize textureSize = [TextureUtils findTextureSizeFromVertexList: vertices];
    
    // NOTE: Coordinates are based off center of the sprite.
    // NOTE 2: for sprites, for height (-) is downwards, (+) is upward.
    self.levelCompleteSprite = [SKSpriteNode spriteNodeWithTexture: [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor purpleColor] fillColor: [SKColor colorWithRed: 128.0f/255.0f green: 82.0f/255.0f blue: 202.0f/255.0f alpha: 0.95f]]];
    self.levelCompleteSprite.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    self.levelCompleteSprite.zPosition = 4;
    
    NSInteger scoreLabelHeightPosition = 200;
    self.levelCompleteScoreLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    self.levelCompleteScoreLabel.text = @"Score: ";
    self.levelCompleteScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.levelCompleteScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.levelCompleteScoreLabel.fontSize = 38;
    self.levelCompleteScoreLabel.fontColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha: 1.0];
    self.levelCompleteScoreLabel.zPosition = 5;
    self.levelCompleteScoreLabel.position = CGPointMake(-self.levelCompleteScoreLabel.frame.size.width/2, scoreLabelHeightPosition);
    [self.levelCompleteSprite addChild: self.levelCompleteScoreLabel];

    self.levelCompleteScoreText = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    self.levelCompleteScoreText.text = @"0";
    self.levelCompleteScoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.levelCompleteScoreText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.levelCompleteScoreText.fontSize = 38;
    self.levelCompleteScoreText.fontColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha: 1.0];
    self.levelCompleteScoreText.zPosition = 5;
    self.levelCompleteScoreText.position = CGPointMake(self.levelCompleteScoreLabel.position.x + self.levelCompleteScoreLabel.frame.size.width + HUD_TEXT_MARGIN, self.levelCompleteScoreLabel.position.y);
    [self.levelCompleteSprite addChild: self.levelCompleteScoreText];

    NSInteger buttonWidth = 250, buttonHeight = 100;
    [vertices removeAllObjects];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(buttonWidth, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(buttonWidth, buttonHeight)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, buttonHeight)]];
    
    // TO DO: This will be a HUGE texture
    textureSize = [TextureUtils findTextureSizeFromVertexList: vertices];
    
    // NOTE: Coordinates are based off center of the sprite.
    SKTexture * buttonTexture = [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor blueColor] fillColor: [SKColor colorWithRed: 60.0f/255.0f green: 82.0f/255.0f blue: 120.0f/255.0f alpha: 0.95f]];
    SKTexture * buttonSelectedTexture = [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor blueColor] fillColor: [SKColor colorWithRed: 200.0f/255.0f green: 82.0f/255.0f blue: 50.0f/255.0f alpha: 0.95f]];
    
    NSInteger buttonHeightPosition = 150;
    self.levelCompleteNextLevelButton = [[KHSKButton alloc] initWithTextureNormal: buttonTexture selected: buttonSelectedTexture];
    [self.levelCompleteNextLevelButton.title setText:@"Next Level"];
    [self.levelCompleteNextLevelButton.title setFontName:@"Chalkduster"];
    [self.levelCompleteNextLevelButton.title setFontSize:32.0];
    [self.levelCompleteNextLevelButton setPosition: CGPointMake(0, self.levelCompleteScoreLabel.position.y - buttonHeightPosition)];
    self.levelCompleteNextLevelButton.zPosition = 5;
    [self.levelCompleteNextLevelButton setTouchDownTarget:self action:@selector(nextLevelAction:)];
    [self.levelCompleteSprite addChild: self.levelCompleteNextLevelButton];

    self.levelCompleteMainMenuButton = [[KHSKButton alloc] initWithTextureNormal: buttonTexture selected: buttonSelectedTexture];
    [self.levelCompleteMainMenuButton.title setText:@"Main Menu"];
    [self.levelCompleteMainMenuButton.title setFontName:@"Chalkduster"];
    [self.levelCompleteMainMenuButton.title setFontSize:32.0];
    [self.levelCompleteMainMenuButton setPosition: CGPointMake(0, self.levelCompleteNextLevelButton.position.y - self.levelCompleteMainMenuButton.frame.size.height)];
    self.levelCompleteMainMenuButton.zPosition = 5;
    [self.levelCompleteMainMenuButton setTouchDownTarget:self action:@selector(mainMenuAction:)];
    [self.levelCompleteSprite addChild: self.levelCompleteMainMenuButton];
    
    self.isLevelCompleteUIShowing = NO;
}

- (void) createAndSetupGameOverUI {
    CGSize screenSize = [AppUtils getScreenSize];
    CGFloat xMargin = screenSize.width * 0.5;
    CGFloat yMargin = screenSize.height * 0.25;
    
    NSMutableArray * vertices = [[NSMutableArray alloc] init];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(screenSize.width - xMargin, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(screenSize.width - xMargin, screenSize.height - yMargin)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, screenSize.height - yMargin)]];
    
    // TO DO: This will be a HUGE texture
    CGSize textureSize = [TextureUtils findTextureSizeFromVertexList: vertices];
    
    // NOTE: Coordinates are based off center of the sprite.
    // NOTE 2: for sprites, for height (-) is downwards, (+) is upward.
    self.gameOverSprite = [SKSpriteNode spriteNodeWithTexture: [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor purpleColor] fillColor: [SKColor colorWithRed: 128.0f/255.0f green: 82.0f/255.0f blue: 202.0f/255.0f alpha: 0.95f]]];
    self.gameOverSprite.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    self.gameOverSprite.zPosition = 4;
    
    NSInteger scoreLabelHeightPosition = 200;
    self.gameOverLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    self.gameOverLabel.text = @"Game Over";
    self.gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.gameOverLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.gameOverLabel.fontSize = 38;
    self.gameOverLabel.fontColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha: 1.0];
    self.gameOverLabel.zPosition = 5;
    self.gameOverLabel.position = CGPointMake(-self.gameOverLabel.frame.size.width/2, scoreLabelHeightPosition);
    [self.gameOverSprite addChild: self.gameOverLabel];
    
    NSInteger buttonWidth = 250, buttonHeight = 100;
    [vertices removeAllObjects];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(buttonWidth, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(buttonWidth, buttonHeight)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, buttonHeight)]];
    
    // TO DO: This will be a HUGE texture
    textureSize = [TextureUtils findTextureSizeFromVertexList: vertices];
    
    SKTexture * buttonTexture = [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor blueColor] fillColor: [SKColor colorWithRed: 60.0f/255.0f green: 82.0f/255.0f blue: 120.0f/255.0f alpha: 0.95f]];
    SKTexture * buttonSelectedTexture = [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor blueColor] fillColor: [SKColor colorWithRed: 200.0f/255.0f green: 82.0f/255.0f blue: 50.0f/255.0f alpha: 0.95f]];
    
    NSInteger buttonHeightPosition = 150;
    self.gameOverTryAgainButton = [[KHSKButton alloc] initWithTextureNormal: buttonTexture selected: buttonSelectedTexture];
    [self.gameOverTryAgainButton.title setText:@"Try Again"];
    [self.gameOverTryAgainButton.title setFontName:@"Chalkduster"];
    [self.gameOverTryAgainButton.title setFontSize:32.0];
    [self.gameOverTryAgainButton setPosition: CGPointMake(0, self.gameOverLabel.position.y - buttonHeightPosition)];
    self.gameOverTryAgainButton.zPosition = 5;
    [self.gameOverTryAgainButton setTouchDownTarget:self action:@selector(tryAgainAction:)];
    [self.gameOverSprite addChild: self.gameOverTryAgainButton];
    
    self.gameOverMainMenuButton = [[KHSKButton alloc] initWithTextureNormal: buttonTexture selected: buttonSelectedTexture];
    [self.gameOverMainMenuButton.title setText:@"Main Menu"];
    [self.gameOverMainMenuButton.title setFontName:@"Chalkduster"];
    [self.gameOverMainMenuButton.title setFontSize:32.0];
    [self.gameOverMainMenuButton setPosition: CGPointMake(0, self.gameOverTryAgainButton.position.y - self.gameOverMainMenuButton.frame.size.height)];
    self.gameOverMainMenuButton.zPosition = 5;
    [self.gameOverMainMenuButton setTouchDownTarget:self action:@selector(mainMenuAction:)];
    [self.gameOverSprite addChild: self.gameOverMainMenuButton];
    
    self.isGameOverUIShowing = NO;
}

- (void) nextLevelAction: (id) sender {
    NSLog(@"Next Level");
    objc_msgSend(self.targetNextLevel, self.actionNextLevel);
}

- (void) tryAgainAction: (id) sender {
    NSLog(@"Try Again");
    objc_msgSend(self.targetTryAgain, self.actionTryAgain);
}

- (void) mainMenuAction: (id) sender {
    NSLog(@"Main Menu");
    objc_msgSend(self.targetMainMenu, self.actionMainMenu);
}

- (void) setNextLevelTarget: (id)target selector: (SEL) selector {
    self->targetNextLevel_ = target;
    self->actionNextLevel_ = selector;
}

- (void) setTryAgainTarget: (id)target selector: (SEL) selector {
    self->targetTryAgain_ = target;
    self->actionTryAgain_ = selector;
}

- (void) setMainMenuTarget: (id)target selector: (SEL) selector {
    self->targetMainMenu_ = target;
    self->actionMainMenu_ = selector;
}

- (void) updateScoreLabelWithCurrentScore: (NSInteger) currentScore andGoalScore: (NSInteger) goalScore {
    self.scoreText.text =  [NSString stringWithFormat: @"%d/%d", currentScore, goalScore];
    [self updateUIPositions];
}

- (void) updateWeaponDamageLabelWithDamage: (CGFloat) damage {
    self.weaponDamageText.text = [NSString stringWithFormat: @"W Damage %f", damage];
    [self updateUIPositions];
}

- (void) updateWeaponSpeedLabelWithSpeed: (CGFloat) speed {
    self.weaponSpeedText.text = [NSString stringWithFormat: @"W Speed %f", speed];
    [self updateUIPositions];
}

- (void) updateUIPositions {
   // CGSize screenSize = [AppUtils getScreenSize];
    
   // TO DO: Dynamically reposition labels
}

- (void) shouldShowGameHUD: (BOOL) shouldShow withAnimation: (BOOL) animate {
    if (shouldShow) {
        self.scoreText.hidden = NO;
        self.scoreLabel.hidden = NO;
        
        self.weaponSpeedText.hidden = NO;
        self.weaponSpeedLabel.hidden = NO;
        
        self.weaponDamageText.hidden = NO;
        self.weaponDamageLabel.hidden = NO;
    } else {
        self.scoreText.hidden = YES;
        self.scoreLabel.hidden = YES;
        
        self.weaponSpeedText.hidden = YES;
        self.weaponSpeedLabel.hidden = YES;
        
        self.weaponDamageText.hidden = YES;
        self.weaponDamageLabel.hidden = YES;
    }
}

- (void) removeFromRootNode {
    [self.scoreLabel removeFromParent];
    [self.weaponSpeedLabel removeFromParent];
    [self.weaponDamageLabel removeFromParent];
    
    [self.scoreText removeFromParent];
    [self.weaponSpeedText removeFromParent];
    [self.weaponDamageText removeFromParent];
}

- (void) shouldShowLevelCompleteUI: (BOOL) shouldShow withAnimation: (BOOL) animate {
    if (shouldShow) {
        if (!self.isLevelCompleteUIShowing) {
            [self.levelCompleteSprite removeFromParent];
            [self.rootNode addChild: self.levelCompleteSprite];
            self.isLevelCompleteUIShowing = YES;
        }
    } else {
        [self.levelCompleteSprite removeFromParent];
        self.isLevelCompleteUIShowing = NO;
    }
}

- (void) shouldShowGameOverUI: (BOOL) shouldShow withAnimation: (BOOL) animate {
    if (shouldShow) {
        if (!self.isGameOverUIShowing) {
            [self.gameOverSprite removeFromParent];
            [self.rootNode addChild: self.gameOverSprite];
            self.isGameOverUIShowing = YES;
        }
    } else {
        [self.gameOverSprite removeFromParent];
        self.isGameOverUIShowing = NO;
    }
}
@end
