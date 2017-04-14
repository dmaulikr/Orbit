//
//  SmartEntity.h
//  Orbit
//
//  Created by Ken Hung on 6/13/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "Entity.h"
#import "MPNode.h"
#import "PlayerEntity.h"

@interface SmartEntity : Entity {
    CGFloat moved;
    CGFloat lastUpdateTime;
}

// Goal Point
@property (nonatomic, assign) CGPoint targetPoint;
// Last point this Entity moved to.
@property (nonatomic, retain) MPNode * lastNode;
// Current point this Entity is moving to.
@property (nonatomic, retain) MPNode * currentNode;
@property (nonatomic, assign) CGFloat moveIncrement, moveDistance;
@property (nonatomic, retain) NSArray * nodeList;
@property (nonatomic, assign) PlayerEntity * playerEntity;
@property (nonatomic, retain) SKShapeNode * debugNode, * d1, * d2, * d3, * d4, *d5;
@end
