//
//  MenuLayer.m
//  Orbit
//
//  Created by Ken Hung on 1/12/12.
//  Copyright 2012 Cal Poly - SLO. All rights reserved.
//

#import "MenuLayer.h"
#import "HelloWorldLayer.h"
#import "OrbitShopLayer.h"
#import "LevelEditorViewController.h"
#import "LevelFileBrowserViewController.h"
#import "LevelPersistanceUtility.h"

@implementation MenuLayer
@synthesize rootViewController;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+ (CCScene *) sceneWithRootRef: (UIViewController *) viewController {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
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
        NSInteger BASE_OFFSET = 100;
        
        // Demo Instructions
        CCLabelTTF * label = [CCLabelTTF labelWithString: @"Demo Information" fontName: @"Arial" fontSize:28];
        [label setColor:ccc3(255, 150, 150)];
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + 200 + BASE_OFFSET);
        [self addChild: label z: 1];
        
        label = [CCLabelTTF labelWithString: @"- You can move your character (the red circle) with your finger." fontName: @"Arial" fontSize:22];
        [label setColor:ccc3(255, 255, 255)];
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + 175 + BASE_OFFSET);
        [self addChild: label z: 1];
        
        label = [CCLabelTTF labelWithString: @"- Tap with 1 finger to increase weapon speed (Costs 200 score)" fontName: @"Arial" fontSize:22];
        [label setColor:ccc3(255, 255, 255)];
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + 150 + BASE_OFFSET);
        [self addChild: label z: 1];
        
        label = [CCLabelTTF labelWithString: @"- Tap with 2 fingers to increase weapon damage (Costs 300 score)" fontName: @"Arial" fontSize:22];
        [label setColor:ccc3(255, 255, 255)];
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + 125 + BASE_OFFSET);
        [self addChild: label z: 1];
        
        label = [CCLabelTTF labelWithString: @"- The gaol is to reach a target score that will be located at the top left of the screen." fontName: @"Arial" fontSize:22];
        [label setColor:ccc3(255, 255, 255)];
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + 100 + BASE_OFFSET);
        [self addChild: label z: 1];
        
        label = [CCLabelTTF labelWithString: @"and defeat the \'boss\' at the end." fontName: @"Arial" fontSize:22];
        [label setColor:ccc3(255, 255, 255)];
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + 75 + BASE_OFFSET);
        [self addChild: label z: 1];
        
        label = [CCLabelTTF labelWithString: @"NOTE: You only have 1 life, but you may retry as many times as you like." fontName: @"Arial" fontSize:22];
        [label setColor:ccc3(255, 255, 255)];
        label.position = ccp(screenSize.width / 2, screenSize.height / 2 + 50 + BASE_OFFSET);
        [self addChild: label z: 1];
        
        
        CCMenuItemFont * menuItemFontPlay = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(onMenuItemTouched:)];
        menuItemFontPlay.tag = 1;
        CCMenuItem * menuItemPlay = menuItemFontPlay;
        
        CCMenuItemFont * menuItemFontShop = [CCMenuItemFont itemFromString:@"Shop" target:self selector:@selector(onMenuItemTouched:)];
        menuItemFontShop.tag = 2;
        CCMenuItem * menuItemShop = menuItemFontShop;
        
        CCMenuItemFont * menuItemFontEditor = [CCMenuItemFont itemFromString:@"Editor" target:self selector:@selector(onMenuItemTouched:)];
        menuItemFontEditor.tag = 3;
        CCMenuItem * menuItemEditor = menuItemFontEditor;
        
        CCMenuItemFont * menuItemFontPickLevel = [CCMenuItemFont itemFromString:@"Select Level" target:self selector:@selector(onMenuItemTouched:)];
        menuItemFontPickLevel.tag = 4;
        CCMenuItem * menuItemPickLevel = menuItemFontPickLevel;
        
        CCMenu *menu = [CCMenu menuWithItems:menuItemPlay, menuItemShop, menuItemEditor, menuItemPickLevel, nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    
    return self;
}

- (void)onMenuItemTouched:(id)sender;
{
    NSLog(@"on play %@", [sender description]);
    if ([sender isKindOfClass: [CCMenuItemFont class]]) {
        CCMenuItemFont * menuItem = (CCMenuItemFont *)sender;
        
        if (menuItem.tag == 1) {
            [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer sceneWithLevel: nil rootRef: self.rootViewController]];   
        } else if (menuItem.tag == 2) {
            [[CCDirector sharedDirector] replaceScene:[OrbitShopLayer sceneWithRootRef: self.rootViewController]];  
        } else if (menuItem.tag == 3) {
            LevelEditorViewController * editor = [[LevelEditorViewController alloc] initWithNibName: @"LevelEditorViewController" bundle: nil];     
            
            // [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
            editor.modalPresentationStyle = UIModalPresentationFullScreen; 
            editor.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            
            [self.rootViewController presentModalViewController: editor animated: YES];
            
            [editor release];
        } else if (menuItem.tag == 4) {
            LevelFileBrowserViewController * browserVC = [[LevelFileBrowserViewController alloc] init];
            browserVC.fileList = [LevelPersistanceUtility loadDocs];
            browserVC.delegate = self;
            
            UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:browserVC];
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
            [self.rootViewController presentModalViewController: navController animated: YES];
            
            [browserVC release];
            [navController release];
        }   
    }
}

#pragma mark LevelPickProtocol
- (void) filePickedAtIndex: (NSInteger) index {
    LevelFile * file = [[LevelPersistanceUtility loadDocs] objectAtIndex: index];
    
    NSLog(@"%@ picked", file.docPath);
    
    [self.rootViewController dismissModalViewControllerAnimated: YES];
 
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer sceneWithLevel: file rootRef: self.rootViewController]];   
}

- (void) newLevelFileWithData:(NSDictionary *)fileData {
    
}
@end
