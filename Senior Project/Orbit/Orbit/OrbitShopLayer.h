//
//  OrbitShopLayer.h
//  Orbit
//
//  Created by Ken Hung on 9/5/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface OrbitShopLayer : CCLayer {
    
}

@property (nonatomic, assign) UIViewController * rootViewController;

+ (CCScene*) scene;
+ (CCScene *) sceneWithRootRef: (UIViewController *) viewController;
@end
