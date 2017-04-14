//
//  Enums.h
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

typedef enum {
    ENTITY_TYPE_NONE,
    ENTITY_TYPE_TRIANGLE,
    ENTITY_TYPE_SQUARE,
    ENTITY_TYPE_LINE,
    ENTITY_TYPE_PLUS,
    ENTITY_TYPE_CIRCLE,
    ENTITY_TYPE_PATHED,
    ENTITY_TYPE_WALL
} EntityType;

enum {
    ENTITY_SIDE_NONE    = 1 << 0,
    ENTITY_SIDE_ENEMY   = 1 << 1,
    ENTITY_SIDE_WEAPON  = 1 << 2,
    ENTITY_SIDE_SELF    = 1 << 3
};
typedef NSUInteger EntitySide;

enum {
    WEAPON_TYPE_NONE            = 1 << 0,
    WEAPON_TYPE_CIRCULAR        = 1 << 1,
    WEAPON_TYPE_ELIPSE          = 1 << 2,
    WEAPON_TYPE_SPIRAL_SLING    = 1 << 3,
    WEAPON_TYPE_LISSAJOUS       = 1 << 4
};
typedef NSUInteger WeaponType;

typedef enum {
    WEAPON_EFFECT_NONE
} WeaponEffect;