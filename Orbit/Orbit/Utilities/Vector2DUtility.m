//
//  Vector2DUtility.m
//  Orbit
//
//  Created by Ken Hung on 6/13/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "Vector2DUtility.h"

@implementation Vector2DUtility
+ (CGFloat) GetAngleBetweenVector: (CGVector) vector1 vector: (CGVector) vector2 {
    return acosf([Vector2DUtility GetDotProductOfVector: vector1 withVector: vector2] / ([Vector2DUtility GetMagnitudeOfVector: vector1] * [Vector2DUtility GetMagnitudeOfVector: vector2]));
}

+ (CGFloat) GetMagnitudeOfVector: (CGVector) vector {
    return sqrt(vector.dx * vector.dx + vector.dy * vector.dy);
}

+ (CGFloat) GetDotProductOfVector: (CGVector) vector1 withVector: (CGVector) vector2 {
    return vector1.dx * vector2.dx + vector1.dy * vector2.dy;
}

+ (CGVector) GetVectorFromPoint: (CGPoint) pt1 toPoint: (CGPoint) pt2 {
    return CGVectorMake(pt2.x - pt1.x, pt2.y - pt1.y);
}

+ (CGVector) NormalizeVector: (CGVector) vector {
    CGFloat magnitude = [Vector2DUtility GetMagnitudeOfVector: vector];
    return CGVectorMake(vector.dx / magnitude, vector.dy / magnitude);
}

+ (CGVector) RotateVector: (CGVector) vector angle: (CGFloat) angle {
    CGFloat r_angle = angle * M_PI / 180;
    
    return CGVectorMake(vector.dx * cos(r_angle) - vector.dy * sin(r_angle),
                        vector.dx * sin(r_angle) + vector.dy * cos(r_angle));
}
@end
