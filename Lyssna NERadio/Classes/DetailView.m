//
//  DetailView.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-08-20.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//


#import "DetailView.h"
#import "AudioStreamer.h"
#import <iAd/iAD.h>
#import "RadioLyssnarenAppDelegate.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "song.h"
#import "lastPlayedListViewer.h"
#import "stationPlayedSongs.h"
#import "TestFlight.h"

#define kSampleAppKey @"44d2f3b657bf4390"

@implementation DetailView
@synthesize streamURL;
@synthesize stationName;
@synthesize currentArtist, currentTitle;
@synthesize bannerIsVisible;
@synthesize radio;
@synthesize songartist, songtitle;
@synthesize volumeSlider;
@synthesize madeby;
@synthesize overlaycolorView;

//
// setButtonImage:
//
// Used to change the image on the playbutton. This method exists for
// the purpose of inter-thread invocation because
// the observeValueForKeyPath:ofObject:change:context: method is invoked
// from secondary threads and UI updates are only permitted on the main thread.
//
// Parameters:
//    image - the image to set on the play button.
//

- (void)setButtonImage:(UIImage *)image
{
	[button.layer removeAllAnimations];
	if (!image)
	{
		[button setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
	}
	else
	{
		[button setImage:image forState:0];
		
		if ([button.currentImage isEqual:[UIImage imageNamed:@"loadingbutton.png"]])
		{
			[self spinButton];
		}
	}
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.streamer != nil)
	{
		[[NSNotificationCenter defaultCenter]
		 removeObserver:self
		 name:ASStatusChangedNotification
		 object:appDelegate.streamer];
		
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[appDelegate.streamer stop];
		[appDelegate.streamer release];
        appDelegate.url = nil;
		appDelegate.streamer = nil;
		[self setMediaInfoToNil];
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
-(void)forceUIUpdate {
    RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.songtitle.text = currentTitle;
	self.songartist.text = currentArtist;
    
	if (!appDelegate.streamer) {
		[self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
	}
    
}
- (void)createStreamer
{
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[self destroyStreamer];
	
	NSString *escapedValue =
	[(NSString *)CFURLCreateStringByAddingPercentEscapes(
														 nil,
														 (CFStringRef)streamURL,
														 NULL,
														 NULL,
														 kCFStringEncodingUTF8)
	 autorelease];
	
	NSURL *url = [NSURL URLWithString:escapedValue];
	appDelegate.streamer = [[AudioStreamer alloc] initWithURL:url];
	appDelegate.url = streamURL;
    
	progressUpdateTimer =
	[NSTimer
	 scheduledTimerWithTimeInterval:0.1
	 target:self
	 selector:@selector(updateProgress:)
	 userInfo:nil
	 repeats:YES];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playbackStateChanged:)
	 name:ASStatusChangedNotification
	 object:appDelegate.streamer];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(metadataChanged:)
	 name:ASUpdateMetadataNotification
	 object:appDelegate.streamer];
	[TestFlight passCheckpoint:@"Start Listening"];
}

