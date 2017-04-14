//
//  LevelFileFormViewController.h
//  Orbit
//
//  Created by Ken Hung on 4/30/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelFileBrowserViewController.h"
#import "LevelData.h"

@interface LevelFileFormViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField * fileNameTextField, * levelWidthTextField;
@property (nonatomic, assign) id<NewLevelFileProtocol> delegate;

- (IBAction) doneAction: (id)sender;
@end
