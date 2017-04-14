//
//  Animation.m
//  Orbit
//
//  Created by Ken Hung on 4/5/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "Animation.h"
#import "EntityConstants.h"

@interface Animation (Private)
    - (void) createWarningSpriteSheet;
@end

@implementation Animation
@synthesize warningSpriteSheet, warningAnimation, rootNode, warningSpriteNode, warningAnimationDuration, warningAnimationRunCount, warningAnimationScale, warningAnimationFrames, anchorNode;

- (id) initWithNode: (SKNode *) node {
    if (self = [super init]) {
        self.rootNode = node;
        self.warningAnimationDuration = 1.0;
        self.warningAnimationRunCount = 2;
        self.warningAnimationFrames = nil;
        self.anchorNode = nil;
        
        [self createWarningSpriteSheet];
    }
    
    return self;
}

- (void) createWarningSpriteSheet {
    self.warningSpriteSheet = [SKTextureAtlas atlasNamed: @"Warning"];
    
    self.warningAnimationFrames = [[NSMutableArray alloc] init];
    for (int i = 1; i <= self.warningSpriteSheet.textureNames.count; ++i) {
        [self.warningAnimationFrames addObject: [self.warningSpriteSheet textureNamed: [NSString stringWithFormat: @"warning_%d", i]]];
    }
    
    self.warningSpriteNode = [SKSpriteNode spriteNodeWithTexture: [SKTexture textureWithImageNamed: @"warning_1" ]];
}

- (void) createWarningAnimationAtPosition: (CGPoint) position completion: (void (^)())block {
    if (self.warningAnimationDuration <= 0) {
        // Don't animate, just call completion block.
        block();
        return;
    }
    
    [self.rootNode addChild: self.warningSpriteNode];
    self.warningSpriteNode.position = position;
    
    self.warningAnimation = [SKAction animateWithTextures: self.warningAnimationFrames timePerFrame: self.warningAnimationDuration / (self.warningSpriteSheet.textureNames.count * self.warningAnimationRunCount)];
    self.warningAnimation = [SKAction repeatAction: self.warningAnimation count: self.warningAnimationRunCount];
    
    if (self.rootNode) {
        [self.warningSpriteNode runAction: self.warningAnimation completion:^{
            [self.warningSpriteNode removeFromParent];
            
            if (block != nil) {
                block();
            }
        }];
    }
}

- (void) destroyWarningAnimations {
    // Release texture properties that we can recreate if needed
    self.warningSpriteSheet = nil;
    self.warningAnimation = nil;
    self.warningSpriteNode = nil;
    self.warningAnimationFrames = nil;
}

- (void) update: (float) dt {
    if (self.anchorNode) {
        self.warningSpriteNode.position = self.anchorNode.position;
    }
}

#pragma mark - Utilities
+ (void) createScoreTextAnimationInNode: (SKNode *) node atPosition: (CGPoint) position withText: (NSString *) text completion: (void (^)())block {
    SKLabelNode * textNode = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    textNode.text = text;
    textNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    textNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    textNode.fontSize = 32;
    textNode.fontColor = [UIColor colorWithRed: 25.0/255.0 green: 232.0/255.0 blue: 20.0/255.0 alpha: 1.0];
    textNode.position = position;

    [node addChild: textNode];
    
    SKAction * action = [SKAction moveByX: 0.0 y: 50.0 duration: 0.5];
    action = [SKAction repeatAction: action count: 1];
    
    [textNode runAction: action completion: ^{
        [textNode removeFromParent];
        if (block != nil) {
            block();
        }
    }];
}
@end
