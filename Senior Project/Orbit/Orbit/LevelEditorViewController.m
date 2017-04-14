//
//  LevelEditorViewController.m
//  Orbit
//
//  Created by Ken Hung on 4/9/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "LevelEditorViewController.h"
#import "LevelFile.h"
#import "LevelFileBrowserViewController.h"

#define SCROLL_LOCK_TOGGLE_BUTTON_TEXT_ON  @"Disable Scrolling"
#define SCROLL_LOCK_TOGGLE_BUTTON_TEXT_OFF @"Enable Scrolling" 

@implementation LevelEditorViewController
@synthesize canvasScrollView, editorToolbar, scrollLockToggleButton, currentCanvas, levelEditor, fileListPopover, fileBrowseButton, editButton, 
    isEditing, quitButton, coordinateLabel, levelFileBrowserViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.levelEditor = [[LevelEditor alloc] init];
        self.isEditing = NO;
    }
    return self;
}

- (void) saveCurrentObject {
    [self.levelEditor saveCurrentObjectWithRect: self.currentCanvas.currentRect];
    self.levelEditor.currentObjectType = LEVEL_OBJECT_NONE;
    self.currentCanvas.currentType = LEVEL_OBJECT_NONE;
}

- (void) saveCurrentFile {
    [self saveCurrentObject];
    
    [self.levelEditor saveCurrentFile];
}

