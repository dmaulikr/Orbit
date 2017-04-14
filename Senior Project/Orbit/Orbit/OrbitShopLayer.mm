//
//  OrbitShopLayer.m
//  Orbit
//
//  Created by Ken Hung on 9/5/11.
//  Copyright 2011 Cal Poly - SLO. All rights reserved.
//

#import "OrbitShopLayer.h"
#import "HelloWorldLayer.h"

@implementation OrbitShopLayer
@synthesize rootViewController;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	OrbitShopLayer *layer = [OrbitShopLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (CCScene *) sceneWithRootRef: (UIViewController *) viewController {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	OrbitShopLayer *layer = [OrbitShopLayer node];
    // Set root view controller for editor
    layer.rootViewController = viewController;
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    if ((self = [super init])) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCLabelTTF * label = [CCLabelTTF labelWithString: @"Not Implemented Yet!" fontName: @"Arial" fontSize:28];
        [label setColor:ccc3(255, 150, 150)];
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + 200);
        [self addChild: label z: 1];
        
        CCMenuItem *menuItem1 = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(onPlay:)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuItem1, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

- (void)onPlay:(id)sender
{
    NSLog(@"on play");
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer sceneWithLevel:nil rootRef:self.rootViewController]];
}
@end
