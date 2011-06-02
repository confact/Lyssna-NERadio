//
//  songDetailView.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-10.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import "radioStation.h"
#import "songDetailView.h"
//#import "JHSpotifyEngine.h"
#import "Lyssna_NERadioAppDelegate.h"

#define kSpotify @"com.devsnackinc.LyssnaNERadio.spotify" 

@implementation songDetailView
@synthesize songi;
@synthesize spotifyURL;
@synthesize spotifyBought;
@synthesize spotifyEngine;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.allowsSelection = YES;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = @"Info";
	self.spotifyURL = @"";
    //self.spotifyBought = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.devsnackinc.LyssnaNERadio.spotify"];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    spotifyEngine = [[JHSpotifyEngine alloc] initWithDelegate:self];
    [spotifyEngine searchTrack:[NSString stringWithFormat:@"%@ %@", songi.artist, songi.title]];
	[self.tableView reloadData];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
        //return 4;
        return 5;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	switch (indexPath.row) {
        case 0: 
			cell.textLabel.text = NSLocalizedString(@"Artist", @"SongDetailArtist");
			cell.detailTextLabel.text = songi.artist;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
        case 1: 
			cell.textLabel.text = NSLocalizedString(@"Song", @"SongDetailTrack");
			cell.detailTextLabel.text = songi.title;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
        case 2:
			[dateFormatter setDateFormat:@"E dd LLL y HH:mm"];
			NSString *dateString = [dateFormatter stringFromDate:songi.added];
			cell.textLabel.text = NSLocalizedString(@"Played", @"SongDetailPlayed");
			cell.detailTextLabel.text = dateString;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
		case 3:
			cell.textLabel.text = NSLocalizedString(@"Station", @"SongDetailStation");
			radioStation *station = (radioStation *)self.songi.songs;
			cell.detailTextLabel.text = [station name];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			break;
		case 4:
			cell.textLabel.text = @"Spotify";
			if(![self.spotifyURL isEqualToString:@""])
			{
                cell.detailTextLabel.text = self.spotifyURL;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			}
			else {
				cell.detailTextLabel.text = NSLocalizedString(@"Loading..", @"SongDetailLoadingSpotify");
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			break;
    }
    return cell;
}
- (void)tracksReceived:(NSArray *)artists forRequest:(NSString *)connectionIdentifier
{
	//NSLog(@"Artists received %@", artists);
	int counted = 0;
	for(NSArray *dict in artists)
	{
		if(counted < 1)
		{
            //NSLog(@"Tracks received %@", dict);
            NSString *songAddress = [dict objectForKey:@"href"];
            //NSLog(@"SONGADDRESS HÄMTAD %@", songAddress);
            NSArray *_splitItems = [songAddress componentsSeparatedByString:@":"];
            self.spotifyURL = [_splitItems objectAtIndex:2];
		}
		counted++;
	}
	if([self.spotifyURL isEqualToString:@""])
	{
		self.spotifyURL = NSLocalizedString(@"Couldn't find @ Spotify", @"SongDetailCouldntFindSpotify");
	}
	[self.tableView reloadData];
		
}
- (void)connectionFinished:(NSString *)connectionIdentifier
{
    //NSLog(@"Connection finished %@", connectionIdentifier);
	
	if ([spotifyEngine numberOfConnections] == 0)
	{
	}
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


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
	/*
	 if(
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	//start BrianSlick's code
	
	
	if(cell.textLabel.text == @"Spotify")
	{
        if(![self.spotifyURL isEqualToString:@""])
		{
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"spotify:track:%@", self.spotifyURL]];
            
            [[UIApplication sharedApplication] openURL:url];
		}
        /*
        if(self.spotifyBought) {
            if(![self.spotifyURL isEqualToString:@""])
            {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"spotify:track:%@", self.spotifyURL]];
		
                [[UIApplication sharedApplication] openURL:url];
            }
		}
        else {
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert setTitle:@"Buy Spotify"];
            [alert setMessage:@"Do you want to buy Spotify feature and removing advertisement?"];
            [alert setDelegate:self];
            [alert addButtonWithTitle:@"Yes"];
            [alert addButtonWithTitle:@"No"];
            [alert show];
            [alert release];
        }
         */
	}
}
- (void)showConfirmAlert
{
	
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        // NISSEE
	}
	else if (buttonIndex == 1)
	{

	}
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
 if(section == 0)
 {
	/* if(![self.spotifyURL isEqualToString:@"Loading.."])
	 {
		 if(![self.spotifyURL isEqualToString:@"Couldn't find @ Spotify"])*/
		return [NSString stringWithFormat:NSLocalizedString(@"type spotify:track: and the id you got over here in Spotify to show the song. Or just click to play song in Spotify.", @"SongDetailSpotify")];
	 //}
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
	[spotifyEngine release];
	[songi release];
	[spotifyURL release];
    [spotifyBought release];
    [super dealloc];
}


@end

