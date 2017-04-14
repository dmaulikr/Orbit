//
//  MainMenuScene.h
//  Orbit
//
//  Created by Ken Hung on 3/25/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//
// This is the scene that is the main menu to navigate app. contents.
//

#import <SpriteKit/SpriteKit.h>
#import "KHSKButton.h"

@interface MainMenuScene : SKScene {
    
}

@property (nonatomic, retain) SKLabelNode * titleLabel;
@property (nonatomic, retain) KHSKButton * menuActivateButton, * playActionButton, * tutorialActionButton, * aboutActionButton, * editorActionButton;
@property (nonatomic, assign) CGFloat playButtonRadius, tutorialButtonRadius, aboutButtonRadius, editorButtonRadius;
@property (nonatomic, assign) CGFloat playButtonRotation, tutorialButtonRotation, aboutButtonRotation, editorButtonRotation;
@property (nonatomic, assign) CGPoint playButtonCenter, tutorialButtonCenter, aboutButtonCenter, editorButtonCenter;
@property (nonatomic, assign) CGFloat playButtonSpeed, tutorialButtonSpeed, aboutButtonSpeed, editorButtonSpeed;

- (void) clearObjects;
@end
