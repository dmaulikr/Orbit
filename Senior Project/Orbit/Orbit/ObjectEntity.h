//
//  ObjectEntity.h
//  Orbit
//
//  Created by Ken Hung on 2/20/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "Entity.h"
#import "GLES-Render.h"

@interface ObjectEntity : Entity {
    CGPoint originalPosition;
    CGFloat positionOffset;
}

@property (nonatomic, assign) CGPoint gameAreaSize;
@property (nonatomic, assign) NSInteger numberOfScreens;
@property (nonatomic, assign) GLESDebugDraw * m_debugDraw; // TEMP until we can define our own draw functions

- (void) DrawShape: (b2Fixture*) fixture, const b2Transform& xf, const b2Color& color;
@end
