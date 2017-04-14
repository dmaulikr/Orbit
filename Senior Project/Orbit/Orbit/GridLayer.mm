//
//  GridLayer.m
//  Orbit
//
//  Created by Ken Hung on 2/12/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "GridLayer.h"
#import "AStarNode.h"
#import "AStarPathNode.h"
#import "Utils.h"
#import "RayCast.h"
#import "ObjectEntity.h"

@interface GridLayer ()
    - (void) setupGrid;
    - (void) addNeighbor: (AStarNode *) node toGridNodeX: (int) x Y: (int) y;
@end

@implementation GridLayer
@synthesize grid, gameAreaSize, nodeSpace, gridSizeX, gridSizeY, numberOfScreens, originalPosition, positionOffset;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GridLayer *layer = [GridLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if (self = [self initWithScreenWidths: 1]) {

    }
    
    return self;
}

- (id) initWithScreenWidths: (NSInteger) numberOfScreenWidths {
    if (self = [super init]) {
        self.isTouchEnabled = YES;
        self.position = ccp(0, 0);
        
        CGRect screenSize = [[UIScreen mainScreen] bounds];
        
        if (numberOfScreenWidths > 0) {
            //Set game area size (height and width flip for always in horizontal )
            gameAreaSize = ccp(screenSize.size.height * numberOfScreenWidths / PTM_RATIO, screenSize.size.width / PTM_RATIO);	//Box2d units
        } else {
            //Set game area size (height and width flip for always in horizontal )
            gameAreaSize = ccp(screenSize.size.height / PTM_RATIO, screenSize.size.width / PTM_RATIO);	//Box2d units
        }
        
     	//Initial variables
        nodeSpace = 64.0f;//32.0f;
        
        self.numberOfScreens = numberOfScreenWidths;
        
        positionOffset = 0;
        originalPosition = CGPointMake(-1, -1);
        
        [self setupGrid];
    }

    return self;
}

- (void) setupGrid {
    //Create 2D array (grid)
	gridSizeX = (int)(gameAreaSize.x*PTM_RATIO/nodeSpace);
	gridSizeY = (int)(gameAreaSize.y*PTM_RATIO/nodeSpace);
	grid = [[NSMutableArray alloc] initWithCapacity:(gridSizeX)];
	for(int x=0; x<gridSizeX; x++){
		[grid addObject:[[NSMutableArray alloc] initWithCapacity:(gridSizeY)]];
	}	
    
	//Create AStar nodes
	for(int x=0; x<gridSizeX; x++){
		for(int y=0; y<gridSizeY; y++){
			//Add a node
			AStarNode *node = [[AStarNode alloc] init];
			node.position = ccp(x*nodeSpace + nodeSpace/2, y*nodeSpace + nodeSpace/2);
			[[grid objectAtIndex:x] addObject:node];
		}
	}
    
	//Add neighbors
	for(int x=0; x<gridSizeX; x++){
		for(int y=0; y<gridSizeY; y++){
			//Add a node
			AStarNode *node = [[grid objectAtIndex:x] objectAtIndex:y];
            
			//Add self as neighbor to neighboring nodes
			[self addNeighbor:node toGridNodeX:x-1 Y:y-1]; //Top-Left
			[self addNeighbor:node toGridNodeX:x-1 Y:y]; //Left
			[self addNeighbor:node toGridNodeX:x-1 Y:y+1]; //Bottom-Left
			[self addNeighbor:node toGridNodeX:x Y:y-1]; //Top
			
			[self addNeighbor:node toGridNodeX:x Y:y+1]; //Bottom
			[self addNeighbor:node toGridNodeX:x+1 Y:y-1]; //Top-Right
			[self addNeighbor:node toGridNodeX:x+1 Y:y]; //Right
			[self addNeighbor:node toGridNodeX:x+1 Y:y+1]; //Bottom-Right
		}
	}
}

