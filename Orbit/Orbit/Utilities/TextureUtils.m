//
//  TextureUtils.m
//  Orbit
//
//  Created by Ken Hung on 4/27/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "TextureUtils.h"

@implementation TextureUtils
+ (SKTexture *) createPolygonTextureWithVertexPoints: (NSArray *) vertexPoints textureSize: (CGSize) size strokeColor: (SKColor *) strokeColor fillColor: (SKColor *) fillColor {
    float strokeWidth = 3.0f;
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width + strokeWidth * 2, size.height + strokeWidth * 2));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(ctx, 0.0, size.height + strokeWidth * 2);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextSetLineWidth(ctx, strokeWidth);
    
    CGPoint firstPoint;
    
    for (int i = 0; i < [vertexPoints count]; i++) {
        CGPoint point = [[vertexPoints objectAtIndex: i] CGPointValue];
        
        // Shift all points by strokeWidth
        point.x += strokeWidth;
        point.y += strokeWidth;
        
        if (i == 0) {
            firstPoint = point;
        }
        
        if (i == 0) {
            CGContextMoveToPoint(ctx, point.x, point.y);
        } else {
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
    }
    
    // Close the polygon
    CGContextAddLineToPoint(ctx, firstPoint.x, firstPoint.y);
    [fillColor setFill];
    //  CGContextFillPath(ctx);
    [strokeColor setStroke];
    //  CGContextDrawPath(ctx, kCGPathStroke);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();
    SKTexture *texture = [SKTexture textureWithImage:textureImage];
    
    UIGraphicsEndImageContext();
    
    return texture;
}

+ (SKTexture *) createPolygonTextureWithVertexPoints: (NSArray *) vertexPoints textureSize: (CGSize) size {
    return [self createPolygonTextureWithVertexPoints: vertexPoints textureSize: size strokeColor: [SKColor greenColor] fillColor: [SKColor colorWithRed:0.0f green:255.0f blue:0.0f alpha: 0.25]];
}

+ (CGPathRef) createPhysicsPathWithVertexPoints: (NSArray *) vertexPoints sprite: (SKSpriteNode *) sprite {
    // Make the physcis body match the middle of the stroke width of the texture.
    float strokeWidth = 3.0f / 2;
    
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (int i = 0; i < [vertexPoints count]; i++) {
        CGPoint point = [[vertexPoints objectAtIndex: i] CGPointValue];
        
        // Shift all points by strokeWidth
        point.x += strokeWidth;
        point.y += strokeWidth;
        
        if (i == 0) {
            CGPathMoveToPoint(path, nil, point.x - offsetX, point.y - offsetY);
        } else {
            CGPathAddLineToPoint(path, nil, point.x - offsetX, point.y - offsetY);
        }
    }
    
    CGPathCloseSubpath(path);

    return path;
}

// Determines the orthogonal vector to two vectors formed from 3 points.
// 2D cross product of OA and OB vectors, i.e. z-component of their 3D cross product.
// Returns true for clockwise turn or the points are collinear, false another.
+ (bool) clockwiseO: (CGPoint) O A: (CGPoint) A B: (CGPoint) B {
	return (A.x - O.x) * (B.y - O.y) - (A.y - O.y) * (B.x - O.x) <= 0;
}

// Ensure the list of points form a convex hull. Throw away extras.
// Given a set of points it returns a polygon surrounding those points (a convex hull)
// From here: http://www.algorithmist.com/index.php/Monotone_Chain_Convex_Hull.cpp
+ (NSMutableArray *) convexHull: (NSMutableArray *) P {
	int n = P.count;
	int k = 0;
	NSMutableArray * H = [[NSMutableArray alloc] initWithCapacity: n * 2];
	
	//Sort points lexicographically (by X, then secondarily by Y)
	//NSSortDescriptor * xDescriptor = [[NSSortDescriptor alloc] initWithKey: @"self.x" ascending: YES];
	//NSSortDescriptor * yDescriptor = [[NSSortDescriptor alloc] initWithKey: @"self.y" ascending: YES];
	
	//NSArray * descriptors = [NSArray arrayWithObjects: xDescriptor, yDescriptor, nil];
	//NSArray * sortedP = [P sortedArrayUsingDescriptors: descriptors];
	[P sortUsingComparator:^(id firstObject, id secondObject) {
        CGPoint firstPoint = [firstObject CGPointValue];
        CGPoint secondPoint = [secondObject CGPointValue];
        
        if (firstPoint.x == secondPoint.x) {
            return firstPoint.y > secondPoint.y;
        }
        
        return firstPoint.x > secondPoint.x;
    }];
    
    NSArray * sortedP = P;
    
	//Build lower hull
	for (int i = 0; i < n; i++) {
		while (k >= 2 && [self clockwiseO: [[H objectAtIndex: k - 2] CGPointValue] A: [[H objectAtIndex: k - 1] CGPointValue] B: [[sortedP objectAtIndex:i] CGPointValue]]) {
			k--;
		}
        
		[H insertObject: [sortedP objectAtIndex: i] atIndex: k++];
	};
 	
	//Build upper hull
	for (int i = n - 2, t = k + 1; i >= 0; i--) {
		while (k >= t && [self clockwiseO: [[H objectAtIndex: k - 2] CGPointValue] A: [[H objectAtIndex: k - 1] CGPointValue] B: [[sortedP objectAtIndex:i] CGPointValue]]) {
			k--;
		}
        
		[H insertObject: [sortedP objectAtIndex: i] atIndex: k++];
	};
	
	[H removeObjectsInRange: NSMakeRange(k, H.count - k)];
    
	//Remove all duplicate objects
	NSMutableArray *noDupeArray = [[NSMutableArray alloc] init];
    
	for(int i = 0; i < H.count; i++) {
		if(![noDupeArray containsObject: [H objectAtIndex: i]]) {
			[noDupeArray addObject: [H objectAtIndex: i]];
		}
	}
    
	return noDupeArray;
}

+ (CGSize) findTextureSizeFromVertexList: (NSArray *) vertexList {
    float xMax = 0.0;
    float yMax = 0.0;
    
    for (int i = 0; i < [vertexList count]; i++) {
        CGPoint point = [[vertexList objectAtIndex: i] CGPointValue];
        
        if (point.x > xMax)
            xMax = point.x;
        
        if (point.y > yMax)
            yMax = point.y;
    }
    
    return CGSizeMake(xMax, yMax);
}
@end
