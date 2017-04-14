//
//  HelloWorldLayer.h
//  Orbit
//
//  Created by Ken Hung on 8/20/11.
//  Copyright Cal Poly - SLO 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"
#import "PlayerEntity.h"
#import "WeaponEntity.h"

#import "GridLayer.h"

#import "GameState.h"
#import "HUD.h"
#import "Animation.h"
#import "LevelFile.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    // ---
    BOOL isMoving;
    
    MyContactListener * listener;
}

@property (nonatomic, retain) NSMutableArray * entities;
@property (nonatomic, retain) PlayerEntity * playerEntity;

@property (nonatomic, retain) GridLayer * pathGrid;

@property (nonatomic, retain) GameState * gameState;
@property (nonatomic, retain) HUD * playerHUD;

@property (nonatomic, retain) LevelFile * levelFile;

@property (nonatomic, assign) UIViewController * rootViewController;

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) scene;
+ (CCScene *) sceneWithLevel: (LevelFile *) levelFile rootRef: (UIViewController *) viewController;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;

-(void) initHUD;
-(void) initAnimator;
-(void) initGameComponents;

-(void) initPlayer;
-(void) initSquare;
-(void) initTriangle;
-(void) initLine;
-(void) initPlus;
-(void) initCircle;
-(void) initPathed;

- (void) stopSpawning;
- (void) spawnBoss;

- (void) updateScrollingNodes;

- (void) updateSpriteToBox:(ccTime)dt;

- (void) onMenu:(id) sender;

- (void) cleanupWeaponRecurse: (Entity *) entity;

- (void) addBoxesWithLevelFile: (LevelFile *) levelFile;
- (void) addRandomPolygons:(int)num;
- (void) addRandomBoxes:(int)num;
- (void) addPolygonAtPoint:(CGPoint)p;
- (void) addBoxAtPoint:(CGPoint)p size:(CGPoint)s;

- (void) animateParticleDeathAtPosition: (CGPoint) position;

//- (void) DrawShape: (b2Fixture*) fixture, const b2Transform& xf, const b2Color& color;
@end
