//
//  LevelObject.h
//  Orbit
//
//  Created by Ken Hung on 4/9/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelData.h"

@interface LevelObject : NSObject <NSCoding> {
                                   
}

@property (nonatomic, assign) LevelObjectType objectType;
@property (nonatomic, assign) CGRect objectDimension;

- (id) initWithType: (LevelObjectType) type andDimension: (CGRect) dimension;

- (NSString *) enumToStringWithType: (LevelObjectType) type;
@end
