//
//  WinScreenLayer.h
//  Orbit
//
//  Created by Ken Hung on 3/16/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface WinScreenLayer : CCLayer {
    
}

@property (nonatomic, assign) UIViewController * rootViewController;

// returns a CCScene that contains the MenuLayer as the only child
+ (CCScene *) scene;
+ (CCScene *) sceneWithRootRef: (UIViewController *) viewController;

- (void)onMenuItemTouched:(id)sender;
@end
