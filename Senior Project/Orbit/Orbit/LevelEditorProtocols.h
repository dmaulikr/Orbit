//
//  LevelEditorProtocols.h
//  Orbit
//
//  Created by Ken Hung on 5/1/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#ifndef Orbit_LevelEditorProtocols_h
#define Orbit_LevelEditorProtocols_h

// Used to send a picked file index back to the Model.
@protocol LevelPickProtocol
    @required
        -(void) filePickedAtIndex: (NSInteger) index;
@end

// Used to send new Level File info. back through a view chain
@protocol NewLevelFileProtocol
    @required
        - (void) newLevelFileWithData: (NSDictionary *) fileData;

    @optional
        - (void) removeLevelFileAtIndex: (NSInteger) index;
@end
#endif