- (void) cullGridWithWorld: (b2World *) world {
    float actorRadius = nodeSpace/PTM_RATIO/3; // TODO: replace with actual sprite radius
    
    //Remove neighbors from positive TestPoint and RayCast tests	
	for(int x=0; x<gridSizeX; x++){
		for(int y=0; y<gridSizeY; y++){
			//Add a node
			AStarNode *node = [[grid objectAtIndex:x] objectAtIndex:y];
			
			//If a node itself is colliding with an object we cut off all connections
			for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()){
				if (b->GetUserData() != NULL) {
					ObjectEntity *obj = (ObjectEntity*)b->GetUserData();
					if(obj.polygonShape){
						b2Vec2 nodePosition = b2Vec2(node.position.x/PTM_RATIO, node.position.y/PTM_RATIO);
						
						//Test this node point against this polygon
						if(obj.polygonShape->TestPoint(b->GetTransform(), nodePosition)){
                            // BUG FIX: Not all edges were being culled
							for(int i=0; i<node.neighbors.count; i++){
								//Remove connections
								AStarNode *neighbor = [node.neighbors objectAtIndex:i];
							//	[node.neighbors removeObject:neighbor];
								[neighbor.neighbors removeObject:node];
							}
                            
                            [node.neighbors removeAllObjects];
						}
					}
				}	
			}	

			//Test all node to neighbor connections using a RayCast test
			for(int i=0; i<node.neighbors.count; i++){
				AStarNode *neighbor = [node.neighbors objectAtIndex:i];
				
				//Do a RayCast from the node to the neighbor.
				//If there is something in the way, remove the link
				b2Vec2 nodeP = b2Vec2(node.position.x/PTM_RATIO, node.position.y/PTM_RATIO);
				b2Vec2 neighborP = b2Vec2(neighbor.position.x/PTM_RATIO, neighbor.position.y/PTM_RATIO);
				
				//Do 4 tests (based on actor size)
				for(float x = -actorRadius; x <= actorRadius; x+= actorRadius*2){
					for(float y = -actorRadius; y <= actorRadius; y+= actorRadius*2){
						RayCastAnyCallback callback;
						world->RayCast(&callback, b2Vec2(nodeP.x+x,nodeP.y+y), b2Vec2(neighborP.x+x,neighborP.y+y));
                        
						if(callback.m_hit){
							//Remove connections
							[node.neighbors removeObject:neighbor];
							[neighbor.neighbors removeObject:node];
						//	break; break;
						}
					}
				}
                
                for(float y = -actorRadius; y <= actorRadius; y+= actorRadius*2){
                    RayCastAnyCallback callback;
                    world->RayCast(&callback, b2Vec2(nodeP.x,nodeP.y+y), b2Vec2(neighborP.x,neighborP.y+y));
                    
                    if(callback.m_hit){
                        //Remove connections
                        [node.neighbors removeObject:neighbor];
                        [neighbor.neighbors removeObject:node];
						//	break; break;
                    }
                }
                
                for(float x = -actorRadius; x <= actorRadius; x+= actorRadius*2){
                    RayCastAnyCallback callback;
                    world->RayCast(&callback, b2Vec2(nodeP.x+x,nodeP.y), b2Vec2(neighborP.x+x,neighborP.y));
                    
                    if(callback.m_hit){
                        //Remove connections
                        [node.neighbors removeObject:neighbor];
                        [neighbor.neighbors removeObject:node];
                        //	break; break;
                    }
				}
			}
		}
	}
}

/* Add neighbor helper method */
-(void) addNeighbor: (AStarNode*) node toGridNodeX: (int) x Y: (int) y {
	if(x >= 0 && y >= 0 && x < gridSizeX && y < gridSizeY){
		AStarNode *neighbor = [[grid objectAtIndex:x] objectAtIndex:y];
		if(![AStarNode isNode:neighbor inList:node.neighbors]){
			[node.neighbors addObject:neighbor];
		}
	}
}

- (void) draw {
#ifdef ORBIT_DEBUG_ON
    // Only draw the AStarNodes and connections in the simulator (too slow for the device)
	NSString *model = [[UIDevice currentDevice] model];
    
	//if([model isEqualToString: @"iPhone Simulator"] || [model isEqualToString: @"iPad Simulator"]){
		// Draw AStarNodes
		glColor4ub(36, 36, 36, 8);
        
		for(int x = 0; x < gridSizeX; x++){
			for(int y = 0; y < gridSizeY; y++){
				// Draw node
				AStarNode * node = [[grid objectAtIndex: x] objectAtIndex: y];
				ccDrawPoint(node.position);
				
				// Draw neighbor lines (there is going to be a lot of them)
				for(int i = 0; i < node.neighbors.count; i++){
					AStarNode * neighbor = [node.neighbors objectAtIndex: i];
					ccDrawLine(node.position, neighbor.position);
				}
			}
		}	
        
		glColor4ub(255, 255, 255, 255);
	//}
#endif
}

// 0 indexed
- (NSInteger) getCurrentScreenNumber {
    // add delta to ceil up to at least 1
    NSInteger result = ceil(fabs(self.position.x) / [self getOneScreenWidth] + 0.000001);
    
    // account for the extra screen between scrolling wrap around
    if (result > self.numberOfScreens) {
        result = 1;
    }
    
    // result should be at least 1 (this changes it to 0 indexing)
    result -= 1;
    
    return result;
}

- (CGFloat) getOneScreenWidth {
    return (self.gameAreaSize.x * PTM_RATIO / self.numberOfScreens);
}

- (void) updatePosition {
    if (originalPosition.x == -1 && originalPosition.y == -1) {
        originalPosition = CGPointMake(self.position.x * PTM_RATIO, self.position.y * PTM_RATIO);
    }
/*    
    if (fabs(self.position.x) >= self.gameAreaSize.x * PTM_RATIO) {
        self.position = ccp(0, self.position.y);
    } else {
        // use 4 becuase it divide nicely into screen width
        self.position = ccp(self.position.x - 4, self.position.y); 
    }
*/
    if (positionOffset <= -self.gameAreaSize.x * PTM_RATIO) {
        positionOffset = self.gameAreaSize.x * PTM_RATIO / self.numberOfScreens;
    } else {
        positionOffset -= 4; // use 4 becuase it divide nicely into screen width
    }
    
    self.position = CGPointMake(originalPosition.x + positionOffset, self.position.y);
}

- (void) dealloc {
    [grid release];
    
    [super dealloc];
}
@end
