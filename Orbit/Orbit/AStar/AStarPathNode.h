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
    
}

//The actual node this "path" node points to
@property (readwrite, assign) AStarNode *node;
//The previous node on our path
@property (readwrite, assign) AStarPathNode *previous;
//The cumulative cost of reaching this node
@property (readwrite, assign) float cost;

+(id) createWithAStarNode:(AStarNode*)node;
+(NSMutableArray*) findPathFrom:(AStarNode*)fromNode to:(AStarNode*)toNode;
+(AStarPathNode*)lowestCostNodeInArray:(NSMutableArray*)a;
+(bool) isPathNode:(AStarPathNode*)a inList:(NSArray*)list;

@end
