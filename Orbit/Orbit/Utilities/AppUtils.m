//
//  AppUtils.m
//  Orbit
//
//  Created by Ken Hung on 3/30/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "AppUtils.h"

@implementation AppUtils
+ (CGSize) getScreenSize {
    // Returns (width, height) in Portrait orientation.
    CGRect screenSize = [UIScreen mainScreen].bounds;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // Switch screen size depending on orientation
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGSizeMake(screenSize.size.width, screenSize.size.height);
    } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        return CGSizeMake(screenSize.size.height, screenSize.size.width);
    }
    
    return CGSizeMake(screenSize.size.width, screenSize.size.height);
}

+ (BOOL) isPointInEntity: (CGPoint) point entity: (Entity *) entity {
    SKSpriteNode * playerSprite = entity.sprite;
    
    if (point.x <= (playerSprite.position.x + playerSprite.size.width/2)
        && point.x >= (playerSprite.position.x - playerSprite.size.width/2)
        && point.y <= (playerSprite.position.y + playerSprite.size.height/2)
        && point.y >= (playerSprite.position.y - playerSprite.size.height/2)) {
        return YES;
    }
    
    return NO;
}
@end
