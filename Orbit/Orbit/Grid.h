//
//  Grid.h
//  Orbit
//
//  Created by Ken Hung on 6/11/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grid : NSObject {
    
}

@property (nonatomic, retain) NSMutableArray * grid;
@property (nonatomic, assign) NSInteger xNodeCount, yNodeCount;
@property (nonatomic, assign) CGPoint gridAreaSize;
// The space between each node, increase this to increase A* efficiency at the cost of accuracy.
@property (nonatomic, assign) CGFloat nodeSize;

@end
