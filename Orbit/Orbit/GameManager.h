//
//  GameManager.h
//  Orbit
//
//  Created by Ken Hung on 4/20/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <Foundation/Foundation.h>

@class LevelFile;
@class PlayerEntity;
@class ProceduralGenerator;
@class GameState;
@class HUD;

@interface GameManager : NSObject <SKPhysicsContactDelegate> {
    CFTimeInterval _lastUpdateTime;
}

// Level File object that holds all level data from level editor.
@property (nonatomic, retain) LevelFile * levelFile;
// Game State
@property (nonatomic, retain) GameState * gameState;

// HUD
@property (nonatomic, retain) HUD * hud;

// Scene
@property (nonatomic, assign) SKScene * scene;

// List of Entity objects.
@property (nonatomic, retain) NSMutableArray * entityList;
// List of world Entity objects.
@property (nonatomic, retain) NSMutableArray * objectsList;
// Queue of Entities and objects to be destroyed.
@property (nonatomic, retain) NSMutableArray * destroyQueue;
// Player Reference
@property (nonatomic, retain) PlayerEntity * playerEntity;

// Utilities
@property (nonatomic, retain) ProceduralGenerator * proceduralGenerator;

- (id) initWithLevel: (LevelFile *) levelFile scene: (SKScene *) scene;

// Call this before your last reference is set to nil to clear things like KVO.
- (void) clearObject;

- (void) spawnRandomEntity;

- (void) clearWallObjects;

// Player Entity accessors
- (BOOL) isPointInPlayerEntity: (CGPoint) point;
- (void) setPlayerEntityPosition: (CGPoint) point;
- (void) setPlayerEntityWeaponActive: (BOOL) isActive;

- (void) update: (CFTimeInterval) currentTime;

/**
 * Level Setup Functions
 */
// Level Object creation, allocation
- (void) createLevel;
// Level Object setup.
- (void) setupLevel;
- (void) beginLevel;
- (void) resetLevel;
@end
