//
//  AStarNode.h
//  Orbit
//
//  Created by Ken Hung on 2/16/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameHelper.h"

@interface AStarNode : NSObject
{

}

//The node's position on our map
@property (readwrite, assign) CGPoint position;
//An array of neighbor AStarNode objects
@property (readwrite, retain) NSMutableArray *neighbors;
//Is this node active?
@property (readwrite, assign) bool active;
//Use this to multiply the normal cost to reach this node.
@property (readwrite, assign) float costMultiplier;

-(float) costToNode:(AStarNode*)node;
+(bool) isNode:(AStarNode*)a inList:(NSArray*)list;

@end
