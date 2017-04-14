//
//  GameState.m
//  Orbit
//
//  Created by Ken Hung on 3/28/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "GameState.h"

@interface GameState (Private)
    - (void) setKVO;
    - (void) clearKVO;
@end

@implementation GameState
@synthesize hasSpawnedBoss = hasSpawnedBoss_, hasReachedScore = hasReachedScore_, spawnCount = spawnCount_, bossKillCount = bossKillCount_, currentScore = currentScore_, goalScore = goalScore_, maxSpawnCount = maxSpawnCount_;

- (id) init {
    if (self = [super init]) {
        [self resetState];
    }
    
    return self;
}

- (void) setCurrentScore:(NSInteger)currentScore {
    self->currentScore_ = currentScore;
    
    if (self->currentScore_ >= self.goalScore) {
        self.hasReachedScore = YES;
    }
}

- (void) resetState {
    self.hasSpawnedBoss = NO;
    self.hasReachedScore = NO;
    self.spawnCount = 0;
    self.bossKillCount = 0;
    // Set this before currentScore
    self.goalScore = 100;
    self.currentScore = 0;
}

- (void) clearObject {

}

- (void) dealloc {

}
@end
