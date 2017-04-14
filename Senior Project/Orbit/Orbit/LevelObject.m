//
//  LevelObject.m
//  Orbit
//
//  Created by Ken Hung on 4/9/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "LevelObject.h"

@implementation LevelObject
@synthesize objectType, objectDimension;

- (id) initWithType: (LevelObjectType) type andDimension: (CGRect) dimension {
    if (self = [super init]) {
        self.objectType = type;
        self.objectDimension = dimension;
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt: self.objectType forKey: kLevelObjTypeKey];
    [aCoder encodeFloat: self.objectDimension.origin.x forKey: kRectOrigXKey];
    [aCoder encodeFloat: self.objectDimension.origin.y forKey: kRectOrigYKey];
    [aCoder encodeFloat: self.objectDimension.size.width forKey: kRectWidthKey];
    [aCoder encodeFloat: self.objectDimension.size.height forKey: kRectHeightKey];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    return [self initWithType: [aDecoder decodeIntForKey: kLevelObjTypeKey] 
                 andDimension: CGRectMake([aDecoder decodeFloatForKey:kRectOrigXKey], 
                                          [aDecoder decodeFloatForKey:kRectOrigYKey], 
                                          [aDecoder decodeFloatForKey:kRectWidthKey], 
                                          [aDecoder decodeFloatForKey:kRectHeightKey])];
}

// Debug
- (NSString * ) description {
    CGRect rect = self.objectDimension;
    
    return [NSString stringWithFormat: @"     %@ {%f, %f, %f, %f}", [self enumToStringWithType: self.objectType], rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

- (NSString *) enumToStringWithType: (LevelObjectType) type {
    switch (type) {
        case LEVEL_OBJECT_CIRCLE:
            return @"Circle";
            break;
        case LEVEL_OBJECT_RECT:
            return @"Rectangle";
            break;
        case LEVEL_OBJECT_POLY:
            return @"Polygon";
            break;
        default:
            break;
    }
    
    return @"????";
}
@end
