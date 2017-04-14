//
//  TextureUtils.h
//  Orbit
//
//  Created by Ken Hung on 4/27/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface TextureUtils : NSObject {

}

+ (SKTexture *) createPolygonTextureWithVertexPoints: (NSArray *) vertexPoints textureSize: (CGSize) size;
+ (SKTexture *) createPolygonTextureWithVertexPoints: (NSArray *) vertexPoints textureSize: (CGSize) size strokeColor: (SKColor *) strokeColor fillColor: (SKColor *) fillColor;
+ (CGPathRef) createPhysicsPathWithVertexPoints: (NSArray *) vertexPoints sprite: (SKSpriteNode *) sprite;

+ (bool) clockwiseO: (CGPoint) O A: (CGPoint) A B: (CGPoint) B;
+ (NSMutableArray *) convexHull: (NSMutableArray *) P;
+ (CGSize) findTextureSizeFromVertexList: (NSArray *) vertexList;
@end
