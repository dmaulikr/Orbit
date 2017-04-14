//
//  LevelEditor.h
//  Orbit
//
//  Created by Ken Hung on 4/9/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelData.h"

@class LevelFile;
@class LevelObject;

@interface LevelEditor : NSObject

@property (nonatomic, assign) LevelObjectType currentObjectType;
@property (nonatomic, retain) NSMutableArray * levelFilesList; // List of LevelFiles containing LevelObject info

@property (nonatomic, assign) NSInteger currentLevelFileIndex;

- (void) saveCurrentObjectWithRect: (CGRect) rect;
- (void) saveCurrentFile;

- (LevelFile *) getCurrentLevelFile;

- (void) printObjectList;

+ (BOOL) collisionWithObject: (LevelObject *) object againstPoint: (CGPoint) point;
+ (NSMutableArray *) collisionWithObjects: (NSArray *) objects againstPoint: (CGPoint) point;
@end
