//
//  TableViewController.h
//  DropIt
//
//  Created by Dean Thibault on 8/18/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *fileNames;

- (IBAction)doEditTable:(id)sender;

- (void) loadData;

@end
