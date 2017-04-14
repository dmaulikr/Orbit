//
//  StoreScene.h
//  Orbit
//
//  Created by Ken Hung on 7/7/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "PlayerEntity.h"

@interface StoreScene : SKScene {
    CGFloat buttonWidth, buttonHeight;
    BOOL isMoving;
}

@property (nonatomic, retain) PlayerEntity * playerEntity;
@property (nonatomic, assign) SKView * parentView;
@property (nonatomic, retain) NSMutableArray * buttonList, * tabList;

- (void) buttonSelectAction: (id) sender;
- (void) tabSelectAction: (id) sender;
@end
