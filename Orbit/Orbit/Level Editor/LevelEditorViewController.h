//
//  LevelEditorViewController.h
//  Orbit
//
//  Created by Ken Hung on 4/9/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelCanvasView.h"
#import "LevelEditor.h"
#import "LevelData.h"
#import "LevelEditorProtocols.h"
@class LevelFileBrowserViewController;

@interface LevelEditorViewController : UIViewController <LevelPickProtocol, NewLevelFileProtocol>

@property (nonatomic, retain) IBOutlet UIScrollView * canvasScrollView;
@property (nonatomic, retain) IBOutlet UIToolbar * editorToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * scrollLockToggleButton, * fileBrowseButton, * editButton, *quitButton, *coordinateLabel;
@property (nonatomic, retain) LevelCanvasView * currentCanvas;

@property (nonatomic, retain) LevelEditor * levelEditor;

@property (nonatomic, retain) UIPopoverController * fileListPopover;

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, retain) LevelFileBrowserViewController * levelFileBrowserViewController;

- (IBAction) browseFileAction: (id) sender;
- (IBAction) toggleScrollingAction: (id) sender;
- (IBAction) chooseShapeAction: (id) sender;
- (IBAction) editAction: (id) sender;
- (IBAction) quitAction: (id) sender;
- (IBAction) coordinateAction: (id) sender;

- (void) saveCurrentObject;
- (void) saveCurrentFile;

- (void) updateCanvas;
- (void) updateCanvasWidth: (NSInteger) widths;
@end
