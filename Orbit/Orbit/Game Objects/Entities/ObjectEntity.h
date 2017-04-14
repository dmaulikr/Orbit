//
//  ObjectEntity.h
//  Orbit
//
//  Created by Ken Hung on 2/20/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "Entity.h"

@interface ObjectEntity : Entity {
    CGPoint originalPosition;
    CGFloat positionOffset;
}

@property (nonatomic, assign) CGPoint gameAreaSize;
@property (nonatomic, assign) NSInteger numberOfScreens;
@property (nonatomic, retain) NSMutableArray * vertices;
@property (nonatomic, assign) WallType wallType;

- (id) initAtPosition: (CGPoint) position onSide: (EntitySide) side wallType: (WallType) wallType withNode: (SKNode *) node physicsWorld: (SKPhysicsWorld *) world withVertexList: (NSArray*) vertexList withStreak: (BOOL) enableStreak;
@end
