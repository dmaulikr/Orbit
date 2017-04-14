//
//  MenuLayer.h
//  Orbit
//
//  Created by Ken Hung on 1/12/12.
//  Copyright 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelEditorProtocols.h"

@interface MenuLayer : CCLayer <LevelPickProtocol, NewLevelFileProtocol> {
    
}

@property (nonatomic, assign) UIViewController * rootViewController;

// returns a CCScene that contains the MenuLayer as the only child
+ (CCScene *) scene;
+ (CCScene *) sceneWithRootRef: (UIViewController *) viewController;

- (void)onMenuItemTouched:(id)sender;
@end
