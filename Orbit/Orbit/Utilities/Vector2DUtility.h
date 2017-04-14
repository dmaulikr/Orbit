//
//  Vector2DUtility.h
//  Orbit
//
//  Created by Ken Hung on 6/13/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector2DUtility : NSObject {
    
}

+ (CGFloat) GetAngleBetweenVector: (CGVector) vector1 vector: (CGVector) vector2;
+ (CGFloat) GetMagnitudeOfVector: (CGVector) vector;
+ (CGFloat) GetDotProductOfVector: (CGVector) vector1 withVector: (CGVector) vector2;
+ (CGVector) GetVectorFromPoint: (CGPoint) pt1 toPoint: (CGPoint) pt2;
+ (CGVector) NormalizeVector: (CGVector) vector;
+ (CGVector) RotateVector: (CGVector) vector angle: (CGFloat) angle;
@end
