//
//  CircleEntity.h
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface CircleEntity : Entity {
    CGFloat rotation;
    CGPoint centerPoint;
    CGFloat radius;
}

@end
