//
//  LevelFile.m
//  Orbit
//
//  Created by Ken Hung on 4/24/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "LevelFile.h"
#import "LevelData.h"
#import "LevelObject.h"
#import "LevelPersistanceUtility.h"

@implementation LevelFile
@synthesize docPath = docPath_, objectList, levelWidths, currentObjectIndex;

- (id) init {
    if (self = [self initWithDocPath: nil]) {
    }
    
    return self;
}

// Dont need to make a new initializer for creating a new file. 
// Instead create a new docPath with desired filename and pass it in this initializer to create it.
- (id) initWithDocPath: (NSString *)docPath {
    if (self = [super init]) {
        self.objectList = [[NSMutableArray alloc] init];
        self.levelWidths = 5;
        self.currentObjectIndex = 0;
        
        if (docPath)
            docPath_ = [docPath copy];
        
        [self createNewFileDirectory];
        [self loadData];
    }
    
    return self;
}

// Create a new LevelFile with docPath if one dosen't exist already. Check Return value for success.
- (BOOL) createNewFileDirectory {
    if (docPath_ == nil) {
        self.docPath = [LevelPersistanceUtility creatNewFullDocPath];
    }
    
    NSError * error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath: docPath_ withIntermediateDirectories: YES attributes: nil error: &error];
 
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    
    return success;
}

- (BOOL) loadData {
    NSLog(@"Loading Data from: %@", self.docPath);
    
    // full path to plist containing CGRect data
    NSString * dataPath = [docPath_ stringByAppendingPathComponent: kDataFile];
    NSData * codedData = [[[NSData alloc] initWithContentsOfFile: dataPath] autorelease];
    
    if (codedData == nil) {
        return NO;
    }
    
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData: codedData];
    self.levelWidths = [unarchiver decodeIntegerForKey: kLevelWidthsKey];
    NSInteger numObjects = [unarchiver decodeIntegerForKey: kDataObjectCountKey];
    
    // dynamic keys
    for (int i = 1; i <= numObjects; i++) {
        [self.objectList addObject: [unarchiver decodeObjectForKey: [NSString stringWithFormat: @"%@%d", kDataKey, i]]];
    }
    
    [unarchiver finishDecoding];
    [unarchiver release];
    
    return YES;
}

- (BOOL) saveData {
    NSLog(@"Saving Data to: %@", self.docPath);
    
    NSString * dataPath = [docPath_ stringByAppendingPathComponent: kDataFile];
    NSMutableData * data = [[NSMutableData alloc] init];
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData: data];
    
    [archiver encodeInteger: self.levelWidths forKey: kLevelWidthsKey];
    [archiver encodeInteger: self.objectList.count forKey: kDataObjectCountKey];
    
    int i = 1;
    // dynamic keys
    for (LevelObject * object in self.objectList) {
        [archiver encodeObject: object forKey: [NSString stringWithFormat: @"%@%d", kDataKey, i]];
        i++;
    }
    
    [archiver finishEncoding];
    BOOL success = [data writeToFile: dataPath atomically: YES];
    [archiver release];
    [data release];
    
    return success;
}

- (BOOL) deleteDoc {
    NSLog(@"Deleting file at: %@", self.docPath);
    
    NSError * error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath: docPath_ error: &error];
    
    if (!success) {
        NSLog(@"Error removing document path: %@", [error localizedDescription]);
    }
    
    return success;
}

- (void) dealloc {
    [docPath_ release];
    docPath_ = nil;
    [objectList release];
    
    [super dealloc];
}
@end
