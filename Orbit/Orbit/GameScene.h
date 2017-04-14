//
//  GameScene.h
//  Orbit
//
//  Created by Ken Hung on 3/25/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameManager.h"
#import "KHSKButton.h"

@interface GameScene : SKScene {
    BOOL isMoving;
}

@property (nonatomic, retain) GameManager * gameManager;
@property (nonatomic, retain) KHSKButton * menuButton;
@end
