//
//  DebugUtils.m
//  Orbit
//
//  Created by Ken Hung on 5/19/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "DebugUtils.h"

@implementation DebugUtils
+ (void) printNumderAsBits: (NSUInteger) number {
#ifdef DEBUG
    NSMutableString *str = [NSMutableString string];
    NSInteger numberCopy = number; // so you won't change your original value
    
    for (NSInteger i = 0; i < 8 ; i++) {
        // Prepend "0" or "1", depending on the bit
        [str insertString:((numberCopy & 1) ? @"1" : @"0") atIndex:0];
        numberCopy >>= 1;
    }
    
    NSLog(@"Binary version: %@", str);
#endif
}
@end
