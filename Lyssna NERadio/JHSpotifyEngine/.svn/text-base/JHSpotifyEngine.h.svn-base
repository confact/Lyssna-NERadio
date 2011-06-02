//
//  JHSpotifyEngine.h
//  JHSpotifyEngine
//
//  Created by Jared Holdcroft on 23/11/2009.
//  Copyright 2009 Bitformed. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JHSpotifyEngineDelegate.h"
#import "JHSpotifyParserDelegate.h"

@interface JHSpotifyEngine : NSObject {
    __weak NSObject <JHSpotifyEngineDelegate> *_delegate;
	
    NSMutableDictionary *_connections;   // JHSpotifyHTTPURLConnection objects
    //NSMutableData *receivedData;

}

#pragma mark Class management

// Constructors
+ (JHSpotifyEngine *)spotifyEngineWithDelegate:(NSObject *)delegate;
- (JHSpotifyEngine *)initWithDelegate:(NSObject *)delegate;

// Configuration and Accessors
+ (NSString *)version; // returns the version of JHSpotifyEngine

// Connection methods
- (int)numberOfConnections;
- (NSArray *)connectionIdentifiers;
- (void)closeConnection:(NSString *)identifier;
- (void)closeAllConnections;

#pragma mark API methods

// ======================================================================================================
// Spotify API methods
// See documentation at: http://developer.spotify.com/en/metadata-api/overview/
// ======================================================================================================

// Lookup
- (NSString *)lookupArtist:(NSString *)artist withAlbum:(BOOL)withAlbum withAlbumDetail:(BOOL)withAlbumDetail;
- (NSString *)lookupAlbum:(NSString *)artist withTrack:(BOOL)withAlbum withTrackDetail:(BOOL)withAlbumDetail;
- (NSString *)lookupTrack:(NSString *)track;

// Search
- (NSString *)searchArtist:(NSString *)artist;
- (NSString *)searchAlbum:(NSString *)album;
- (NSString *)searchTrack:(NSString *)track;

@end
