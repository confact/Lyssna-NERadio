//
//  DetailView.h
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-08-20.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import "AudioStreamer.h"
#import <UIKit/UIKit.h>
#import <iAd/iAD.h>
#import "radioStation.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "GADBannerView.h"

@class AudioStreamer;

@interface DetailView : UIViewController <AVAudioPlayerDelegate> {
	IBOutlet UIButton *button;
	//IBOutlet UISlider *volumeSlider;
	IBOutlet UILabel *positionLabel;
	IBOutlet UILabel *stationName;
	IBOutlet UISlider *progressSlider;
	IBOutlet UIView *volumeSlider;
	NSTimer *progressUpdateTimer;
	NSString *streamURL;
    
	
	radioStation *radio;
	
	GADBannerView *bannerView_;
    
	BOOL bannerIsVisible;
    
    NSString *currentArtist;
    NSString *currentTitle;
    IBOutlet UILabel *songtitle;
	IBOutlet UILabel *songartist;
}
@property(nonatomic, retain) radioStation *radio;
@property(nonatomic, retain) NSString *currentArtist;
@property(nonatomic, retain) NSString *currentTitle;
@property(nonatomic, retain) NSString *streamURL;
@property(nonatomic, retain) IBOutlet UILabel *stationName;
@property(nonatomic, retain) IBOutlet UIView *volumeSlider;
@property(nonatomic, retain) IBOutlet UIView *overlaycolorView;

@property(nonatomic, retain) IBOutlet UILabel *songtitle;
@property(nonatomic, retain) IBOutlet UILabel *songartist;
@property(nonatomic, retain) IBOutlet UILabel *madeby;

@property (nonatomic,assign) BOOL bannerIsVisible;

- (void)ShowPlayedSongs; 
- (IBAction)buttonPressed:(id)sender;
- (void)spinButton;
- (void)forceUIUpdate;
- (void)justStartit;
- (void)playbackStateChanged:(NSNotification *)aNotification;
- (void)updateProgress:(NSTimer *)aNotification;
- (IBAction)sliderMoved:(id)sender;
@end
