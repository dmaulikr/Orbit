//
//  AStarNode.m
//  Orbit
//
//  Created by Ken Hung on 2/16/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "AStarNode.h"

@implementation AStarNode

@synthesize position, neighbors, active, costMultiplier;

-(id) init {
    if( (self=[super init]) ) {
		active = YES;
		neighbors = [[NSMutableArray alloc] init];
		costMultiplier = 1.0f;
    }
    return self;
}

/* Cost to node heuristic */
-(float) costToNode:(AStarNode*)node {
	CGPoint src = CGPointMake(self.position.x, self.position.y);
	CGPoint dst = CGPointMake(node.position.x, node.position.y);
	float cost = [GameHelper distanceP1:src toP2:dst] * node.costMultiplier;
	return cost;
}

/* Helper method: Is a node in a given list? */
+(bool) isNode:(AStarNode*)a inList:(NSArray*)list {
	for(int i=0; i<list.count; i++){
		AStarNode *b = [list objectAtIndex:i];
		if(a.position.x == b.position.x && a.position.y == b.position.y){
			return YES;
		}
	}
	return NO;
}

@end
