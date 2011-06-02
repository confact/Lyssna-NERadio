//
//  radiostationerTableViewController.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-08-20.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import "radiostationerTableViewController.h"
#import "Lyssna_NERadioAppDelegate.h"
#import "DetailView.h"
#import "radioStation.h"
#import "stationCell.h"
#import "addView.h"

@implementation radiostationerTableViewController
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize tableView;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = NSLocalizedString(@"Listen", @"LyssnaTitle");
    /*
	
	appDelegate.stationer = [[NSMutableArray alloc] init];
	
	radioStation *radio1 = [[radioStation alloc] init];
	radioStation *radio2 = [[radioStation alloc] init];
	radioStation *radio3 = [[radioStation alloc] init];
	radio1.url = @""http://bigbrother.dinmamma.be:8000;
	radio1.name = @"NERadio Sweden";
	radio2.url = @"http://89.145.98.92:8000";
	radio2.name = @"PowerFM.se";
	radio3.url = @"http://sc5.radioseven.se:8002";
	radio3.name = @"RadioSeven";
	
	[appDelegate.stationer addObject:radio1];
	[appDelegate.stationer addObject:radio2];
	[appDelegate.stationer addObject:radio3];
     */
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
	self.tableView.backgroundColor = [UIColor colorWithRed:206.0/255.0
					green:218.0/255.0
					 blue:226.0/255.0
					alpha:1];
    self.tableView.allowsSelectionDuringEditing = YES;
	
}

- (void)nowPlayingPush
{
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:appDelegate.detailView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.detailView != nil && [appDelegate.streamer isPlaying])
        {
            if(self.navigationItem.rightBarButtonItem == nil) {
                UIBarButtonItem* nowButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Now Playing", @"LyssnaNowPlaying") style:UIBarButtonItemStyleDone target:self action:@selector(nowPlayingPush)];
                [self.navigationItem setRightBarButtonItem:nowButton animated:YES];
            }
        }
        else {
            if(self.navigationItem.rightBarButtonItem != nil)
            {
                [self.navigationItem setRightBarButtonItem:nil animated:YES];
                //appDelegate.detailView.streamURL = nil;
                appDelegate.detailView = nil;
            }
        }
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}



#pragma mark -
#pragma mark Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    int count = [appDelegate.stationer count];
    if(self.editing) count++;
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    stationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[stationCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

    
    if(indexPath.row == ([appDelegate.stationer count]) && self.editing)
    {
        cell.title.text = @"Lägg till";
        return cell;
    }
    radioStation *radio = [appDelegate.stationer objectAtIndex:indexPath.row];
    
    cell.title.text = [radio name];
	//[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton]; 
	//cell.accessoryView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellbg.png"]];
	/*
    UIImage *backgroundImage = [UIImage imageNamed:@"cellbg.png"];
	UIImageView *bgView = [[UIImageView alloc] initWithFrame:cell.backgroundView.frame];
	bgView.image = backgroundImage;
	[cell setBackgroundView: bgView];
	[bgView release];
	
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor colorWithRed:36.0/255.0
											   green:46.0/255.0
												blue:52.0/255.0
											   alpha:1];
	//cell.editingAccessoryView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellbg.png"]];
	 */
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;//Height for the cells
}

