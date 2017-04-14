//
//  GameManager.m
//  Orbit
//
//  Created by Ken Hung on 4/20/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//
// Single Level game manager that handles the entire level lifecycle.
//
// TO DO: Create an Entity reuse system so that we can reuse Entities without needing to recreate them.
//

#import "GameManager.h"
#import "CircleEntity.h"
#import "PlayerEntity.h"
#import "LineEntity.h"
#import "ObjectEntity.h"
#import "WeaponEntity.h"
#import "SmartEntity.h"
#import "ProceduralGenerator.h"
#import "AppUtils.h"
#import "GameState.h"
#import "HUD.h"
#import "Animation.h"

#define GAME_MANAGER_SPAWN_TIME_INTERVAL 5.0

@interface GameManager (Private)

@end

@implementation GameManager
@synthesize levelFile = levelFile_, entityList = entityList_, objectsList = objectsList_, destroyQueue = destroyQueue_, scene = scene_;
@synthesize playerEntity = playerEntity_, proceduralGenerator = proceduralGenerator_, gameState = gameState_, hud = hud_;

- (id) initWithLevel:(LevelFile *)levelFile scene: (SKScene *) scene {
    if (self = [super init]) {
        self.scene = scene;
        
        self.entityList = [[NSMutableArray alloc] init];
        self.objectsList = [[NSMutableArray alloc] init];
        self.destroyQueue = [[NSMutableArray alloc] init];
        
        // Level Parsing and Setup
        self.levelFile = levelFile;
        
        // Game State Setup
        self.gameState = [[GameState alloc] init];
        self.gameState.maxSpawnCount = 1;
        self.gameState.goalScore = 100;
        
        [self createLevel];
        [self setupLevel];
        
        // HUD
        self.hud = [[HUD alloc] initWithNode: self.scene];
        [self.hud setTryAgainTarget: self selector: @selector(resetLevel)];
        [self.hud setNextLevelTarget: self selector: @selector(resetLevel)];
        self.hud.weaponDamageText.text = [NSString stringWithFormat:@"%.2f", self.playerEntity.primaryWeapon.damage];
        self.hud.weaponSpeedText.text = [NSString stringWithFormat:@"%.2f", self.playerEntity.primaryWeapon.speed];
    }
    
    return self;
}

- (void) clearWallObjects {
    [self.objectsList removeAllObjects];
}

- (void) clearObject {
    for (Entity * entity in self.entityList) {
   //     NSLog(@"%d", [entity clearKVO]);
        [entity clearObject];
    }
    
    for (Entity * entity in self.objectsList) {
        [entity clearObject];
    }
    
    // TO DO: Clear components
    // [self clearWallObjects];
    // self.proceduralGenerator = nil;
    // [self.hud removeFromRootNode];
}

- (void) spawnRandomEntity {
    Entity * entity = nil;
    /*
    int res = arc4random() % 2;
    
    switch (res) {
        case 0:
            entity = [[LineEntity alloc] initAtPosition: CGPointMake(300, 300) onSide: ENTITY_SIDE_ENEMY withNode: self.scene physicsWorld: self.scene.physicsWorld withStreak: NO];
            entity.scoreValue = 10;
            entity.primaryWeapon.scoreValue = 5;
            break;
        case 1:
            entity = [[CircleEntity alloc] initAtPosition: CGPointMake(100, 100) onSide: ENTITY_SIDE_ENEMY withNode: self.scene physicsWorld: self.scene.physicsWorld withStreak: NO];
            entity.scoreValue = 15;
            entity.primaryWeapon.scoreValue = 5;
            break;
        default:
            break;
    }
    */
    entity = [[SmartEntity alloc] initAtPosition: CGPointMake(500, 500) onSide: ENTITY_SIDE_ENEMY withNode: self.scene physicsWorld: self.scene.physicsWorld withStreak: NO];
    entity.scoreValue = 15;
    entity.primaryWeapon.scoreValue = 5;
    entity.speed = 2.0;
    ((SmartEntity*)entity).playerEntity = self.playerEntity;
    
    if (entity) {
        [self.entityList addObject: entity];
        [entity showEntityWithAnimation];
    }
}

#pragma mark - Player Entity Accessors
- (BOOL) isPointInPlayerEntity: (CGPoint) point {    
    return [AppUtils isPointInEntity: point entity: self.playerEntity];
}

- (void) setPlayerEntityPosition: (CGPoint) point {
    self.playerEntity.sprite.position = point;
}

- (void) setPlayerEntityWeaponActive: (BOOL) isActive {
    self.playerEntity.isWeaponPowered = isActive;
}

- (void) update: (CFTimeInterval) currentTime {
    if (self.gameState.hasReachedScore) {
        [self.hud shouldShowLevelCompleteUI: YES withAnimation: YES];
        return;
    }
    
    // TO DO: Implement correct loss response
    if (self.playerEntity.isGameOver) {
        [self.hud shouldShowGameOverUI: YES withAnimation: YES];
        return;
        // [self spawnRandomEntity];
        // self.gameState.spawnCount++;
        // self.playerEntity.isGameOver = NO;
    }
    
    if (!self->_lastUpdateTime) {
        self->_lastUpdateTime = currentTime;
    }
    
    // Spawn Timer
    if (self->_lastUpdateTime)
    {
        if (currentTime - self->_lastUpdateTime > GAME_MANAGER_SPAWN_TIME_INTERVAL) {
            if (self.gameState.spawnCount < self.gameState.maxSpawnCount) {
                NSLog(@"Spawning!");
                [self spawnRandomEntity];
                self.gameState.spawnCount++;
            }
            
            self->_lastUpdateTime = 0.0;
        }
    }
    
    // Update Object List
 /*   for (Entity * entity in self.objectsList) {
        [entity update: currentTime];
    }*/
    
    // Update Entity List
    for (Entity * entity in self.entityList) {
        [entity update: currentTime];
        
        if (!entity.isValid) {
            [self.destroyQueue addObject: entity];
        }
    }
    
    [self.entityList removeObjectsInArray: self.destroyQueue];
    
    if ([self.destroyQueue count]) {
        self.gameState.spawnCount -= [self.destroyQueue count];
        [self.destroyQueue removeAllObjects];
    }
    
    [self.playerEntity update: currentTime];
}

