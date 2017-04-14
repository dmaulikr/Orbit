//
//  Animation.h
//  Orbit
//
//  Created by Ken Hung on 4/5/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//
// This is the animation object that will handle all animations per Entity.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Animation : NSObject
// Keep a handle to the base node where this animation set is a part of.
@property (nonatomic, retain) SKNode * rootNode;
// This is the SKNode that this animation will anchor/follow while animating.
@property (nonatomic, assign) SKNode * anchorNode;

// Warning animation
@property (nonatomic, retain) SKSpriteNode * warningSpriteNode;
@property (nonatomic, retain) SKTextureAtlas * warningSpriteSheet;
@property (nonatomic, retain) SKAction * warningAnimation;
@property (nonatomic, retain) NSMutableArray * warningAnimationFrames;
// In seconds
@property (nonatomic, assign) NSTimeInterval warningAnimationDuration;
@property (nonatomic, assign) NSInteger warningAnimationRunCount;
// TO DO: Add ability to scale animation.
@property (nonatomic, assign) CGFloat warningAnimationScale;

// TO DO: Impelement custom animation
@property (nonatomic, assign) SKEmitterNode * deathAnimation;

- (id) initWithNode: (SKNode *) node;
// Create and show a warning animation. Calls the completetion block when the animation finishes.
- (void) createWarningAnimationAtPosition: (CGPoint) position completion: (void (^)())block;
// Clear textures incase we don't need animations anymore and need memory
- (void) destroyWarningAnimations;

- (void) update: (float) dt;

// Utilities
+ (void) createScoreTextAnimationInNode: (SKNode *) node atPosition: (CGPoint) position withText: (NSString *) text completion: (void (^)())block;
@end
