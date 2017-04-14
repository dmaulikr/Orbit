//
//  GridLayer.h
//  Orbit
//
//  Created by Ken Hung on 2/12/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
@interface GridLayer : CCLayer {
    CGPoint gameAreaSize;
    float nodeSpace;	//The space between each node, increase this to increase A* efficiency at the cost of accuracy
	int gridSizeX;
	int gridSizeY;
    
    CGPoint originalPosition;
    CGFloat positionOffset;
}

@property (nonatomic, retain) NSMutableArray * grid;
@property (nonatomic, assign) CGPoint gameAreaSize;
@property (nonatomic, assign) NSInteger numberOfScreens;
@property (nonatomic, assign) float nodeSpace;
@property (nonatomic, assign) int gridSizeX, gridSizeY;
@property (nonatomic, assign) CGPoint originalPosition;
@property (nonatomic, assign) CGFloat positionOffset;

// returns a CCScene that contains the MenuLayer as the only child
+ (CCScene *) scene;

- (id) initWithScreenWidths: (NSInteger) numberOfScreenWidths;

- (void) cullGridWithWorld: (b2World *) world;

- (NSInteger) getCurrentScreenNumber;
- (CGFloat) getOneScreenWidth;

- (void) updatePosition;
@end