#pragma mark - SKPhysicsContactDelegate Methods
- (void) didBeginContact:(SKPhysicsContact *)contact {
    SKNode * nodeA = contact.bodyA.node;
    SKNode * nodeB = contact.bodyB.node;
    NSInteger score = 0, entityScoreValue = 0;
    
    if ([nodeA isKindOfClass: [EntitySKSpriteNode class]]) {
        EntitySKSpriteNode * esdpn =  (EntitySKSpriteNode *)nodeA;
        Entity * en = esdpn.entityContainer;
        entityScoreValue = [en getTotalScoreValue];
#ifdef DEBUG
        NSLog(@"Contact: %@", NSStringFromClass([esdpn.entityContainer class]));
#endif
        if ([en isKindOfClass: [PlayerEntity class]]) {
            ((PlayerEntity*)en).isGameOver = YES;
        } else if ([en isKindOfClass: [WeaponEntity class]]) {
            if (![((WeaponEntity *)en).protectee isKindOfClass: [PlayerEntity class]]) {
                en.health = en.health - 0.55;
                
                if (!en.isValid) {
                    score += entityScoreValue;
                }
            }
        } else {
            en.health = en.health - 0.35;
            
            if (!en.isValid) {
                score += entityScoreValue;
            }
        }
    }
    
    if ([nodeB isKindOfClass: [EntitySKSpriteNode class]]) {
        EntitySKSpriteNode * esdpn = (EntitySKSpriteNode *)nodeB;
        Entity * en = esdpn.entityContainer;
        entityScoreValue = [en getTotalScoreValue];
#ifdef DEBUG
        NSLog(@"Contact: %@", NSStringFromClass([esdpn.entityContainer class]));
#endif
        if ([en isKindOfClass: [PlayerEntity class]]) {
            ((PlayerEntity*)en).isGameOver = YES;
        } else if ([en isKindOfClass: [WeaponEntity class]]) {
            if (![((WeaponEntity *)en).protectee isKindOfClass: [PlayerEntity class]]) {
                en.health = en.health - 0.55;
                
                if (!en.isValid) {
                    score += entityScoreValue;
                }
            }
        } else {
            en.health = en.health - 0.35;
            
            if (!en.isValid) {
                score += entityScoreValue;
            }
        }
    }

    if (score) {
        self.gameState.currentScore += score;
        self.hud.scoreText.text = [NSString stringWithFormat:@"%d", self.gameState.currentScore];
    }
}

- (void) didEndContact:(SKPhysicsContact *)contact {
    
}

- (void) createLevel {
    // Create Player Object
    self.playerEntity = [[PlayerEntity alloc] initAtPosition: CGPointMake(500, 500) onSide: ENTITY_SIDE_SELF withNode: self.scene physicsWorld: self.scene.physicsWorld withStreak: NO];
    
    // Procedural Generate Walls
    NSMutableArray * wallPoints = [[NSMutableArray alloc] init];
    CGPoint position;
    self.proceduralGenerator = [[ProceduralGenerator alloc] init];
    self.proceduralGenerator.wallSize = CGSizeMake(200, 200);
    CGSize screenSize = [AppUtils getScreenSize];
    Entity * entity;
    
    for (int i = 0; i < 5; i++) {
        [wallPoints removeAllObjects];
        
        wallPoints = [self.proceduralGenerator generateWall];
        position = CGPointMake(arc4random() % (int)screenSize.width, arc4random() % (int)screenSize.height);
        
        entity = [[ObjectEntity alloc] initAtPosition: CGPointMake(position.x, position.y) onSide:ENTITY_SIDE_ENEMY wallType: WALL_TYPE_INDESTRUCTABLE withNode: self.scene physicsWorld: self.scene.physicsWorld withVertexList: wallPoints withStreak: NO];
        entity.speed = arc4random() % (int) 5;
        [self.objectsList addObject: entity];
    }
}

- (void) setupLevel {
    
}

- (void) beginLevel {
    for (Entity * entity in self.objectsList) {
        [entity showEntityWithAnimation];
    }
    
    for (Entity * entity in self.entityList) {
        [entity showEntityWithAnimation];
    }
    
    [self.playerEntity showEntityWithAnimation];
    
    [self.hud shouldShowGameHUD: YES withAnimation: YES];
}

- (void) resetLevel {
    [self clearObject];
    [self.playerEntity clearObject];
    
    [self createLevel];
    [self setupLevel];
    [self beginLevel];
    
    [self.hud shouldShowGameOverUI: NO withAnimation: NO];
    [self.hud shouldShowLevelCompleteUI: NO withAnimation: NO];
}
@end
