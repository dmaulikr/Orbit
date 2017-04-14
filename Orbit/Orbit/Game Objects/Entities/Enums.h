//
//  Enums.h
//  Orbit
//
//  Created by Ken Hung on 8/28/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//
// This structure defines Entity characteristics such as it's type, the weapon type it
// has, and what side (enemy or ally) it is when doing comparisons for game play.
//

// The type of entity.
typedef enum {
    ENTITY_TYPE_NONE      = 0,
    ENTITY_TYPE_TRIANGLE  = 1 << 0,
    ENTITY_TYPE_SQUARE    = 1 << 1,
    ENTITY_TYPE_LINE      = 1 << 2,
    ENTITY_TYPE_PLUS      = 1 << 3,
    ENTITY_TYPE_CIRCLE    = 1 << 4,
    ENTITY_TYPE_SMART     = 1 << 5,
    ENTITY_TYPE_WALL      = 1 << 6,
    ENTITY_TYPE_PLAYER    = 1 << 7,
    ENTITY_TYPE_ALL       = ~ 0
} EntityType;

// The side an entity takes. Can be bitwise ORed.
enum {
    ENTITY_SIDE_NONE    = 0,
    ENTITY_SIDE_ENEMY   = 1 << 0,
    ENTITY_SIDE_WEAPON  = 1 << 1,
    ENTITY_SIDE_SELF    = 1 << 2,
    ENTITY_SIDE_ALL     = ~ 0
};
typedef NSUInteger EntitySide;

// The type of weapon. Can be bitwise ORed.
enum {
    WEAPON_TYPE_NONE            = 0,
    WEAPON_TYPE_CIRCULAR        = 1 << 0,
    WEAPON_TYPE_ELIPSE          = 1 << 1,
    WEAPON_TYPE_SPIRAL_SLING    = 1 << 2,
    WEAPON_TYPE_LISSAJOUS       = 1 << 3,
    WEAPON_TYPE_ALL             = ~ 0
};
typedef NSUInteger WeaponType;

enum {
    WALL_TYPE_NONE             = 0,
    WALL_TYPE_INDESTRUCTABLE   = 1, // Wall cannot be destroyed.
    WALL_TYPE_CRUMBLING        = 2, // Wall will shrink as it is hit.
    WALL_TYPE_SOLID            = 3, // Wall retains it's size as it is hit.
};
typedef NSUInteger WallType;

// The weapon effect.
typedef enum {
    WEAPON_EFFECT_NONE
} WeaponEffect;