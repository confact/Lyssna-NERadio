//
//  lastPlayedListViewer.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-09.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import "lastPlayedListViewer.h"
#import "song.h"
#import "RadioLyssnarenAppDelegate.h"
#import "songtableviewCell.h"
#import "songDetailView.h"

@implementation lastPlayedListViewer
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize sBar;
@synthesize searchedSongsData;
@synthesize tableView;
@synthesize tableData;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	tableData = [[NSMutableArray alloc]init];
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	[tableData addObjectsFromArray:appDelegate.songs];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(updateTableView:)
	 name:@"ASUpdateTableViewNotification"
	 object:nil];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = NSLocalizedString(@"Last Played", @"LastPlayedTitle");
	self.tableView.backgroundColor = [UIColor colorWithRed:206.0/255.0
													 green:218.0/255.0
													  blue:226.0/255.0
													 alpha:1];
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	[super viewDidLoad];

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self.tableData count] != 0) {
        [self.tableData removeAllObjects];
    }
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.tableData addObjectsFromArray:appDelegate.songs];
	[self.tableView reloadData];
}
- (void)updateTableView:(NSNotification *)aNotification {
	[tableData removeAllObjects];
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	[tableData addObjectsFromArray:appDelegate.songs];
	[self.tableView reloadData];
}
/*
- (void)viewDidAppear:(BOOL)animated {
	[tableData removeAllObjects];
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	[tableData addObjectsFromArray:appDelegate.songs];
	[self.tableView reloadData];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    //RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    songtableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[songtableviewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	

    if(indexPath.row == ([tableData count]) && self.editing)
    {
        [cell.textLabel setText:@"Lägg till"];
        return cell;
    }
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    song *radio = [tableData objectAtIndex:indexPath.row];
	/*
	UIImage *backgroundImage = [UIImage imageNamed:@"cellbg.png"];
	UIImageView *bgView = [[UIImageView alloc] initWithFrame:cell.backgroundView.frame];
	bgView.image = backgroundImage;
	[cell setBackgroundView: bgView];
	[bgView release];
	*/
    cell.lattitle.text = [radio title];
    cell.artist.text = [radio artist];
	[dateFormatter setDateFormat:@"dd LLL y HH:mm"];
	NSString *dateString = [dateFormatter stringFromDate:[radio added]];
	cell.played.text = dateString;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
		return 60;//Height for the cells
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		NSManagedObjectContext *delete = [(RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		song *deleter = [tableData objectAtIndex:indexPath.row];
		[delete deleteObject:deleter];
		
		[appDelegate.songs removeObjectAtIndex:indexPath.row];
		[tableData removeObjectAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[self.tableView reloadData];
	}   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
	detailViewController.songi = [tableData objectAtIndex:indexPath.row];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
        
	return UITableViewCellEditingStyleDelete;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar's cancel button while in edit mode
	sBar.showsCancelButton = YES;
	sBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	//[tableData removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	sBar.showsCancelButton = NO;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	[tableData removeAllObjects];// remove all data that belongs to previous search
	if([searchText isEqualToString:@""]||searchText==nil){
		[self.tableView reloadData];
		return;
	}
	NSInteger counter = 0;
	for(song *lat in appDelegate.songs)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange latnamn = [(NSString *)lat.title rangeOfString:searchText options:NSCaseInsensitiveSearch];
		NSRange artistnamn = [(NSString *)lat.artist rangeOfString:searchText options:NSCaseInsensitiveSearch];
		if(latnamn.location != NSNotFound)
		{
			if(latnamn.location== 0)//that is we are checking only the start of the names.
			{
				[tableData addObject:lat];
			}
		}
		else if(artistnamn.location != NSNotFound)
		{
			if(artistnamn.location== 0)//that is we are checking only the start of the names.
			{
				[tableData addObject:lat];
			}
		}
		 
		counter++;
		[pool release];
	}
	[self.tableView reloadData];
	
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[tableData removeAllObjects];
	[tableData addObjectsFromArray:appDelegate.songs];
	@try{
		[self.tableView reloadData];
	}
	@catch(NSException *e){
		
	}
	[sBar resignFirstResponder];
	sBar.text = @"";
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	
	[searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:@"ASUpdateTableViewNotification"
	 object:nil];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[tableData release];
	[searchedSongsData release];
	[sBar release];
    [super dealloc];
}


@end

