//
//  lastPlayedListViewer.h
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-09.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ShadowedTableView.h"
@interface lastPlayedListViewer : UITableViewController <UITableViewDelegate, UINavigationControllerDelegate> {
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
	IBOutlet UISearchBar *sBar;//search bar
	IBOutlet ShadowedTableView *tableView;
	BOOL searching;
	BOOL letUserSelectRow;
	NSMutableArray *tableData;
	NSMutableArray *searchedSongsData;
}

- (void)updateTableView:(NSNotification *)aNotification;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UISearchBar *sBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) NSMutableArray *searchedSongsData;
@end
