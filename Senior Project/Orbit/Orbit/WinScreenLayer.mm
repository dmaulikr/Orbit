//
//  WinScreenLayer.m
//  Orbit
//
//  Created by Ken Hung on 3/16/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "WinScreenLayer.h"
#import "HelloWorldLayer.h"
#import "OrbitShopLayer.h"

@implementation WinScreenLayer
@synthesize rootViewController;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WinScreenLayer *layer = [WinScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (CCScene *) sceneWithRootRef: (UIViewController *) viewController {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WinScreenLayer *layer = [WinScreenLayer node];
    // Set root view controller for editor
    layer.rootViewController = viewController;
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if (self = [super init]) {
        self.isTouchEnabled = YES;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCLabelTTF * label = [CCLabelTTF labelWithString: @"Demo level complete!" fontName: @"Arial" fontSize:22];
        [label setColor:ccc3(255, 245, 230)];
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + 100);
        [self addChild: label z: 1];
        
        CCMenuItemFont * menuItemFontPlay = [CCMenuItemFont itemFromString:@"Play Again" target:self selector:@selector(onMenuItemTouched:)];
        menuItemFontPlay.tag = 1;
        CCMenuItem * menuItemPlay = menuItemFontPlay;
        
        CCMenuItemFont * menuItemFontShop = [CCMenuItemFont itemFromString:@"Quit" target:self selector:@selector(onMenuItemTouched:)];
        menuItemFontShop.tag = 2;
        CCMenuItem * menuItemShop = menuItemFontShop;
        
        CCMenu *menu = [CCMenu menuWithItems:menuItemPlay, menuItemShop, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    
    return self;
}

- (void)onMenuItemTouched:(id)sender;
{
 //   NSLog(@"on play %@", [sender description]);
    if ([sender isKindOfClass: [CCMenuItemFont class]]) {
        CCMenuItemFont * menuItem = (CCMenuItemFont *)sender;
        
        switch (menuItem.tag) {
            case 1:
                [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer sceneWithLevel:nil rootRef:self.rootViewController]];       
                break;
            case 2:
                exit(0); 
                break;
            default:
                break;
        }
    }
}
@end
