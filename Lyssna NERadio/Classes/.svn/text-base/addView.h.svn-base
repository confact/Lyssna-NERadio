//
//  addView.h
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-06.
//  Copyright (c) 2010 DevSnack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "radioStation.h"

@interface addView : UIViewController {
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
	
	radioStation *radio;
	
    IBOutlet UITextField *radioname;
    IBOutlet UITextField *radioaddress;
    IBOutlet UIButton *addButton;
	IBOutlet UIButton *cancelButton;
	IBOutlet UILabel *urladdress;
	IBOutlet UILabel *name;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) radioStation *radio;

-(IBAction) editStation:(id)sender;
-(IBAction) closekeyboard:(id)sender;
-(IBAction) cancel:(id)sender;

@property(nonatomic, retain) IBOutlet UITextField *radioname;
@property(nonatomic, retain) IBOutlet UITextField *radioaddress;
@property(nonatomic, retain) IBOutlet UIButton *addButton;
@property(nonatomic, retain) IBOutlet UIButton *cancelButton;
@property(nonatomic, retain) IBOutlet UILabel *urladdress;
@property(nonatomic, retain) IBOutlet UILabel *name;

@end
