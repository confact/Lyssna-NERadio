//
//  radiostationerTableViewController.h
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-08-20.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ShadowedTableView.h"
@interface radiostationerTableViewController : UITableViewController { 
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
}
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
//- (IBAction) EditTable:(id)sender;
- (IBAction)AddButtonAction:(id)sender;
@end
