//
//  AppUtils.h
//  Orbit
//
//  Created by Ken Hung on 3/30/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface AppUtils : NSObject {
    
}

+ (CGSize) getScreenSize;
+ (BOOL) isPointInEntity: (CGPoint) point entity: (Entity *) entity;
@end
