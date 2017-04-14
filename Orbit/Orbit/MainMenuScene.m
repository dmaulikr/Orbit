//
//  MainMenuScene.m
//  Orbit
//
//  Created by Ken Hung on 3/25/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameScene.h"
#import "AppUtils.h"
#import "StoreScene.h"

@interface MainMenuScene (Private)
    - (void) startButtonAction;
@end

@implementation MainMenuScene
@synthesize menuActivateButton = menuActivateButton_, titleLabel = titleLabel_,
    playActionButton = playActionButton_,
    playButtonRadius = playButtonRadius_,
    playButtonRotation = playButtonRotation_,
    playButtonCenter = playButtonCenter_,
    playButtonSpeed = playButtonSpeed_,
    tutorialActionButton = tutorialActionButton_,
    tutorialButtonRadius = tutorialButtonRadius_,
    tutorialButtonRotation = tutorialButtonRotation_,
    tutorialButtonCenter = tutorialButtonCenter_,
    tutorialButtonSpeed = tutorialButtonSpeed_,
    aboutActionButton = aboutActionButton_,
    aboutButtonRadius = aboutButtonRadius_,
    aboutButtonRotation = aboutButtonRotation_,
    aboutButtonCenter = aboutButtonCenter_,
    aboutButtonSpeed = aboutButtonSpeed_,
    editorActionButton = editorActionButton_,
    editorButtonRadius = editorActionRadius_,
    editorButtonRotation = editorButtonRotation_,
    editorButtonCenter = editorButtonCenter_,
    editorButtonSpeed = editorButtonSpeed_;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        CGSize screenSize = [AppUtils getScreenSize];
        
        self.titleLabel = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
        self.titleLabel.text = @"Orbit";
        self.titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        self.titleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.titleLabel.fontSize = 128;
        self.titleLabel.fontColor = [UIColor colorWithRed: 255 green: 255 blue: 255 alpha: 0.85];
        self.titleLabel.position = CGPointMake(screenSize.width / 2, screenSize.height * 4 / 5);
        [self addChild: self.titleLabel];
        
        self.menuActivateButton = [[KHSKButton alloc] initWithImageNamedNormal:@"ph_circle" selected:@"ph_circle_hp_bar"];
        [self.menuActivateButton setPosition:CGPointMake((screenSize.width / 2), (screenSize.height / 2))];
        [self.menuActivateButton.title setText:@""];
        [self.menuActivateButton.title setFontName:@"Chalkduster"];
        [self.menuActivateButton.title setFontSize:20.0];
        [self.menuActivateButton setTouchDownTarget:self action:@selector(menuActivateButtonAction)];
        [self addChild: self.menuActivateButton];
        
        self.playButtonRadius = 150;
        self.playActionButton = [[KHSKButton alloc] initWithImageNamedNormal:@"ph_square" selected:@"ph_square_hp_bar"];
        self.playButtonCenter = self.menuActivateButton.position;
        [self.playActionButton setPosition: CGPointMake((screenSize.width / 2) - self.playButtonRadius, (screenSize.height / 2) + self.playButtonRadius)];
        [self.playActionButton.title setText:@"Play"];
        [self.playActionButton.title setFontName:@"Chalkduster"];
        [self.playActionButton.title setFontSize:20.0];
        [self.playActionButton setTouchDownTarget:self action:@selector(playButtonAction)];
        self.playActionButton.hidden = YES;
        self.playButtonSpeed = 0.3;
        self.playButtonRotation = 105;
        [self addChild: self.playActionButton];
        
        self.tutorialButtonRadius = 150;
        self.tutorialActionButton = [[KHSKButton alloc] initWithImageNamedNormal:@"ph_square" selected:@"ph_square_hp_bar"];
        self.tutorialButtonCenter = self.menuActivateButton.position;
        [self.tutorialActionButton setPosition: CGPointMake((screenSize.width / 2) + self.tutorialButtonRadius, (screenSize.height / 2) - self.tutorialButtonRadius)];
        [self.tutorialActionButton.title setText:@"Tutorial"];
        [self.tutorialActionButton.title setFontName:@"Chalkduster"];
        [self.tutorialActionButton.title setFontSize:20.0];
        [self.tutorialActionButton setTouchDownTarget:self action:@selector(tutorialButtonAction)];
        self.tutorialActionButton.hidden = YES;
        self.tutorialButtonSpeed = 0.3;
        self.tutorialButtonRotation = 70;
        [self addChild: self.tutorialActionButton];
        
        self.editorButtonRadius = 150;
        self.editorActionButton = [[KHSKButton alloc] initWithImageNamedNormal:@"ph_square" selected:@"ph_square_hp_bar"];
        self.editorButtonCenter = self.menuActivateButton.position;
        [self.editorActionButton setPosition: CGPointMake((screenSize.width / 2) + self.editorButtonRadius, (screenSize.height / 2) + self.editorButtonRadius)];
        [self.editorActionButton.title setText:@"Editor"];
        [self.editorActionButton.title setFontName:@"Chalkduster"];
        [self.editorActionButton.title setFontSize:20.0];
        [self.editorActionButton setTouchDownTarget:self action:@selector(editorButtonAction)];
        self.editorActionButton.hidden = YES;
        self.editorButtonSpeed = 0.3;
        self.editorButtonRotation = 35;
        [self addChild: self.editorActionButton];
        
        self.aboutButtonRadius = 150;
        self.aboutActionButton = [[KHSKButton alloc] initWithImageNamedNormal:@"ph_square" selected:@"ph_square_hp_bar"];
        self.aboutButtonCenter = self.menuActivateButton.position;
        [self.aboutActionButton setPosition: CGPointMake((screenSize.width / 2) - self.aboutButtonRadius, (screenSize.height / 2) - self.aboutButtonRadius)];
        [self.aboutActionButton.title setText:@"About"];
        [self.aboutActionButton.title setFontName:@"Chalkduster"];
        [self.aboutActionButton.title setFontSize:20.0];
        [self.aboutActionButton setTouchDownTarget:self action:@selector(aboutButtonAction)];
        self.aboutActionButton.hidden = YES;
        self.aboutButtonSpeed = 0.3;
        self.aboutButtonRotation = 0;
        [self addChild: self.aboutActionButton];
    }
    
    return self;
}

