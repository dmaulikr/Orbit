//
//  LevelPersistanceUtility.m
//  Orbit
//
//  Created by Ken Hung on 4/25/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "LevelPersistanceUtility.h"

@implementation LevelPersistanceUtility
// Returns a list of all LevelFiles in the base directory or an empty list even if there is an error.
+ (NSMutableArray *) loadDocs {
    // Get private docs dir
    NSString *documentsDirectory = [LevelPersistanceUtility getLevelFilesDirectory];
    NSLog(@"Loading docs from %@", documentsDirectory);
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return [NSMutableArray array]; // If there's ever an error.. it's not due to a missing directory
        //return nil;
    }
    
    NSLog(@"Objects found from file:");
    // Wrap each file into a LevelFile
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"olf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            NSLog(@"   %@", fullPath);
            LevelFile *doc = [[[LevelFile alloc] initWithDocPath:fullPath] autorelease];
            [retval addObject:doc];
        }
    }
    
    return retval;
}

+ (NSString *) creatNewFullDocPathWithFileName: (NSString *) name {
    // Get private docs dir
    NSString *documentsDirectory = [LevelPersistanceUtility getLevelFilesDirectory];
    // Get available name
    NSString *availableName = [NSString stringWithFormat:@"%@.olf", name];
    
    NSLog(@"New file created: %@", availableName);
    
    return [documentsDirectory stringByAppendingPathComponent:availableName];
}

+ (NSString *) creatNewFullDocPath {
    // Get private docs dir
    NSString *documentsDirectory = [LevelPersistanceUtility getLevelFilesDirectory];
    
    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        // If there's an error, it's not going to be becuase the directory dosen't exist
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }
    
    // Search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"olf" options:NSCaseInsensitiveSearch] == NSOrderedSame) {            
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
            NSLog(@"comparing %d to %d", maxNumber, fileName.intValue);
        }
    }
    
    // Get available name
    // integer in front, intValue/integerValue only scans for ints in beginning of stinrg
    NSString *availableName = [NSString stringWithFormat:@"%d_untitled", maxNumber+1];
    
    return [LevelPersistanceUtility creatNewFullDocPathWithFileName: availableName];
}

// Returns the base path directory to all LevelFiles
+ (NSString *) getLevelFilesDirectory {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex: 0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent: @"Level Files"];
    
    NSError * error;
    [[NSFileManager defaultManager] createDirectoryAtPath: documentsDirectory withIntermediateDirectories: YES attributes:nil error:&error];

    return documentsDirectory;
}
@end
