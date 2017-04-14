//
//  KHSKButton.h
//  Orbit
//
//  Created by Ken Hung on 3/25/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//
// Boilerplate code for a Button UI implemented for Sprite Kit.
// Code lifted from:
// http://stackoverflow.com/questions/19082202/setting-up-buttons-in-skscene
//
// IMPOTANT NOTE: Even if you set the hidden property of SKSpriteNode to YES, buttons WILL STILL
// be active on the screen so they WILL capture events as first responders.
//

#import <SpriteKit/SpriteKit.h>

@interface KHSKButton : SKSpriteNode {
    
}

@property (nonatomic, readonly) SEL actionTouchUpInside;
@property (nonatomic, readonly) SEL actionTouchDown;
@property (nonatomic, readonly) SEL actionTouchUp;
@property (nonatomic, readonly, weak) id targetTouchUpInside;
@property (nonatomic, readonly, weak) id targetTouchDown;
@property (nonatomic, readonly, weak) id targetTouchUp;

@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, readonly, strong) SKLabelNode *title;
@property (nonatomic, readwrite, strong) SKTexture *normalTexture;
@property (nonatomic, readwrite, strong) SKTexture *selectedTexture;
@property (nonatomic, readwrite, strong) SKTexture *disabledTexture;

@property (nonatomic, assign) NSInteger tag;

- (id)initWithTextureNormal:(SKTexture *)normal selected:(SKTexture *)selected;
- (id)initWithTextureNormal:(SKTexture *)normal selected:(SKTexture *)selected disabled:(SKTexture *)disabled; // Designated Initializer

- (id)initWithImageNamedNormal:(NSString *)normal selected:(NSString *)selected;
- (id)initWithImageNamedNormal:(NSString *)normal selected:(NSString *)selected disabled:(NSString *)disabled;

/** Sets the target-action pair, that is called when the Button is tapped.
 "target" won't be retained.
 */
- (void)setTouchUpInsideTarget:(id)target action:(SEL)action;
- (void)setTouchDownTarget:(id)target action:(SEL)action;
- (void)setTouchUpTarget:(id)target action:(SEL)action;
@end
