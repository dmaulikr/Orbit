//
//  LevelFileFormViewController.m
//  Orbit
//
//  Created by Ken Hung on 4/30/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "LevelFileFormViewController.h"

@implementation LevelFileFormViewController
@synthesize fileNameTextField, levelWidthTextField, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void) doneAction:(id)sender {
    UIButton * button;
    
    if ([sender isKindOfClass: [UIButton class]]) {
        button = (UIButton*)sender;
        
        // OK
        if (button.tag == 0) {
            // callback with input info
            NSLog(@"Info recieved: %@ %@", self.fileNameTextField.text, self.levelWidthTextField.text);
            if (self.delegate) {
                NSDictionary * dataDictionary = [NSDictionary dictionaryWithObjectsAndKeys: self.fileNameTextField.text, kNewLevelNameKey, [NSNumber numberWithInteger: [self.levelWidthTextField.text integerValue]], kNewLevelWidthKey, nil];
                
                [self.delegate newLevelFileWithData: dataDictionary];
            }
        }
        
        [self dismissViewControllerAnimated: YES completion: nil];
    }
}

- (void) dealloc {
    fileNameTextField = nil;
    levelWidthTextField = nil;
    delegate = nil;
}
@end
