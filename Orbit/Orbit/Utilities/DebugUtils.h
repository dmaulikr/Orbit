//
//  DebugUtils.h
//  Orbit
//
//  Created by Ken Hung on 5/19/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugUtils : NSObject {
    
}

//
// Prints out bit representation of an interger.
//
+ (void) printNumderAsBits: (NSUInteger) number;
@end
