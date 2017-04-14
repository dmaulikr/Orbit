//
//  MPNode.m
//  Orbit
//
//  Created by Ken Hung on 6/14/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "MPNode.h"
#import "Vector2DUtility.h"

@implementation MPNode
@synthesize vector = vector_, startPoint = startPoint_, endPoint = endPoint_, angle = angle_, targetPoint = targetPoint_, targetVector = targetVector_, doesCollide = doesCollide_,
    vectorNormalized = vectorNormalized;

- (id) initWithStartPoint: (CGPoint) startPoint endPoint: (CGPoint) endPoint targetPoint: (CGPoint) targetPoint physicsWorld: (SKPhysicsWorld *) physicsWorld {
    if (self = [super init]) {
        [self setStartPoint: startPoint endPoint: endPoint targetPoint: targetPoint physicsWorld: physicsWorld];
    }
    
    return self;
}

- (void) setStartPoint:(CGPoint)startPoint endPoint: (CGPoint) endPoint targetPoint: (CGPoint) targetPoint physicsWorld: (SKPhysicsWorld *) physicsWorld {
    self.startPoint = startPoint;
    self.endPoint = endPoint;
    self.targetPoint = targetPoint;
    
    self.vector = [Vector2DUtility GetVectorFromPoint: self.startPoint toPoint: self.endPoint];
    self.vectorNormalized = [Vector2DUtility NormalizeVector: self.vector];
    self.targetVector = [Vector2DUtility GetVectorFromPoint: self.startPoint toPoint: self.targetPoint];
    self.angle = [Vector2DUtility GetAngleBetweenVector: self.vector vector: self.targetVector];
    
    self.doesCollide = [physicsWorld bodyAlongRayStart: self.startPoint end: self.endPoint] ? YES : NO;
}

- (id) copyWithZone: (NSZone *) zone
{
    // We'll ignore the zone for now
    MPNode * node = [[MPNode alloc] init];
    
    node.startPoint = self.startPoint;
    node.endPoint = self.endPoint;
    node.targetPoint = self.targetPoint;
    node.vector = self.vector;
    node.vectorNormalized = self.vectorNormalized;
    node.targetVector = self.targetVector;
    node.angle = self.angle;
    node.doesCollide = self.doesCollide;
    
    return node;
}

- (NSString *) description {
    NSString * startPoint = [NSString stringWithFormat: @"(%f, %f)", self.startPoint.x, self.startPoint.y],
        * endPoint = [NSString stringWithFormat: @"(%f, %f)", self.endPoint.x, self.endPoint.y],
        * targetPoint = [NSString stringWithFormat: @"(%f, %f)", self.targetPoint.x, self.targetPoint.y],
        * vector = [NSString stringWithFormat: @"<%f, %f>", self.vector.dx, self.vector.dy],
    * targetVector = [NSString stringWithFormat: @"<%f, %f>", self.targetVector.dx, self.targetVector.dy];
    
    return [NSString stringWithFormat: @"\nMPNode: {\n   angle: %f\n   doesCollide: %@\n   startPoint: %@\n   endPoint: %@\n   targetPoint: %@\n   vector: %@\n   targetVector: %@\n}", self.angle * (180/M_PI), self.doesCollide ? @"YES" : @"NO", startPoint, endPoint, targetPoint, vector, targetVector];
}
@end
