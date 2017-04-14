//
//  StoreScene.m
//  Orbit
//
//  Created by Ken Hung on 7/7/14.
//  Copyright (c) 2014 Last Steep. All rights reserved.
//

#import "StoreScene.h"
#import "Textureutils.h"
#import "AppUtils.h"
#import "KHSKButton.h"
#import "WeaponEntity.h"
#import "AppUtils.h"

@interface StoreScene (Private)
- (void) CreateButtons;
- (void) CreateTabs;
@end

@implementation StoreScene
@synthesize buttonList = buttonList_, tabList = tabList_, playerEntity = playerEntity_;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor blackColor];
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        
        [self CreateButtons];
        [self CreateTabs];
        [self CreatePlayer];
    }
    return self;
}

- (void) CreatePlayer {
    self.playerEntity = [[PlayerEntity alloc] initAtPosition: CGPointMake(500, 500) onSide: ENTITY_SIDE_SELF withNode: self.scene physicsWorld: self.scene.physicsWorld withStreak: NO];
[self.playerEntity showEntityWithAnimation];
    self.playerEntity.isWeaponPowered = YES;
    self.playerEntity.primaryWeapon.speed = 3.0;
}

- (void) CreateTabs {
    CGSize screenSize = [AppUtils getScreenSize];
    
    NSInteger buttonCount = 4;
    // 6 is stroke margin (3 per side)
    CGFloat tabButtonWidth = 75, tabButtonHeight = 50;
    NSMutableArray * vertices = [[NSMutableArray alloc] init];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(tabButtonWidth, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(tabButtonWidth, tabButtonHeight)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, tabButtonHeight)]];
    
    // TO DO: This will be a HUGE texture
    CGSize textureSize = [TextureUtils findTextureSizeFromVertexList: vertices];
    
    SKTexture * buttonTexture = [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor blueColor] fillColor: [SKColor colorWithRed: 60.0f/255.0f green: 82.0f/255.0f blue: 120.0f/255.0f alpha: 0.95f]];
    SKTexture * buttonSelectedTexture = [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor blueColor] fillColor: [SKColor colorWithRed: 200.0f/255.0f green: 82.0f/255.0f blue: 50.0f/255.0f alpha: 0.95f]];
    
    CGFloat tabMargin = 10;
    CGFloat xBase = self->buttonWidth + (tabButtonWidth / 2) + ((screenSize.width - self->buttonWidth * 2) - (buttonCount * tabButtonWidth)) / 2;
    CGFloat yBase = (screenSize.height - (tabButtonHeight / 2)) - tabMargin;
    
    for (int i = 0; i < buttonCount; i++) {
        KHSKButton * button = [[KHSKButton alloc] initWithTextureNormal: buttonTexture selected: buttonSelectedTexture];
        [button.title setText: [NSString stringWithFormat: @"Tab %d", i + 1]];
        [button.title setFontName:@"Chalkduster"];
        [button.title setFontSize:20.0];
        [button setPosition: CGPointMake(xBase + (i * button.size.width), yBase)];
        button.zPosition = 5;
        [button setTouchDownTarget:self action:@selector(tabSelectAction:)];
        [self.scene addChild: button];
        [self.buttonList addObject: button];
    }
}

- (void) CreateButtons {
    CGSize screenSize = [AppUtils getScreenSize];
    
    NSInteger buttonCount = 6;
    // 6 is stroke margin (3 per side)
    self->buttonWidth = 200, self->buttonHeight = screenSize.height / buttonCount - 6;
    NSMutableArray * vertices = [[NSMutableArray alloc] init];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(self->buttonWidth, 0)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(self->buttonWidth, self->buttonHeight)]];
    [vertices addObject: [NSValue valueWithCGPoint: CGPointMake(0, self->buttonHeight)]];
    
    // TO DO: This will be a HUGE texture
    CGSize textureSize = [TextureUtils findTextureSizeFromVertexList: vertices];
    
    SKTexture * buttonTexture = [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor blueColor] fillColor: [SKColor colorWithRed: 60.0f/255.0f green: 82.0f/255.0f blue: 120.0f/255.0f alpha: 0.95f]];
    SKTexture * buttonSelectedTexture = [TextureUtils createPolygonTextureWithVertexPoints: vertices textureSize: textureSize strokeColor: [SKColor blueColor] fillColor: [SKColor colorWithRed: 200.0f/255.0f green: 82.0f/255.0f blue: 50.0f/255.0f alpha: 0.95f]];
    
    for (int i = 0; i < buttonCount; i++) {
        KHSKButton * button = [[KHSKButton alloc] initWithTextureNormal: buttonTexture selected: buttonSelectedTexture];
        [button.title setText: [NSString stringWithFormat: @"Weapon %d", i + 1]];
        [button.title setFontName:@"Chalkduster"];
        [button.title setFontSize:26.0];
        [button setPosition: CGPointMake(button.size.width / 2, (screenSize.height - (button.size.height / 2)) - (i * button.size.height))];
        button.zPosition = 5;
        button.tag = i + 1;
        [button setTouchDownTarget:self action:@selector(buttonSelectAction:)];
        [self.scene addChild: button];
        [self.buttonList addObject: button];
    }
    
    for (int i = 0; i < buttonCount; i++) {
        KHSKButton * button = [[KHSKButton alloc] initWithTextureNormal: buttonTexture selected: buttonSelectedTexture];
        [button.title setText: [NSString stringWithFormat: @"Weapon %d", i + buttonCount]];
        [button.title setFontName:@"Chalkduster"];
        [button.title setFontSize:26.0];
        [button setPosition: CGPointMake(screenSize.width - button.size.width / 2, (screenSize.height - (button.size.height / 2)) - (i * button.size.height))];
        button.zPosition = 5;
        button.tag = i + buttonCount + 1;
        [button setTouchDownTarget:self action:@selector(buttonSelectAction:)];
        [self.scene addChild: button];
        [self.buttonList addObject: button];
    }
}

- (void) buttonSelectAction: (id) sender {
    if ([sender isKindOfClass: [KHSKButton class]]) {
        KHSKButton * button = ((KHSKButton *)sender);
        
        switch (button.tag) {
            case 1:
                self.playerEntity.primaryWeapon.weaponType = WEAPON_TYPE_CIRCULAR;
                break;
            case 2:
                self.playerEntity.primaryWeapon.weaponType = WEAPON_TYPE_ELIPSE;
                break;
            case 3:
                self.playerEntity.primaryWeapon.weaponType = WEAPON_TYPE_LISSAJOUS;
                break;
            case 4:
                self.playerEntity.primaryWeapon.weaponType = WEAPON_TYPE_SPIRAL_SLING;
                break;
            default:
                break;
        }
    }
}

- (void) tabSelectAction: (id) sender {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        // If touch down is within the player
        if ([AppUtils isPointInEntity: location entity: self.playerEntity]) {
            self->isMoving = YES;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (self->isMoving) {
            self.playerEntity.sprite.position = location;
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self->isMoving = NO;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self->isMoving = NO;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self.playerEntity update: currentTime];
}
@end
