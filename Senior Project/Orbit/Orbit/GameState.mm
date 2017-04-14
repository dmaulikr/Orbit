//
//  GameState.m
//  Orbit
//
//  Created by Ken Hung on 3/28/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "GameState.h"
#import "HUD.h"

@implementation GameState
@synthesize hasSpawnedBoss, hasReachedScore, spawnCount, bossKillCount, currentScore, goalScore, HUDObserver;

- (id) init {
    if (self = [self initWithHUD: nil]) {
    }
    
    return self;
}

- (id) initWithHUD: (HUD*) playerHUD {
    if (self = [super init]) {
        self.hasSpawnedBoss = NO;
        self.hasReachedScore = NO;
        self.spawnCount = 0;
        self.bossKillCount = 0;
        self.currentScore = 0;
        self.goalScore = 0;
        self.HUDObserver = playerHUD;
        
        if (self.HUDObserver) {
            [self addObserver: self.HUDObserver forKeyPath: @"currentScore" options: NSKeyValueObservingOptionNew context:nil];
            [self addObserver: self forKeyPath: @"currentScore" options: NSKeyValueObservingOptionNew context: nil];
        }
    }
    
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString: @"currentScore"]) {
        if ([object isKindOfClass: [GameState class]]) {
            if (self.currentScore >= self.goalScore) {
                self.hasReachedScore = YES;
            }
        }
    }
}

- (void) setCurrentScore: (NSInteger) newCurrentScore withGoalScore: (NSInteger) newGoalScore {
    self.goalScore = newGoalScore; // Note order, HUD will query for this property but only when currentScore changes so set this first.
    self.currentScore = newCurrentScore;
}

-(void) dealloc {
    [self removeObserver: self.HUDObserver forKeyPath: @"currentScore"];
    [self removeObserver: self forKeyPath: @"currentScore"];
    
    [super dealloc];
}
@end