//
// viewDidLoad
//
// Creates the volume slider, sets the default path for the local file and
// creates the streamer immediately if we already have a file at the local
// location.
//
- (void)viewDidLoad
{
    /*
	adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectOffset(adView.frame, 0, -50);
    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
    [self.view addSubview:adView];
    adView.delegate=self;
    self.bannerIsVisible=NO;*/
	//self.volumeSlider.value = 1.00;
	[super viewDidLoad];
	self.overlaycolorView.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:40.0/255.0 blue:44.0/255.0 alpha:1];
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
	bannerView_.adUnitID = kSampleAppKey;
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [bannerView_ setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
        [bannerView_ setClipsToBounds:false]; // Here is the important line
    }
	bannerView_.rootViewController=self;
	[bannerView_ loadRequest:[GADRequest request]];
    [self.view addSubview:bannerView_];
    
	/*self.songtitle.textColor = [UIColor colorWithRed:61.0/255.0
											   green:88.0/255.0
												blue:105.0/255.0
											   alpha:1];
	*/
	
	UIBarButtonItem* nowButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Last Played", @"LastPlayedTitle") style:UIBarButtonItemStylePlain target:self action:@selector(ShowPlayedSongs)];
	
	self.navigationItem.rightBarButtonItem = nowButton;
	
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:volumeSlider.bounds] autorelease];
    //[volumeView showsRouteButton];
	[volumeSlider addSubview:volumeView];
	[volumeView sizeToFit];
	
	[self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
	[self.madeby setText:NSLocalizedString(@"Made By Håkan Nylén", @"madebyTitle")];
    
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(updateGUIiPad:)
	 name:@"ASUpdateRadiostationiPadNotification"
	 object:nil];
}
- (void)updateGUIiPad:(NSNotification *)aNotification {
    NSMutableArray *arrayWithInfo = (NSMutableArray *)[aNotification object];
	self.streamURL = [arrayWithInfo objectAtIndex:0];
    [self.stationName setText:[arrayWithInfo objectAtIndex:1]];
    [self setTitle:[arrayWithInfo objectAtIndex:1]];
    [self.songtitle setText:@""];
    [self.songartist setText:@""];
    [self justStartit];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	if (!self.bannerIsVisible)
	{
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		// banner is invisible now and moved out of the screen on 50 px
		banner.frame = CGRectOffset(banner.frame, 0, 50);
		[UIView commitAnimations];
		self.bannerIsVisible = YES;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	if (self.bannerIsVisible)
	{
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		// banner is visible and we move it out of the screen, due to connection issue
		banner.frame = CGRectOffset(banner.frame, 0, -50);
		[UIView commitAnimations];
		self.bannerIsVisible = NO;
	}
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = YES;
    if (!willLeave && shouldExecuteAction)
        {
            RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.streamer stop];
        }
    return shouldExecuteAction;
    }
	 
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self createStreamer];
    [self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
    [appDelegate.streamer start];
}
//
// spinButton
//
// Shows the spin button when the audio is loading. This is largely irrelevant
// now that the audio is loaded from a local file.
//
- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [button frame];
	button.layer.anchorPoint = CGPointMake(0.5, 0.5);
	button.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[button.layer addAnimation:animation forKey:@"rotationAnimation"];
	
	[CATransaction commit];
}
- (void)ShowPlayedSongs {
	
	stationPlayedSongs *stationPlayedsongsi = [[stationPlayedSongs alloc] initWithNibName:@"stationPlayedSongs" bundle:nil];
	stationPlayedsongsi.station = self.radio;
	// ...
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:stationPlayedsongsi animated:YES];
	[stationPlayedsongsi release];
	
}
//
// animationDidStop:finished:
//
// Restarts the spin animation on the button when it ends. Again, this is
// largely irrelevant now that the audio is loaded from a local file.
//
// Parameters:
//    theAnimation - the animation that rotated the button.
//    finished - is the animation finised?
//
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self spinButton];
	}
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
//
// buttonPressed:
//
// Handles the play/stop button. Creates, observes and starts the
// audio streamer when it is a play button. Stops the audio streamer when
// it isn't.
//
// Parameters:
//    sender - normally, the play/stop button.
//
- (void)justStartit
{
    RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self createStreamer];
    [self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
    [appDelegate.streamer start];
}

