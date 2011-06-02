//
//  JHSpotifyEngineDelegate.h
//  JHSpotifyEngine
//
//  Created by Jared Holdcroft on 23/11/2009.
//  Copyright 2009 Bitformed. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol JHSpotifyEngineDelegate 

// These delegate methods are called after a connection has been established
- (void)requestSucceeded:(NSString *)connectionIdentifier;
- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error;

// These delegate methods are called after all results are parsed from the connection. 
- (void)artistsReceived:(NSArray *)artists forRequest:(NSString *)connectionIdentifier;

- (void)albumsReceived:(NSArray *)albums forRequest:(NSString *)connectionIdentifier;

- (void)tracksReceived:(NSArray *)tracks forRequest:(NSString *)connectionIdentifier;

// This delegate method is called whenever a connection has finished.
- (void)connectionFinished:(NSString *)connectionIdentifier;

@end
