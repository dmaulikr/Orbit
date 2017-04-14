//
//  AppDelegate.h
//  Orbit
//
//  Created by Ken Hung on 8/20/11.
//  Copyright Cal Poly - SLO 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
