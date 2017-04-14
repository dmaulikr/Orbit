//
//  LevelFileBrowserViewController.h
//  Orbit
//
//  Created by Ken Hung on 4/26/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelEditor.h"
#import "LevelEditorViewController.h"
#import "LevelEditorProtocols.h"

@interface LevelFileBrowserViewController : UITableViewController <NewLevelFileProtocol>

@property (nonatomic, assign) id<LevelPickProtocol, NewLevelFileProtocol> delegate; // callback for chosen index
@property (nonatomic, retain) NSMutableArray * fileList; // Set this to the LevelFile array in LevelEditor

- (void) addAction: (id) sender;
- (void) quitAction: (id) sender;

- (void) refreshTable;
@end