- (IBAction)buttonPressed:(id)sender
{
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([button.currentImage isEqual:[UIImage imageNamed:@"playbutton.png"]])
	{
		
		[self createStreamer];
		[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
		[appDelegate.streamer start];
	}
	else
	{
		[appDelegate.streamer stop];
	}
}

//
// sliderMoved:
//
// Invoked when the user moves the slider
//
// Parameters:
//    aSlider - the slider (assumed to be the progress slider)
//
- (IBAction)sliderMoved:(id)sender
{
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	//double newVolume = self.volumeSlider.value;
	//[appDelegate.streamer setVolume:newVolume];
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([appDelegate.streamer isWaiting])
	{
		[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
	}
	else if ([appDelegate.streamer isPlaying])
	{
		[self setButtonImage:[UIImage imageNamed:@"stopbutton.png"]];
	}
	else if ([appDelegate.streamer isIdle])
	{
		[self destroyStreamer];
		[self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
	}
}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//

- (void)updateProgress:(NSTimer *)updatedTimer
{
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.streamer.bitRate != 0.0)
	{
		double progress = appDelegate.streamer.progress;
		double duration = appDelegate.streamer.duration;
		
        if(appDelegate.url = streamURL)
        {
            if (duration > 0)
            {
                [positionLabel setText:
                 [NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",
                  progress,
                  duration]];
                [progressSlider setEnabled:YES];
                [progressSlider setValue:100 * progress / duration];
            }
            else if(progress > 0)
            {
                [positionLabel setText:
                 [NSString stringWithFormat:@"Time Played: %.1f seconds",
                  progress]];
            }
            else
            {
                [progressSlider setEnabled:NO];
            } 
        }
        else
        {
            [progressSlider setEnabled:NO];
        } 
		
	}
	else
	{
		positionLabel.text = @"Time Played:";
	}
}
#ifdef SHOUTCAST_METADATA
/** Example metadata
 * 
 StreamTitle='Kim Sozzi / Amuka / Livvi Franc - Secret Love / It's Over / Automatik',
 StreamUrl='&artist=Kim%20Sozzi%20%2F%20Amuka%20%2F%20Livvi%20Franc&title=Secret%20Love%20%2F%20It%27s%20Over%20%2F%20Automatik&album=&duration=1133453&songtype=S&overlay=no&buycd=&website=&picture=',
 
 Format is generally "Artist hypen Title" although servers may deliver only one. This code assumes 1 field is artist.
 */
- (void)metadataChanged:(NSNotification *)aNotification
{
	NSString *streamArtist;
	NSString *streamTitle;
	NSString *streamAlbum;
    //NSLog(@"Raw meta data = %@", [[aNotification userInfo] objectForKey:@"metadata"]);
    
	NSArray *metaParts = [[[aNotification userInfo] objectForKey:@"metadata"] componentsSeparatedByString:@";"];
	NSString *item;
	NSMutableDictionary *hash = [[NSMutableDictionary alloc] init];
	for (item in metaParts) {
		// split the key/value pair
		NSArray *pair = [item componentsSeparatedByString:@"="];
		// don't bother with bad metadata
		if ([pair count] == 2)
			[hash setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
	}
    
	// do something with the StreamTitle
	NSString *streamString = [[hash objectForKey:@"StreamTitle"] stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
	NSArray *streamParts = [streamString componentsSeparatedByString:@" - "];
	if ([streamParts count] > 0) {
		streamArtist = [streamParts objectAtIndex:0];
	} else {
		streamArtist = @"";
	}
	// this looks odd but not every server will have all artist hyphen title
	if ([streamParts count] >= 2) {
		streamTitle = [streamParts objectAtIndex:1];
		if ([streamParts count] >= 3) {
			streamAlbum = [streamParts objectAtIndex:2];
		} else {
			streamAlbum = @"N/A";
		}
	} else {
		streamTitle = @"";
		streamAlbum = @"";
	}
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.uiIsVisible) {
        self.songtitle.text = streamTitle;
		self.songartist.text = streamArtist;
	}
	if(streamArtist != @"" && streamTitle != @"")
	{
	NSManagedObjectContext *moc = [(RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	// only update the UI if in foreground

		song *last;
		if([appDelegate.songs count] > 0)
		{
			last = [appDelegate.songs objectAtIndex:0];
		}
		else {
			last = nil;
		}


		if((self.currentTitle != streamTitle || self.currentTitle == nil) && ![streamTitle isEqualToString:last.title])
		{
		
		song *failedBankInfo = (song *)[NSEntityDescription
										insertNewObjectForEntityForName:@"song" 
										inManagedObjectContext:moc];
		NSDate *now = [NSDate date];
		failedBankInfo.title = streamTitle;
		failedBankInfo.artist = streamArtist;
		failedBankInfo.added = now;
        [self.radio addStationObject:failedBankInfo];
		//failedBankInfo.station = station;
		NSError *error;
		if (![moc save:&error]) {
			NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		}
		
		[appDelegate.songs insertObject:failedBankInfo atIndex:0];
		NSNotification *notification =
			[NSNotification
			 notificationWithName:@"ASUpdateTableViewNotification"
			 object:self
			 userInfo:nil];
			[[NSNotificationCenter defaultCenter] postNotification:notification];
			
		}
		if(streamTitle != nil && streamArtist != nil)
		{
			[self setMediaInfoWithArtist:streamArtist andWithTitle:streamTitle];
		}
		
	}
	self.currentArtist = streamArtist;
	self.currentTitle = streamTitle;
}

#endif
- (void) setMediaInfoWithArtist:(NSString *)artist andWithTitle:(NSString*)title {
    if(NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        //NSString * imName = @"imagetest.png"; // Artwork image
        [dict setObject:NSLocalizedString(title, @"") forKey:MPMediaItemPropertyTitle];
        [dict setObject:NSLocalizedString(artist, @"") forKey:MPMediaItemPropertyArtist];
        //MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:imName]];
        //[dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        [dict release];
    }
}
- (void) setMediaInfoToNil {
    if(NSClassFromString(@"MPNowPlayingInfoCenter")) {
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
    }
}
//
// textFieldShouldReturn:
//
// Dismiss the text field when done is pressed
//
// Parameters:
//    sender - the text field
//
// returns YES
//
- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
	[sender resignFirstResponder];
	[self createStreamer];
	return YES;
}
#pragma mark Remote Control Events
/* The iPod controls will send these events when the app is in the background */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
	RadioLyssnarenAppDelegate *appDelegate = (RadioLyssnarenAppDelegate *)[[UIApplication sharedApplication] delegate];
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			[appDelegate.streamer pause];
			break;
		case UIEventSubtypeRemoteControlPlay:
			[appDelegate.streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[appDelegate.streamer pause];
			break;
		case UIEventSubtypeRemoteControlStop:
			[appDelegate.streamer stop];
			break;
		default:
			break;
	}
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //[adView.r
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark AdWhirlDelegate methods

- (NSString *)adWhirlApplicationKey{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return @"4ffa0477eb484396b5549ada5b79c9c2";
    }
    else {
    return kSampleAppKey;
    }
}

- (UIViewController *)viewControllerForPresentingModalView{
    return self;
}

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
    [button release];
    [volumeSlider release];
    [positionLabel release];
    [stationName release];
    [progressSlider release];
    [currentTitle release];
    [currentArtist release];
    [songtitle release];
	[songartist release];
    //awView.delegate = nil;
    //[awView release];
    [super dealloc];
}

@end
