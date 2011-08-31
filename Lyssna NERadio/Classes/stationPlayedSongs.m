//
//  stationPlayedSongs.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2011-01-30.
//  Copyright 2011 DevSnack Inc. All rights reserved.
//

#import "stationPlayedSongs.h"
#import "songtableviewCell.h"
#import "songDetailView.h"
#import "song.h"


@implementation stationPlayedSongs
@synthesize station;
@synthesize songs;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	self.title = NSLocalizedString(@"Last Played", @"LastPlayedTitle");

	//songs = [[NSSet alloc] init];
	
	NSArray *a= [self.station.station allObjects];
	NSSortDescriptor *d = [[NSSortDescriptor alloc] initWithKey:@"added" 
													  ascending:NO];
	a = [a sortedArrayUsingDescriptors:[NSArray arrayWithObject:d]];
	self.songs = a;
	[d release];
	//[array release];
	//self.tableView.backgroundColor = [UIColor colorWithRed:206.0/255.0
	//												 green:218.0/255.0
	//												  blue:226.0/255.0
	//												 alpha:1];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
	[super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
	//[songs removeAllObjects];
	//[songs addObjectsFromArray:[station.station allObjects]];
	//[self.tableView reloadData];
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(NSMutableArray *)arrayFromSet:(NSSet *)inSet
{
	return [[NSMutableArray alloc] initWithArray:[inSet allObjects]];
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [songs count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    songtableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[songtableviewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    song *lat = [songs objectAtIndex:indexPath.row];
	/*
	 UIImage *backgroundImage = [UIImage imageNamed:@"cellbg.png"];
	 UIImageView *bgView = [[UIImageView alloc] initWithFrame:cell.backgroundView.frame];
	 bgView.image = backgroundImage;
	 [cell setBackgroundView: bgView];
	 [bgView release];
	 */
    cell.lattitle.text = [lat title];
    cell.artist.text = [lat artist];
	[dateFormatter setDateFormat:@"dd LLL y HH:mm"];
	NSString *dateString = [dateFormatter stringFromDate:[lat added]];
	cell.played.text = dateString;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;//Height for the cells
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	//RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	songDetailView *detailViewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        detailViewController = [[songDetailView alloc] initWithNibName:@"songDetailViewController" bundle:nil];
    }
    else {
        detailViewController = [[songDetailView alloc] initWithNibName:@"songDetailView" bundle:nil];
    }
	detailViewController.songi = [songs objectAtIndex:indexPath.row];
	// ...
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [songs release];
    [station release];
    [super dealloc];
}


@end

