//
//  songDetailView.h
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-10.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "song.h"
#import "JHSpotifyEngine.h"
//#import "InAppPurchaseManager.h"

@interface songDetailView : UITableViewController <JHSpotifyEngineDelegate, UIAlertViewDelegate> {
	song *songi;
	JHSpotifyEngine *spotifyEngine;
	NSString *spotifyURL;
    bool spotifyBought;
    //InAppPurchaseManager *appPurchaseManager;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@property(nonatomic,retain)	song *songi;
@property(nonatomic,retain)	NSString *spotifyURL;
@property(nonatomic,retain)	JHSpotifyEngine *spotifyEngine;
//@property(nonatomic,retain)	InAppPurchaseManager *appPurchaseManager;
@property(nonatomic) bool spotifyBought;
@end