- (void) browseFileAction: (id) sender {
    if ([self.fileListPopover isPopoverVisible])
        [self.fileListPopover dismissPopoverAnimated: YES];
    else
        [self.fileListPopover presentPopoverFromBarButtonItem: self.fileBrowseButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void) toggleScrollingAction: (id) sender {
    [self.fileListPopover dismissPopoverAnimated: YES];
    self.levelEditor.currentObjectType = LEVEL_OBJECT_NONE;
    self.currentCanvas.currentType = LEVEL_OBJECT_NONE;
    
    if (canvasScrollView.scrollEnabled) {
        [self.scrollLockToggleButton setTitle: SCROLL_LOCK_TOGGLE_BUTTON_TEXT_OFF];
        self.currentCanvas.userInteractionEnabled = YES;
    } else {
        [self.scrollLockToggleButton setTitle: SCROLL_LOCK_TOGGLE_BUTTON_TEXT_ON];
        self.currentCanvas.userInteractionEnabled = NO;
    }
    
    canvasScrollView.scrollEnabled = !canvasScrollView.scrollEnabled;
}

- (void) editAction: (id) sender {
    [self.fileListPopover dismissPopoverAnimated: YES];
    
    [self saveCurrentObject];
    
    self.isEditing = !self.isEditing;
    self.currentCanvas.tapGesture.enabled = self.isEditing;
    self.currentCanvas.currentEditObject = nil;
}

- (void) chooseShapeAction: (id) sender {
    [self.fileListPopover dismissPopoverAnimated: YES];
    
    if ([sender isKindOfClass: [UIBarButtonItem class]]) {
        UIBarButtonItem * button = (UIBarButtonItem *)sender;
        
        [self saveCurrentObject];
        
        switch (button.tag) {
            case 0: // Circle
                self.levelEditor.currentObjectType = LEVEL_OBJECT_CIRCLE;
                self.currentCanvas.currentType = LEVEL_OBJECT_CIRCLE;
                
                break;
            case 1: // Rect
                self.levelEditor.currentObjectType = LEVEL_OBJECT_RECT;
                self.currentCanvas.currentType = LEVEL_OBJECT_RECT;
                
                break;
            case 2: // Polygon
                self.levelEditor.currentObjectType = LEVEL_OBJECT_POLY;
                self.currentCanvas.currentType = LEVEL_OBJECT_POLY;
                
                break;
            default:
                self.levelEditor.currentObjectType = LEVEL_OBJECT_NONE;
                self.currentCanvas.currentType = LEVEL_OBJECT_NONE;
                
                break;
        }
    }
}

- (void) quitAction: (id) sender {
    [self saveCurrentFile];
    
    [self.fileListPopover dismissPopoverAnimated: YES];
    [self dismissModalViewControllerAnimated: YES];
}

- (void) coordinateAction: (id) sender {
   // self.currentCanvas.lastTouchPoint = CGPointMake(0, 0);
   // [self.currentCanvas refreshDisplay];
}

/*
#pragma mark - Action Sheet and Alert View Protocol Functions
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex: buttonIndex] isEqualToString: @"Save"]) {
        [self saveAction: nil];
        [self.levelEditor saveCurrentFile];
        
        // Save and show alert
        self.saveAlertView.message = [NSString stringWithFormat: @"%@ was saved", [[((LevelFile *)[self.levelEditor getCurrentLevelFile]).docPath lastPathComponent] stringByDeletingPathExtension]];
        [self.saveAlertView show];
    } else if ([[actionSheet buttonTitleAtIndex: buttonIndex] isEqualToString: @"Delete"]) {
        // Launch delete alert warning
        self.deleteAlertView.message = [NSString stringWithFormat: @"%@ will be deleted?", [[((LevelFile *)[self.levelEditor getCurrentLevelFile]).docPath lastPathComponent] stringByDeletingPathExtension]];
        [self.deleteAlertView show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Really delete file
    if ([[alertView buttonTitleAtIndex: buttonIndex] isEqualToString: @"Ok"]) {
        [[self.levelEditor getCurrentLevelFile] deleteDoc];
    }
}
*/
#pragma mark LevelPickProtocol
- (void) filePickedAtIndex: (NSInteger) index {
    [self saveCurrentFile];
    
    self.levelEditor.currentLevelFileIndex = index;
    NSLog(@"Current File set to: %@", [[self.levelEditor getCurrentLevelFile].docPath lastPathComponent]);
    [self updateCanvasWidth: [self.levelEditor getCurrentLevelFile].levelWidths];
}

#pragma mark NewLevelFileProtocol
- (void) newLevelFileWithData:(NSDictionary *)fileData {
    if (fileData && [fileData count] == 2) {
        // Create a new Level with the following data
        NSString * fileName = [fileData objectForKey: kNewLevelNameKey];
        NSString * newDocPath;
        
        // input error checking
        if (!fileName || [fileName isEqualToString:@""])
            newDocPath = [LevelPersistanceUtility creatNewFullDocPath];
        else
            newDocPath = [LevelPersistanceUtility creatNewFullDocPathWithFileName: [fileData objectForKey: kNewLevelNameKey]];
        
        LevelFile * newFile = [[LevelFile alloc] initWithDocPath: newDocPath];
        
        NSInteger fileWidthData = [((NSNumber*)[fileData objectForKey: kNewLevelWidthKey]) integerValue];
        NSInteger fileWidth = 5;
        
        // input error checking
        if (fileWidthData && fileWidthData > 0)
            fileWidth = fileWidthData;
            
        newFile.levelWidths = fileWidth;
        [newFile saveData]; // Save the level file
        [self.levelEditor.levelFilesList addObject: newFile];
        
        // Save current file then switch to newly created file
        [self saveCurrentFile];
        self.levelEditor.currentLevelFileIndex = [self.levelEditor.levelFilesList count] - 1;
        [self updateCanvas];
    }
}

- (void) removeLevelFileAtIndex: (NSInteger) index {
    [self saveCurrentFile];
    
    [[self.levelEditor.levelFilesList objectAtIndex: index] deleteDoc]; // remove from disc
    
    if (self.levelEditor.currentLevelFileIndex > index) {
        self.levelEditor.currentLevelFileIndex--;
    } else if (self.levelEditor.currentLevelFileIndex == index) {
        self.levelEditor.currentLevelFileIndex = 0;
    }
    
    [self.levelEditor.levelFilesList removeObjectAtIndex: index];       // remove from list
    [self updateCanvas];
    
    [self.levelFileBrowserViewController refreshTable];
}

- (void) updateCanvas {
    self.currentCanvas.drawList = ((LevelFile *)[self.levelEditor getCurrentLevelFile]).objectList;
    [self.currentCanvas setNeedsDisplay];
}

- (void) updateCanvasWidth: (NSInteger) widths {
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    self.currentCanvas.frame = CGRectMake(0, 0, screenSize.size.height * widths, screenSize.size.width);
    [self.canvasScrollView setContentSize: CGSizeMake(screenSize.size.height * widths, screenSize.size.width)];
    
    [self updateCanvas];
}

#pragma mark - View lifecycle
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.levelFileBrowserViewController = [[LevelFileBrowserViewController alloc] init];
    self.levelFileBrowserViewController.fileList = self.levelEditor.levelFilesList;
    self.levelFileBrowserViewController.delegate = self;
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController: self.levelFileBrowserViewController];
    
    self.fileListPopover = [[UIPopoverController alloc] initWithContentViewController: nav];
    
    [nav release];
    
    CGRect screenSize = [[UIScreen mainScreen] bounds];

    // Do any additional setup after loading the view from its nib.
    self.currentCanvas = [[LevelCanvasView alloc] initWithFrame: CGRectMake(0, 0, 2000, screenSize.size.width)];
    self.currentCanvas.drawList = ((LevelFile *)[self.levelEditor getCurrentLevelFile]).objectList;
    self.currentCanvas.userInteractionEnabled = NO;
    self.currentCanvas.tapGesture.enabled = self.isEditing;
    self.currentCanvas.coordinateLabel = self.coordinateLabel;
    
    [self.canvasScrollView addSubview: self.currentCanvas];
    
    [self.canvasScrollView setContentSize: CGSizeMake(2000, screenSize.size.width)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
}

- (void) dealloc {
    [canvasScrollView release];
    [editorToolbar release];
    [scrollLockToggleButton release];
    [fileBrowseButton release];
    [editButton release];
    [quitButton release];
    [currentCanvas release];
    [levelEditor release];
    [fileListPopover release];
    [coordinateLabel release];
    
    [super dealloc];   
}
@end
