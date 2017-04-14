//
//  Utils.h
//  Orbit
//
//  Created by Ken Hung on 2/12/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#ifndef Orbit_Utils_h
#define Orbit_Utils_h

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// Debug definition -- comment out to increase performance
// Draw debug grid (extremely degrades performance)
//#define ORBIT_DEBUG_ON
// Disable Grid and object scrlling
//#define ORBIT_DEBUG_DISABLE_SCROLLING
// AStar paths for PathedEntities
#define ORBIT_DEBUG_ENABLE_PATHING
// Toggle bounding box debugging
//#define ORBIT_DEBUG_COLLISION_BOXES
#endif
