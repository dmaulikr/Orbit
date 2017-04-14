//
//  LevelEditor.m
//  Orbit
//
//  Created by Ken Hung on 4/9/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "LevelEditor.h"
#import "LevelObject.h"
#import "LevelPersistanceUtility.h"

@implementation LevelEditor
@synthesize currentObjectType, levelFilesList, currentLevelFileIndex;

- (id) init {
    if (self = [super init] ) {
        self.currentObjectType = LEVEL_OBJECT_NONE;
        self.currentLevelFileIndex = 0;
        self.levelFilesList = [LevelPersistanceUtility loadDocs];
        
        // Testing
    /*  self.currentObjectType = LEVEL_OBJECT_CIRCLE;
        [self saveCurrentObjectWithRect: CGRectMake(0, 0, 50, 50)];
        [self saveCurrentObjectWithRect: CGRectMake(100, 100, 50, 50)];
        [self saveCurrentObjectWithRect: CGRectMake(300, 150, 50, 50)];
        [self saveCurrentObjectWithRect: CGRectMake(600, 400, 80, 80)];
        
        self.currentObjectType = LEVEL_OBJECT_RECT;
        [self saveCurrentObjectWithRect: CGRectMake(900, 340, 50, 50)];
        [self saveCurrentObjectWithRect: CGRectMake(800, 200, 80, 80)];
        self.currentObjectType = LEVEL_OBJECT_NONE;
    */
    }
    
    return self;
}

// Add object to list
- (void) saveCurrentObjectWithRect: (CGRect) rect {
    if (self.currentObjectType != LEVEL_OBJECT_NONE) // Also ensures no double saving the same object
        [[self getCurrentLevelFile].objectList addObject: [[LevelObject alloc] initWithType: self.currentObjectType andDimension: rect]];
}

// Write list of objects to file
- (void) saveCurrentFile {
    [self printObjectList];
    
    [(LevelFile*)[self getCurrentLevelFile] saveData];
}

- (LevelFile *) getCurrentLevelFile {
    if (self.levelFilesList.count == 0 ) {
        // Add a new file if there are no saved files
        [self.levelFilesList addObject: [[LevelFile alloc] init]];
    }
    
    return (LevelFile*)[self.levelFilesList objectAtIndex: self.currentLevelFileIndex];
}

#pragma mark Debug Methods
- (void) printObjectList {
    NSLog(@"********** Level Object List **********");
    for (LevelObject * obj in [self getCurrentLevelFile].objectList) {
        NSLog(@"%@", [obj description]);
    }
}


+ (NSMutableArray *) collisionWithObjects: (NSArray *) objects againstPoint: (CGPoint) point {
    NSMutableArray * hitList = [[NSMutableArray alloc] init];
    
    for (LevelObject * obj in objects) {
        if ([self collisionWithObject: obj againstPoint: point]) {
            [hitList addObject: obj];
        }
    }
    
    return hitList;
}

+ (BOOL) collisionWithObject: (LevelObject *) object againstPoint: (CGPoint) point {
    CGRect rect = object.objectDimension;
    float xRadius = rect.size.width / 2;
    float yRadius = rect.size.height / 2;
    float xOrigShifted = (rect.origin.x + xRadius);
    float yOrigShifted = (rect.origin.y + yRadius);
    
    // Note: CGRect origin is at top left
    if (object.objectType == LEVEL_OBJECT_CIRCLE) {
        float xDist, yDist, distance;
        
        // Point to Circle Test
        xDist = point.x - xOrigShifted;
        yDist = point.y - yOrigShifted;
        distance = sqrtf(xDist * xDist + yDist * yDist);
        
        if (distance <= MAX(xRadius, yRadius)) {
            return YES;
        }
    } else if (object.objectType == LEVEL_OBJECT_RECT) {
        float xMin = xOrigShifted - xRadius;
        float xMax = xOrigShifted + xRadius;
        float yMin = yOrigShifted - yRadius;
        float yMax = yOrigShifted + yRadius;
        
        // Point to Box Test
        if (point.x <= xMax && point.x >= xMin && point.y <= yMax && point.y >= yMin) {
            return YES;
        }
    }
    
    return NO;
}

- (void) dealloc {
    levelFilesList = nil;
}

@end
