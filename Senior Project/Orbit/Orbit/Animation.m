//
//  Animation.m
//  Orbit
//
//  Created by Ken Hung on 4/5/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "Animation.h"

@interface Animation ()
    - (void) initWarningSpriteSheetWithNode: (CCNode *) node;
@end

@implementation Animation
@synthesize warningSpriteSheet, warningSprite, warningAnimation;

- (id) initWithNode: (CCNode *) node {
    if (self = [super init]) {
        [self initWarningSpriteSheetWithNode: node];
    }
    
    return self;
}

- (void) initWarningSpriteSheetWithNode: (CCNode *) node {
    self.warningSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"warnings.png"];
    [node addChild: self.warningSpriteSheet];
    
    NSMutableArray * animFrames = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 12; ++i) {
        NSLog(@"%d", i);
        [animFrames addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat: @"warning_%d.png", i]]];
    }
    
    self.warningAnimation = [CCAnimation animationWithFrames: animFrames delay: 0.02f];
    self.warningSprite = [CCSprite spriteWithSpriteFrameName: @"warning_1.png"];
    
    [animFrames release];
}

- (void) createWarningAnimationAtPosition: (CGPoint) position {
    CCAction * action = [CCRepeat actionWithAction: [CCAnimate actionWithAnimation: self.warningAnimation restoreOriginalFrame: NO] times: 2];
    [self.warningSprite runAction: action];
    
    self.warningSprite.position = position;
    [self.warningSpriteSheet addChild: self.warningSprite];
}

- (void) destroyWarningAnimation {
    [self.warningSpriteSheet removeChild: self.warningSprite cleanup:YES];
}

- (void) dealloc {
    [warningSpriteSheet release];
    [warningAnimation release];
    
    [super dealloc];
}
@end
