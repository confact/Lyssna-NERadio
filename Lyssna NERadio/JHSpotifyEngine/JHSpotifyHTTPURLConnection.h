//
//  JHSpotifyHTTPURLConnection.h
//  JHSpotifyEngine
//
//  Created by Jared Holdcroft on 01/02/2010.
//  Copyright 2010 Bitformed. All rights reserved.
//

#import "JHSpotifyGlobalHeader.h"

#import "JHSpotifyRequestTypes.h"

@interface JHSpotifyHTTPURLConnection : NSURLConnection {
    NSMutableData *_data;                   // accumulated data received on this connection
    JHSpotifyRequestType _requestType;      // general type of this request, mostly for error handling
    JHSpotifyResponseType _responseType;    // type of response data expected (if successful)
    NSString *_identifier;
	NSURL *_URL;							// the URL used for the connection (needed as a base URL when parsing with libxml)
}

// Initializer
- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate 
		  requestType:(JHSpotifyRequestType)requestType responseType:(JHSpotifyResponseType)responseType;

// Data helper methods
- (void)resetDataLength;
- (void)appendData:(NSData *)data;

// Accessors
- (NSString *)identifier;
- (NSData *)data;
- (NSURL *)URL;
- (JHSpotifyRequestType)requestType;
- (JHSpotifyResponseType)responseType;
- (NSString *)description;

@end
