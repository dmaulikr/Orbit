//
//  ProceduralGenerator.m
//  Orbit
//
//  Created by Ken Hung on 5/11/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "ProceduralGenerator.h"

@implementation ProceduralGenerator
@synthesize wallSize, minimumHeight, minimumWidth;

- (id) init {
    if (self = [super init]) {
        self.minimumHeight = 10;
        self.minimumWidth = 10;
        self.wallSize = CGSizeMake(100, 100);
    }
    
    return self;
}

- (NSMutableArray *) generateWall {
    NSMutableArray * wallPoints = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < (arc4random() % 5 + 3); i++) {
        float x = (float)(arc4random() % (int)self.wallSize.width) + minimumWidth;
        float y = (float)(arc4random() % (int)self.wallSize.height) + minimumHeight;
        
        [wallPoints addObject: [NSValue valueWithCGPoint: CGPointMake(x, y)]];
    }
    
    return wallPoints;
}
@end
