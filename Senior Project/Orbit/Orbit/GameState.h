//
//  GameState.h
//  Orbit
//
//  Created by Ken Hung on 3/28/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//
//  Keeps track of a level's metadata.
//

#import <Foundation/Foundation.h>
@class HUD;

@interface GameState : NSObject {
    BOOL hasSpawnedBoss, hasReachedScore;
    NSInteger spawnCount, bossKillCount, currentScore, goalScore;
}

@property (nonatomic, assign) BOOL hasSpawnedBoss, hasReachedScore;
@property (nonatomic, assign) NSInteger spawnCount, bossKillCount, currentScore, goalScore;
@property (nonatomic, assign) HUD * HUDObserver;

- (id) initWithHUD: (HUD*) playerHU;

- (void) setCurrentScore: (NSInteger) newCurrentScore withGoalScore: (NSInteger) newGoalScore;

@end
