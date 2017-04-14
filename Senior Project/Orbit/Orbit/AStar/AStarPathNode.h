//
//  AStarPathNode.h
//  Orbit
//
//  Created by Ken Hung on 2/16/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameHelper.h"
#import "AStarNode.h"

@interface AStarPathNode : NSObject
{
	AStarNode *node;	//The actual node this "path" node points to
	AStarPathNode *previous;	//The previous node on our path
	float cost;	//The cumulative cost of reaching this node
}

@property (readwrite, assign) AStarNode *node;
@property (readwrite, assign) AStarPathNode *previous;
@property (readwrite, assign) float cost;

+(id) createWithAStarNode:(AStarNode*)node;
+(NSMutableArray*) findPathFrom:(AStarNode*)fromNode to:(AStarNode*)toNode;
+(AStarPathNode*)lowestCostNodeInArray:(NSMutableArray*)a;
+(bool) isPathNode:(AStarPathNode*)a inList:(NSArray*)list;

@end
