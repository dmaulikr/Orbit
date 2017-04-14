//
//  Animation.h
//  Orbit
//
//  Created by Ken Hung on 4/5/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Animation : NSObject

@property (nonatomic, retain) CCSpriteBatchNode * warningSpriteSheet;
@property (nonatomic, assign) CCSprite * warningSprite;
@property (nonatomic, retain) CCAnimation * warningAnimation;
- (id) initWithNode: (CCNode *) node;
- (void) createWarningAnimationAtPosition: (CGPoint) position;
- (void) destroyWarningAnimation;
@end
