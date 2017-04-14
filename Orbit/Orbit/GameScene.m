//
//  GameScene.m
//  Orbit
//
//  Created by Ken Hung on 3/25/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//
// This is the actual scene where you play the game.
//

#import "GameScene.h"
#import "AppUtils.h"
#import "KHSKButton.h"
#import "MainMenuScene.h"

@implementation GameScene
@synthesize gameManager = gameManager_, menuButton = menuButton_;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        /*
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
         
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
        CGRectGetMidY(self.frame));
         
        [self addChild:myLabel];
         */
        
        self.gameManager = [[GameManager alloc] initWithLevel: nil scene: self];
        self.physicsWorld.contactDelegate = self.gameManager;
        [self.gameManager beginLevel];
        
        self.menuButton = [[KHSKButton alloc] initWithImageNamedNormal:@"ph_square" selected:@"ph_square_hp_bar"];
        [self.menuButton  setPosition:CGPointMake(100, 500)];
        [self.menuButton .title setText:@"Main Menu"];
        [self.menuButton .title setFontName:@"Chalkduster"];
        [self.menuButton .title setFontSize:20.0];
        [self.menuButton setTouchUpInsideTarget:self action:@selector(startButtonAction)];
        [self addChild: self.menuButton];
    }
    return self;
}

- (void) startButtonAction {
    NSLog(@"button was pressed!!");
    
    // Clear GameManager object
    [self.gameManager clearObject];
    
    UIView * sceneView = self.scene.view;
    
    // Create and configure the scene.
    SKScene * scene = [MainMenuScene sceneWithSize: sceneView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.scene.view presentScene: scene];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    self.menuButton.hidden = YES;
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];

        // If touch down is within the player
        if ([self.gameManager isPointInPlayerEntity: location]) {
            self->isMoving = YES;
            
            // [[CCDirector sharedDirector] resume];
            [self.gameManager setPlayerEntityWeaponActive: YES];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (isMoving) {
            [self.gameManager setPlayerEntityPosition: location];
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isMoving = NO;
    [self.gameManager setPlayerEntityWeaponActive: NO];
    self.menuButton.hidden = NO;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    isMoving = NO;
    [self.gameManager setPlayerEntityWeaponActive: NO];
    self.menuButton.hidden = NO;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    // TO DO: Fix: Sometime Animation will occur but no spawn if touch up before animation finishes.
    [self.gameManager update: currentTime];
}
@end
