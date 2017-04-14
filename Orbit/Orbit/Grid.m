//
//  Grid.m
//  Orbit
//
//  Created by Ken Hung on 6/11/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "Grid.h"
//#import "AStarNode.h"

@interface Grid (Private)
    - (void) createGrid;
  //  - (void) addNeighbor: (AStarNode *) node toGridNodeX: (int) x Y: (int) y;
@end

@implementation Grid
@synthesize grid = grid_, xNodeCount = xNodeCount_, yNodeCount = yNodeCount_, gridAreaSize = gridAreaSize_, nodeSize = nodeSize_;
/*
- (void) createGrid {
    //Create 2D array (grid)
	self.xNodeCount = (int)(self.gridAreaSize.x / self.nodeSize);
	self.yNodeCount = (int)(self.gridAreaSize.y / self.nodeSize);
	self.grid = [[NSMutableArray alloc] init];
    
	for(int x = 0; x < self.xNodeCount; x++) {
		[self.grid addObject:[[NSMutableArray alloc] init]];
	}
    
	// Create Grid Nodes
	for (int x = 0; x < self.xNodeCount; x++) {
		for (int y = 0; y < self.yNodeCount; y++) {
			AStarNode * node = [[AStarNode alloc] init];
			node.position = CGPointMake(x * self.nodeSize, y * self.nodeSize);
			[[self.grid objectAtIndex:x] addObject: node];
		}
	}
    
	// Add neighbors
	for (int x = 0; x < self.xNodeCount; x++) {
		for (int y = 0; y < self.yNodeCount; y++) {
			AStarNode * node = [[self.grid objectAtIndex: x] objectAtIndex: y];
            
			// Add self as neighbor to neighboring nodes
			[self addNeighbor: node toGridNodeX: x - 1 Y: y - 1]; // Top-Left
			[self addNeighbor: node toGridNodeX: x - 1 Y: y];     // Left
			[self addNeighbor: node toGridNodeX: x - 1 Y: y + 1]; // Bottom-Left
			[self addNeighbor: node toGridNodeX: x Y: y - 1];     // Top
		 	
			[self addNeighbor: node toGridNodeX: x Y: y + 1];     // Bottom
			[self addNeighbor: node toGridNodeX: x + 1 Y: y - 1]; // Top-Right
			[self addNeighbor: node toGridNodeX: x + 1 Y: y];     // Right
			[self addNeighbor: node toGridNodeX: x + 1 Y: y + 1]; // Bottom-Right
		}
	}
}

- (void) addNeighbor: (AStarNode *) node toGridNodeX: (int) x Y: (int) y {
	if (x >= 0 && y >= 0 && x < self.xNodeCount && y < self.yNodeCount) {
		AStarNode * neighbor = [[self.grid objectAtIndex: x] objectAtIndex: y];
		if (![AStarNode isNode: neighbor inList: node.neighbors]) {
			[node.neighbors addObject: neighbor];
		}
	}
}*/
@end
