//
//  LevelData.h
//  Orbit
//
//  Created by Ken Hung on 4/9/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#ifndef Orbit_LevelData_h
#define Orbit_LevelData_h

typedef enum {
    LEVEL_OBJECT_CIRCLE,
    LEVEL_OBJECT_RECT,
    LEVEL_OBJECT_POLY,
    LEVEL_OBJECT_NONE
} LevelObjectType;

// NSCoding Keys
#define kRectOrigXKey @"LDODimOrigX"
#define kRectOrigYKey @"LDODimOrigY"
#define kRectWidthKey @"LDODimSizeWidth"
#define kRectHeightKey @"LDODimSizeHeight"

#define kLevelObjTypeKey @"LDOType"

// Keys for Level plist
#define kDataKey @"DataNumber"
#define kDataFile @"data.plist"

#define kDataObjectCountKey @"NumberOfObjectsInLevel"

#define kLevelWidthsKey @"LevelWidths"

// Dictionary keys for retrieving data out of LevelFileFormViewController call backs
#define kNewLevelNameKey @"NewLevelName"
#define kNewLevelWidthKey @"NewLevelNumberWidths"
#endif
