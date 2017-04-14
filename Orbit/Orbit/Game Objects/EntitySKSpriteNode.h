//
//  EntitySKSpriteNode.h
//  Orbit
//
//  Created by Ken Hung on 5/11/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Entity;

@interface EntitySKSpriteNode : SKSpriteNode {
    
}

// References the Entity that contains this SKSpriteNode. This reference is used
// to back to the Entity object container from SkPhysicsBody callbacks
@property (nonatomic, assign) Entity * entityContainer;
@end
