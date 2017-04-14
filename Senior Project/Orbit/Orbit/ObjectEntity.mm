//
//  ObjectEntity.m
//  Orbit
//
//  Created by Ken Hung on 2/20/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "ObjectEntity.h"
#import "ccMacros.h"
#import "b2World.h"

@implementation ObjectEntity
@synthesize gameAreaSize, numberOfScreens, m_debugDraw;

- (id) init {
    if ((self = [super init])) {
        self.entityType = ENTITY_TYPE_WALL;
        self.gameAreaSize = CGPointZero;
        self.numberOfScreens = 1;
        
        positionOffset = 0;
        originalPosition = CGPointMake(-1, -1);
        
        m_debugDraw = nil;
    }

    return self;
}

- (void) updatePosition:(ccTime)dt {
#ifndef ORBIT_DEBUG_DISABLE_SCROLLING
    b2Body * objBody = self.body;
    b2Vec2 b2Position;
    
    if (originalPosition.x == -1 && originalPosition.y == -1) {
        originalPosition = CGPointMake(self.body->GetPosition().x * PTM_RATIO, self.body->GetPosition().y * PTM_RATIO);
    }
    
    if (positionOffset <= -self.gameAreaSize.x * PTM_RATIO) {
        positionOffset = self.gameAreaSize.x * PTM_RATIO / self.numberOfScreens;
    } else {
        positionOffset -= 4; // use 4 becuase it divide nicely into screen width
    }
    
    b2Position = b2Vec2((originalPosition.x + positionOffset) / PTM_RATIO, objBody->GetPosition().y);
    
    float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(self.sprite.rotation);
    
    objBody->SetTransform(b2Position, b2Angle);    
#endif
}

- (void) draw {
    if (!self.m_debugDraw) {
        return;
    }
    
#ifdef ORBIT_DEBUG_COLLISION_BOXES
    return;
#endif
    
    b2Body * b = self.body;
    const b2Transform& xf = b->GetTransform();
    for (b2Fixture* f = b->GetFixtureList(); f; f = f->GetNext())
    {
        if (b->IsActive() == false)
        {
            [self DrawShape: f, xf, b2Color(0.5f, 0.5f, 0.3f)];
        }
        else if (b->GetType() == b2_staticBody)
        {
            [self DrawShape: f, xf, b2Color(0.5f, 0.9f, 0.5f)];
        }
        else if (b->GetType() == b2_kinematicBody)
        {
            [self DrawShape: f, xf, b2Color(0.5f, 0.5f, 0.9f)];
        }
        else if (b->IsAwake() == false)
        {
            [self DrawShape: f, xf, b2Color(0.6f, 0.6f, 0.6f)];
        }
        else
        {
            [self DrawShape: f, xf, b2Color(0.9f, 0.7f, 0.7f)];
        }
    }
}

- (void) DrawShape: (b2Fixture*) fixture, const b2Transform& xf, const b2Color& color
{
	switch (fixture->GetType())
	{
        case b2Shape::e_circle:
		{
			b2CircleShape* circle = (b2CircleShape*)fixture->GetShape();
            
			b2Vec2 center = b2Mul(xf, circle->m_p);
			float32 radius = circle->m_radius;
			b2Vec2 axis = xf.R.col1;
            
			self.m_debugDraw->DrawSolidCircle(center, radius, axis, color);
		}
            break;
            
        case b2Shape::e_polygon:
		{
			b2PolygonShape* poly = (b2PolygonShape*)fixture->GetShape();
			int32 vertexCount = poly->m_vertexCount;
			b2Assert(vertexCount <= b2_maxPolygonVertices);
			b2Vec2 vertices[b2_maxPolygonVertices];
            
			for (int32 i = 0; i < vertexCount; ++i)
			{
				vertices[i] = b2Mul(xf, poly->m_vertices[i]);
			}
            
			self.m_debugDraw->DrawSolidPolygon(vertices, vertexCount, color);
		}
            break;
        default:	// cocos2d patch. Prevents compiler warning in llvm 2.0
			break;
	}
}
@end
