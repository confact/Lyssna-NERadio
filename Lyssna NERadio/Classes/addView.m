//
//  addView.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-06.
//  Copyright (c) 2010 DevSnack Inc. All rights reserved.
//

#import "addView.h"
#import "RadioLyssnarenAppDelegate.h"
#import "radioStation.h"
#import <CoreData/CoreData.h>

@implementation addView
@synthesize radioname, radioaddress;
@synthesize addButton;
@synthesize cancelButton;
@synthesize urladdress;
@synthesize name;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize radio;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//[cancelButton setTitle:NSLocalizedString(@"Cancel", @"LyssnaAddCancel")];
	//[addButton setTitle:NSLocalizedString(@"Change", @"LyssnaAddChange")];
	//urladdress.text = NSLocalizedString(@"URL", @"LyssnaAddURLAddress");
	//name.text = NSLocalizedString(@"Name", @"LyssnaAddName");
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated {
	[self.radioname setText:[radio name]];
	[self.radioaddress setText:[radio url]];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(IBAction) editStation: (id) sender {
	// Step 1: Select Data
	NSManagedObjectContext *edit = [(RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"radioStation" 
											  inManagedObjectContext:edit];
    [fetchRequest setEntity:entity];
	
    NSError *error;
    NSArray *items = [edit
					  executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
	
    // Step 2: Update Object
    for (radioStation *station in items) {
        if(station == self.radio)
		{
			[station setName:radioname.text];
			[station setUrl:radioaddress.text];
		}
    }
	

    if (![edit save:&error]) {
        NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
        exit(-1);
    }
	
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction) closekeyboard:(id)sender
{
    [self.inputView release];
}
-(IBAction) cancel:(id)sender
{
   [self dismissModalViewControllerAnimated:YES]; 
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[managedObjectContext release];
    [radioname release];
    [radioaddress release];
    [addButton release];
    [radio release];
    [super dealloc];
}


@end