- (void) clearObjects {
    [self.titleLabel removeFromParent];
    [self.menuActivateButton removeFromParent];
    [self.playActionButton removeFromParent];
    [self.tutorialActionButton removeFromParent];
    [self.aboutActionButton removeFromParent];
    [self.editorActionButton removeFromParent];
}

#pragma mark - Override Accessor Methods
- (void) setAboutButtonRotation:(CGFloat)aboutButtonRotation {
    self->aboutButtonRotation_ = aboutButtonRotation;
    
    if (aboutButtonRotation >= 360.0) {
        self->aboutButtonRotation_ -= 360.0;
    }
}

- (void) setTutorialButtonRotation:(CGFloat)tutorialButtonRotation {
    self->tutorialButtonRotation_ = tutorialButtonRotation;
    
    if (tutorialButtonRotation >= 360.0) {
        self->tutorialButtonRotation_ -= 360.0;
    }
}

- (void) setPlayButtonRotation:(CGFloat)playButtonRotation {
    self->playButtonRotation_ = playButtonRotation;
    
    if (playButtonRotation >= 360.0) {
        self->playButtonRotation_ -= 360.0;
    }
}

- (void) setEditorButtonRotation:(CGFloat)editorButtonRotation {
    self->editorButtonRotation_ = editorButtonRotation;
    
    if (editorButtonRotation >= 360.0) {
        self->editorButtonRotation_ -= 360.0;
    }
}

- (void) menuActivateButtonAction {
    [self showMenuItemsAnimated: YES];
}

- (void) playButtonAction {
#if DEBUG
    NSLog(@"Play Button Pressed.");
#endif
    
    [self clearObjects];
    
    UIView * sceneView = self.scene.view;
    
    // Create and configure the scene.
    SKScene * scene = [GameScene sceneWithSize: sceneView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.scene.view presentScene: scene];
}

- (void) tutorialButtonAction {
#if DEBUG
    NSLog(@"Tutorial Button Pressed.");
#endif
    
    UIView * sceneView = self.scene.view;
    
    // Create and configure the scene.
    SKScene * scene = [StoreScene sceneWithSize: sceneView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.scene.view presentScene: scene];
}

- (void) aboutButtonAction {
#if DEBUG
    NSLog(@"About Button Pressed.");
#endif
}

- (void) editorButtonAction {
#if DEBUG
    NSLog(@"Editor Button Pressed.");
#endif
}

- (void) showMenuItemsAnimated: (BOOL) animated {
 //   if (animated) {
        
 //   } else {
        self.playActionButton.hidden = NO;
        self.tutorialActionButton.hidden = NO;
        self.aboutActionButton.hidden = NO;
        self.editorActionButton.hidden = NO;
//    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    self.playButtonRotation += self.playButtonSpeed;
    self.aboutButtonRotation += self.aboutButtonSpeed;
    self.tutorialButtonRotation += self.tutorialButtonSpeed;
    self.editorButtonRotation += self.editorButtonSpeed;
    
    CGPoint p = [self test: self.playButtonRotation radius: self.playButtonRadius];
    [self.playActionButton setPosition: CGPointMake(self.playButtonCenter.x + p.x, self.playButtonCenter.y + p.y)];
    p = [self test: self.aboutButtonRotation radius: self.aboutButtonRadius];
    [self.aboutActionButton setPosition: CGPointMake(self.aboutButtonCenter.x + p.x, self.aboutButtonCenter.y + p.y)];
    p = [self test: self.tutorialButtonRotation radius: self.tutorialButtonRadius];
    [self.tutorialActionButton setPosition: CGPointMake(self.tutorialButtonCenter.x + p.x, self.tutorialButtonCenter.y + p.y)];
    p = [self test: self.editorButtonRotation radius: self.editorButtonRadius];
    [self.editorActionButton setPosition: CGPointMake(self.editorButtonCenter.x + p.x, self.editorButtonCenter.y + p.y)];
}

- (CGPoint) test: (float) angle radius: (float) radius {
    float rotInRad = (M_PI/180) * angle;
    
    CGFloat x = cos(rotInRad);
    CGFloat y = sin(rotInRad);
    
    x *= radius;
    y *= radius;
    
    return CGPointMake(x, y);
}
@end
