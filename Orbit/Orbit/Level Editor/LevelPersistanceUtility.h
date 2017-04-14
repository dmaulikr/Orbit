//
//  LevelPersistanceUtility.h
//  Orbit
//
//  Created by Ken Hung on 4/25/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelFile.h"

@interface LevelPersistanceUtility : NSObject

+ (NSMutableArray *) loadDocs;

// Usefull for creating new LevelFiles with unspecified names
// Pass in file name, NOT relative or full path
+ (NSString *) creatNewFullDocPathWithFileName: (NSString *) name;
+ (NSString *) creatNewFullDocPath;

+ (NSString *) getLevelFilesDirectory;
@end
