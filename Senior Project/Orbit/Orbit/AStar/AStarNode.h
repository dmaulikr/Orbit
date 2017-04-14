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
	CGPoint position;	//The node's position on our map
	NSMutableArray *neighbors;	//An array of neighbor AStarNode objects
	bool active;	//Is this node active?
	float costMultiplier;	//Use this to multiply the normal cost to reach this node.
}

@property (readwrite, assign) CGPoint position;
@property (readwrite, assign) NSMutableArray *neighbors;
@property (readwrite, assign) bool active;
@property (readwrite, assign) float costMultiplier;

-(float) costToNode:(AStarNode*)node;
+(bool) isNode:(AStarNode*)a inList:(NSArray*)list;

@end
