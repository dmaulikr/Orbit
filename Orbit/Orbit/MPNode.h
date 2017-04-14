//
//  MPNode.h
//  Orbit
//
//  Created by Ken Hung on 6/14/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface MPNode : NSObject <NSCopying>

@property (nonatomic, assign) CGVector vector, targetVector, vectorNormalized;
@property (nonatomic, assign) CGPoint endPoint, startPoint, targetPoint;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) BOOL doesCollide;

- (id) initWithStartPoint: (CGPoint) startPoint endPoint: (CGPoint) endPoint targetPoint: (CGPoint) targetPoint physicsWorld: (SKPhysicsWorld *) physicsWorld;

- (void) setStartPoint:(CGPoint)startPoint endPoint: (CGPoint) endPoint targetPoint: (CGPoint) targetPoint physicsWorld: (SKPhysicsWorld *) physicsWorld;
@end