- (IBAction)AddButtonAction:(id)sender
{
	Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *moc = [(Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	radioStation *failedBankInfo = (radioStation *)[NSEntityDescription
									insertNewObjectForEntityForName:@"radioStation" 
									inManagedObjectContext:moc];
	failedBankInfo.name = @"Untitled radio";
	failedBankInfo.url = @"http://";
	NSError *error;
	if (![moc save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
	
	[appDelegate.stationer addObject:failedBankInfo];
    [self.tableView reloadData];
}

- (IBAction)DeleteButtonAction:(id)sender
{
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.stationer removeLastObject];
    
    
    [self.tableView reloadData];
}
- (void)doneAction {
    //RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate.stationer makeObjectsPerformSelector:@selector(saveAllData)];
	
	[self.tableView reloadData];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
			NSManagedObjectContext *delete = [(Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
            radioStation *deleter = [appDelegate.stationer objectAtIndex:indexPath.row];
			[delete deleteObject:deleter];
			
            [appDelegate.stationer removeObjectAtIndex:indexPath.row];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
			[self.tableView reloadData];
        } else if (editingStyle == UITableViewCellEditingStyleInsert)
        {
        
        } 
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if(self.editing)
    {
        
        [super setEditing:NO animated:NO];
        
        [self.tableView setEditing:NO animated:NO];
		
		self.tableView.backgroundColor = nil;
		
		self.tableView.backgroundColor = [UIColor colorWithRed:206.0/255.0
														 green:218.0/255.0
														  blue:226.0/255.0
														 alpha:1];
		
        [self.tableView reloadData];
        
        [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Edit", @"LyssnaTableEdit")];
        
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        
        [super setEditing:YES animated:YES];
        
        [self.tableView setEditing:YES animated:YES];
		
		//self.tableView.backgroundColor = nil;
        
		//self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellbg.png"]];
		
        
        [self.tableView reloadData];
        [self.navigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"Done", @"LyssnaTableDone")];
        
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        //RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
        //[appDelegate.stationer makeObjectsPerformSelector:@selector(saveAllData)];
		
        
    }
	
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    radioStation *item = [[appDelegate.stationer objectAtIndex:fromIndexPath.row] retain];
    
    [appDelegate.stationer removeObject:item];
    
    [appDelegate.stationer insertObject:item atIndex:toIndexPath.row];
    
    [item release];
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL isOkey = NO;
    if(indexPath.row == [appDelegate.stationer count])
    {
        isOkey = NO;  
    }
    return isOkey;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(indexPath.row < [appDelegate.stationer count] && !self.editing)
    {
    // Navigation logic may go here. Create and push another view controller.
        DetailView *myDetViewCont;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        if(appDelegate.detailView == nil) {
            myDetViewCont = [[DetailView alloc] initWithNibName:@"DetailView" bundle:nil];
            // creating new detail view controller instance  
            appDelegate.detailView = myDetViewCont;
            [myDetViewCont release];
        }
    }
    else {
        if(appDelegate.detailView == nil) {
            myDetViewCont = [[DetailView alloc] initWithNibName:@"DetailViewipad" bundle:nil];
            // creating new detail view controller instance  
            appDelegate.detailView = myDetViewCont;
            [myDetViewCont release];
        }
    }
        radioStation *radio = [appDelegate.stationer objectAtIndex:indexPath.row];
            // ...
            // Pass the selected object to the new view controller.
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [self.navigationController  pushViewController:appDelegate.detailView animated:YES];
                if(appDelegate.detailView.streamURL != radio.url && radio.url != @"" && radio.url != @"http://")
                {
                    appDelegate.detailView.streamURL = [radio url];
                    [appDelegate.detailView.stationName setText:[radio name]];
                    [appDelegate.detailView setTitle:[radio name]];
                    [appDelegate.detailView.songtitle setText:@""];
                    [appDelegate.detailView.songartist setText:@""];
                    radioStation *radio = [appDelegate.stationer objectAtIndex:indexPath.row];
                    appDelegate.detailView.radio = radio;
                    [appDelegate.detailView justStartit];
                }
            }
            else {
                [self.navigationController  pushViewController:appDelegate.detailView animated:YES];
                if(appDelegate.detailView.streamURL != radio.url && radio.url != @"" && radio.url != @"http://")
                {
                    appDelegate.detailView.streamURL = [radio url];
                    [appDelegate.detailView.stationName setText:[radio name]];
                    [appDelegate.detailView setTitle:[radio name]];
                    [appDelegate.detailView.songtitle setText:@""];
                    [appDelegate.detailView.songartist setText:@""];
                    radioStation *radio = [appDelegate.stationer objectAtIndex:indexPath.row];
                    appDelegate.detailView.radio = radio;
                    [appDelegate.detailView justStartit];
                }
                else {
                    
                }
            }
            
     
    }
    else if(indexPath.row < [appDelegate.stationer count] && self.editing)
    {
        addView *editView = [[addView alloc] init];
		radioStation *radio = [appDelegate.stationer objectAtIndex:indexPath.row];
        [self presentModalViewController:editView animated:YES];
		editView.radio = radio;
		editView.managedObjectContext = self.managedObjectContext;
        [editView release];
    }
    else if(indexPath.row == [appDelegate.stationer count] && self.editing) {
        [self AddButtonAction:indexPath];
    }
}
/*
- (void)modalViewControllerDismissed:(ModalViewController *)modalViewController
{
    [self.tableView reloadData];
}
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([appDelegate.stationer count]))
    {
        return UITableViewCellEditingStyleInsert;
        
    }
    else
    {
        
        return UITableViewCellEditingStyleDelete;
        
    }
    
    return UITableViewCellEditingStyleNone;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
#pragma mark - Shake gestures
-(BOOL)canBecomeFirstResponder{
	return YES;
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.subtype == UIEventSubtypeMotionShake)
	{
            Lyssna_NERadioAppDelegate *appDelegate = (Lyssna_NERadioAppDelegate *)[[UIApplication sharedApplication] delegate];
            radioStation *radio = [appDelegate.stationer objectAtIndex:random()%[appDelegate.stationer count]];
            DetailView *myDetViewCont;
            if(appDelegate.detailView == nil) {
                if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                    myDetViewCont = [[DetailView alloc] initWithNibName:@"DetailView" bundle:nil];
                }
                else {
                   myDetViewCont = [[DetailView alloc] initWithNibName:@"DetailViewipad" bundle:nil]; 
                }
                // creating new detail view controller instance  
                appDelegate.detailView = myDetViewCont;
                [myDetViewCont release];
            }
            [self.navigationController  pushViewController:appDelegate.detailView animated:YES];
            if(appDelegate.detailView.streamURL != radio.url && radio.url != @"" && radio.url != @"http://")
            {
                appDelegate.detailView.streamURL = [radio url];
                [appDelegate.detailView.stationName setText:[radio name]];
                [appDelegate.detailView setTitle:[radio name]];
                [appDelegate.detailView.songtitle setText:@""];
                [appDelegate.detailView.songartist setText:@""];
                appDelegate.detailView.radio = radio;
                [appDelegate.detailView justStartit];
            }
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [tableView release];
    [super dealloc];
    
}


@end

