//
//  TableViewController.m
//  DropIt
//
//  Created by Dean Thibault on 8/18/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize fileNames;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[self loadData];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUpdateNotification:) name:@"DataUpdateNotification" object:nil];

}

- (void) receiveUpdateNotification:(NSNotification *) notification {
	[self loadData];
	[self.tableView reloadData];
}

- (void) loadData
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pathExtension == %@", @"dropittxt"];
	NSArray *matchingPaths = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil] filteredArrayUsingPredicate:predicate];
	
	fileNames = [NSMutableArray array];
	for (NSString *fname in matchingPaths) {
	    [fileNames addObject:[fname lastPathComponent]];
	}
}

-(void) viewDidAppear:(BOOL)animated
{
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.fileNames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"filenamecell" forIndexPath:indexPath];
    
    [cell.textLabel setText:[fileNames objectAtIndex:indexPath.row]];
    
    return cell;
}

- (IBAction)doEditTable:(id)sender
{
	self.tableView.editing = YES;
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doDoneEditTable:)];
	self.navigationItem.rightBarButtonItem = doneButton;

}

- (IBAction)doDoneEditTable:(id)sender
{
	self.tableView.editing = NO;
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(doEditTable:)];
	self.navigationItem.rightBarButtonItem = editButton;

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		NSString *fname = [fileNames objectAtIndex:indexPath.row];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSFileManager * fm = [NSFileManager defaultManager];
		// create the url to save the file to with document directory and given file name
		NSURL* filePath = [NSURL fileURLWithPath:documentsDirectory];
		NSURL * localUrl = [filePath URLByAppendingPathComponent:fname];
		NSError * error;
		// move the temporary file to the documents directory
		BOOL ret = [fm removeItemAtURL:localUrl error:&error];
		
		if (!ret) {
			NSLog(@"could not remove file from %@: %@", localUrl, error);
		}
		
		
		
		[self.fileNames removeObjectAtIndex:indexPath.row];
		
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *fname = [fileNames objectAtIndex:indexPath.row];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	// create the url to save the file to with document directory and given file name
	NSURL* filePath = [NSURL fileURLWithPath:documentsDirectory];
	NSURL * localUrl = [filePath URLByAppendingPathComponent:fname];
    NSArray *objectsToShare = @[localUrl];

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    // Exclude all activities except AirDrop.
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    // Present the controller
    [self presentViewController:controller animated:YES completion:nil];

}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
