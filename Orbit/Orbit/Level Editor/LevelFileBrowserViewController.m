//
//  LevelFileBrowserViewController.m
//  Orbit
//
//  Created by Ken Hung on 4/26/12.
//  Copyright (c) 2012 Cal Poly - SLO. All rights reserved.
//

#import "LevelFileBrowserViewController.h"
#import "LevelPersistanceUtility.h"
#import "LevelFileFormViewController.h"

@implementation LevelFileBrowserViewController
@synthesize delegate, fileList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.fileList = [[NSMutableArray alloc] init];
        self.delegate = nil;
    }
    return self;
}

#pragma mark NewLevelFileProtocol
- (void) newLevelFileWithData:(NSDictionary *)fileData {
    if (fileData && [fileData count] == 2) {
        if (self.delegate) {
            [self.delegate newLevelFileWithData: fileData];
            [self refreshTable];
        }
    }
}

- (void) addAction: (id) sender {
    LevelFileFormViewController * lffvc = [[LevelFileFormViewController alloc] initWithNibName: @"LevelFileFormViewController" bundle:nil];
    lffvc.delegate = self;
    lffvc.modalPresentationStyle = UIModalPresentationFormSheet;
    lffvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:lffvc animated: YES completion: nil];
}

- (void) quitAction: (id) sender {
    [self dismissViewControllerAnimated: YES completion:nil];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Files";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    if (self.delegate) {
        if ([(NSObject*)self.delegate isKindOfClass: [LevelEditorViewController class]]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addAction:)];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(quitAction:)];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.fileList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSLog(@"%d %d", self.fileList.count, indexPath.row);
    cell.textLabel.text = [[((LevelFile*)[self.fileList objectAtIndex: indexPath.row]).docPath lastPathComponent] stringByDeletingPathExtension];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
   //   [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (self.delegate && [(NSObject *)self.delegate respondsToSelector: @selector(removeLevelFileAtIndex:)]) {
            [self.delegate removeLevelFileAtIndex: indexPath.row];
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        // Show dialog for new file
        // NSString * path = [LevelPersistanceUtility creatNewFullDocPathWithFileName: @""];
        // [self.fileList addObject: [[LevelFile alloc] initWithDocPath: path]];
    }
    
    [self refreshTable];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    if (self.delegate) {
        [self.delegate filePickedAtIndex: indexPath.row];
    }
}

- (void) refreshTable {
    [self.tableView reloadData];
}

- (void) dealloc {
    fileList = nil;
}
@end
