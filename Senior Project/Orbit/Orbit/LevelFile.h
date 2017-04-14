//
//  LevelFile.h
//  Orbit
//
//  Created by Ken Hung on 4/24/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelPersistanceUtility.h"

@interface LevelFile : NSObject {
    NSString * docPath_;
}

@property (copy) NSString * docPath;
@property (nonatomic, retain) NSMutableArray * objectList; // List of LevelObjects
@property (nonatomic, assign) NSInteger levelWidths, currentObjectIndex;

- (id) init; // Don't use thiss
- (id) initWithDocPath: (NSString *) docPath;

- (BOOL) createNewFileDirectory;

- (BOOL) loadData;
- (BOOL) saveData;

- (BOOL) deleteDoc;
@end
