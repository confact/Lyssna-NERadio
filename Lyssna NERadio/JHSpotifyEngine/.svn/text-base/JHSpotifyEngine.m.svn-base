//
//  JHSpotifyEngine.m
//  JHSpotifyEngine
//
//  Created by Jared Holdcroft on 23/11/2009.
//  Copyright 2009 Bitformed. All rights reserved.
//

#import "JHSpotifyEngine.h"

/** Spotify URL
 * http://ws.spotify.com/service/version/method[.format]?parameters
 */


#define VERSION						@"0.9"
#define SPOTIFY_METADATA_URL		@"http://ws.spotify.com"
#define SPOTIFY_API_VERSION			@"1"
#define SPOTIFY_API_SEARCH			@"search"
#define SPOTIFY_API_LOOKUP			@"lookup"
#define URL_REQUEST_TIMEOUT			300.0

#import "JHSpotifyArtistXMLParser.h"
#import "JHSpotifyAlbumXMLParser.h"
#import "JHSpotifyTrackXMLParser.h"
#import "JHSpotifyHTTPURLConnection.h"

// TODO - will implement libxml
/*
#define USE_LIBXML 0

#if USE_LIBXML
	#import "JHSpotifyLibXMLParser.h"
#else
 #import "JHSpotifyNSXMLParser.h"
#endif
*/

@interface JHSpotifyEngine (PrivateMethods)

// Utility methods
- (NSString *)_encodeString:(NSString *)string;

- (NSString *)_queryStringWithBase:(NSString *)base 
						parameters:(NSDictionary *)params 
						  prefixed:(BOOL)prefixed;

#pragma mark Parsing methods

- (void)_parseDataForConnection:(JHSpotifyHTTPURLConnection *)connection;


#pragma mark Request methods

// Request methods
- (NSString *)_sendRequestWithParameters:(NSDictionary *)params 
								 service:(NSString *)service
								 version:(NSString *)version
								  method:(NSString *)method
							 requestType:(JHSpotifyRequestType)requestType 
							responseType:(JHSpotifyResponseType)responseType;

// Delegate methods
- (BOOL) _isValidDelegateForSelector:(SEL)selector;


@end


@implementation JHSpotifyEngine

#pragma mark Constructors

+ (JHSpotifyEngine *)spotifyEngineWithDelegate:(NSObject *)theDelegate
{
    return [[[JHSpotifyEngine alloc] initWithDelegate:theDelegate] autorelease];
}

- (JHSpotifyEngine *)initWithDelegate:(NSObject *)newDelegate
{
    if (self = [super init]) {
        _delegate = newDelegate; // TODO: Why? -> deliberately weak reference
    }
	_connections = [[NSMutableDictionary alloc] initWithCapacity:0];
	//receivedData = [[NSMutableData data] retain];  
    
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    
    [[_connections allValues] makeObjectsPerformSelector:@selector(cancel)];
    [_connections release];
    
    [super dealloc];
}

// Configuration and Accessors
+ (NSString *)version
{
	return VERSION;
}

#pragma mark API methods

// ======================================================================================================
// Spotify API methods
// See documentation at: http://developer.spotify.com/en/metadata-api/overview/
// ======================================================================================================

// Lookup
- (NSString *)lookupArtist:(NSString *)artist withAlbum:(BOOL)withAlbum withAlbumDetail:(BOOL)withAlbumDetail
{
	
	
	return @"";
}

- (NSString *)lookupAlbum:(NSString *)artist withTrack:(BOOL)withAlbum withTrackDetail:(BOOL)withAlbumDetail
{
	return @"";
}

- (NSString *)lookupTrack:(NSString *)track
{
	return @"";
}

// Search
- (NSString *)searchArtist:(NSString *)artist
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	
	[params setObject:[NSString stringWithFormat:@"%@", artist] forKey:@"q"];
	
	return [self _sendRequestWithParameters:params
									service:SPOTIFY_API_SEARCH
									version:SPOTIFY_API_VERSION 
									 method:@"artist"
								requestType:JHSpotifySearchArtist
							   responseType:JHSpotifyArtists];

}

- (NSString *)searchAlbum:(NSString *)album
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	
	[params setObject:[NSString stringWithFormat:@"%@", album] forKey:@"q"];
	
	return [self _sendRequestWithParameters:params
									service:SPOTIFY_API_SEARCH
									version:SPOTIFY_API_VERSION 
									 method:@"album"
								requestType:JHSpotifySearchAlbum
							   responseType:JHSpotifyAlbums];
}

- (NSString *)searchTrack:(NSString *)track
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	
	[params setObject:[NSString stringWithFormat:@"%@", track] forKey:@"q"];
	
	return [self _sendRequestWithParameters:params
									service:SPOTIFY_API_SEARCH
									version:SPOTIFY_API_VERSION 
									 method:@"track"
								requestType:JHSpotifySearchTrack
							   responseType:JHSpotifyTracks];

}

#pragma mark Delegate methods

- (BOOL) _isValidDelegateForSelector:(SEL)selector
{
	return ((_delegate != nil) && [_delegate respondsToSelector:selector]);
}

#pragma mark JHSpotifyParserDelegate methods

- (void)parsingSucceededForRequest:(NSString *)identifier 
                    ofResponseType:(JHSpotifyResponseType)responseType 
                 withParsedObjects:(NSArray *)parsedObjects
{
    // Forward appropriate message to _delegate, depending on responseType.
    switch (responseType) {
        case JHSpotifyAlbums:
			if ([self _isValidDelegateForSelector:@selector(albumsReceived:forRequest:)])
				[_delegate albumsReceived:parsedObjects forRequest:identifier];
			break;
        case JHSpotifyArtists:
			if ([self _isValidDelegateForSelector:@selector(artistsReceived:forRequest:)])
				[_delegate artistsReceived:parsedObjects forRequest:identifier];
            break;
        case JHSpotifyTracks:
			if ([self _isValidDelegateForSelector:@selector(tracksReceived:forRequest:)])
				[_delegate tracksReceived:parsedObjects forRequest:identifier];
            break;
        default:
            break;
    }
}

- (void)parsingFailedForRequest:(NSString *)requestIdentifier 
                 ofResponseType:(JHSpotifyResponseType)responseType 
                      withError:(NSError *)error
{
	if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)])
		[_delegate requestFailed:requestIdentifier withError:error];
}


#pragma mark NSURLConnection delegate methods

- (void)connection:(JHSpotifyHTTPURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	// Shouldn't ever happen with at version 1 of Spotify API
}


- (void)connection:(JHSpotifyHTTPURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it has enough information to create the NSURLResponse.
    // it can be called multiple times, for example in the case of a redirect, so each time we reset the data.
    [connection resetDataLength];
    
    // Get response code.
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
    int statusCode = [resp statusCode];
    
    if (statusCode >= 400) {
        // Assume failure, and report to delegate.
        NSError *error = [NSError errorWithDomain:@"HTTP" code:statusCode userInfo:nil];
		if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)])
			[_delegate requestFailed:[connection identifier] withError:error];
        
        // Destroy the connection.
        [connection cancel];
		
    } else if (statusCode == 304 ) {
        // Not modified, or generic success.
		if ([self _isValidDelegateForSelector:@selector(requestSucceeded:)])
			[_delegate requestSucceeded:[connection identifier]];
        if (statusCode == 304) {
            [self parsingSucceededForRequest:[connection identifier] 
                              ofResponseType:[connection responseType] 
                           withParsedObjects:[NSArray array]];
        }
        
        // Destroy the connection.
        [connection cancel];
		NSString *connectionIdentifier = [connection identifier];
		[_connections removeObjectForKey:connectionIdentifier];
		if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
			[_delegate connectionFinished:connectionIdentifier];
    }
  	
#if DEBUG
    if (NO) {
        // Display headers for debugging.
        NSHTTPURLResponse *resp = (NSHTTPURLResponse *)response;
        NSLog(@"JHSpotifyEngine: (%d) [%@]:\r%@", 
              [resp statusCode], 
              [NSHTTPURLResponse localizedStringForStatusCode:[resp statusCode]], 
              [resp allHeaderFields]);
    }
#endif
}


- (void)connection:(JHSpotifyHTTPURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the receivedData.
    [connection appendData:data];
	
}


- (void)connection:(JHSpotifyHTTPURLConnection *)connection didFailWithError:(NSError *)error
{
    // Inform delegate.
	if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)])
		[_delegate requestFailed:[connection identifier] withError:error];
    
}


- (void)connectionDidFinishLoading:(JHSpotifyHTTPURLConnection *)connection
{
    NSData *receivedData = [connection data];
 
	if (receivedData) {
		NSString *dataString = [NSString stringWithUTF8String:[receivedData bytes]];

#if DEBUG
		NSLog(@"JHSpotifyEngine: Succeeded! Received %d bytes of data:\r\r%@", [receivedData length], dataString);
#endif

		// Inform delegate.
		if ([self _isValidDelegateForSelector:@selector(requestSucceededWithResponse:)])
			[_delegate requestSucceeded:dataString];
    
		// Parse data from the connection in XML
		[self _parseDataForConnection:connection];
        
    }
    // Release the connection.
	NSString *connectionIdentifier = [connection identifier];
    [_connections removeObjectForKey:connectionIdentifier];
	if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
		[_delegate connectionFinished:connectionIdentifier];
	
    
}

#pragma mark Parsing methods

- (void)_parseDataForConnection:(JHSpotifyHTTPURLConnection *)connection
{
    NSString *identifier = [[[connection identifier] copy] autorelease];
    NSData *xmlData = [[[connection data] copy] autorelease];
    JHSpotifyRequestType requestType = [connection requestType];
    JHSpotifyResponseType responseType = [connection responseType];
    
	//NSURL *URL = [connection URL];
	
    switch (responseType) {
        case JHSpotifyAlbums:
            [JHSpotifyAlbumXMLParser parserWithXML:xmlData delegate:self 
							   connectionIdentifier:identifier requestType:requestType 
									   responseType:responseType];
			break;
        case JHSpotifyTracks:
            [JHSpotifyTrackXMLParser parserWithXML:xmlData delegate:self 
							   connectionIdentifier:identifier requestType:requestType 
									   responseType:responseType];
            break;
        case JHSpotifyArtists:
            [JHSpotifyArtistXMLParser parserWithXML:xmlData delegate:self 
							  connectionIdentifier:identifier requestType:requestType 
									  responseType:responseType];
			break;
        default:
            break;
    }
 
}	

#pragma mark Connection methods


- (int)numberOfConnections
{
    return [_connections count];
}


- (NSArray *)connectionIdentifiers
{
    return [_connections allKeys];
}


- (void)closeConnection:(NSString *)connectionIdentifier
{
    JHSpotifyHTTPURLConnection *connection = [_connections objectForKey:connectionIdentifier];
    if (connection) {
        [connection cancel];
        [_connections removeObjectForKey:connectionIdentifier];
		if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
			[_delegate connectionFinished:connectionIdentifier];
    }
}


- (void)closeAllConnections
{
    [[_connections allValues] makeObjectsPerformSelector:@selector(cancel)];
    [_connections removeAllObjects];
}



#pragma mark Utility methods

- (NSString *)_encodeString:(NSString *)string
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		   (CFStringRef)string, 
																		   NULL, 
																		   (CFStringRef)@";/?:@&=$+{}<>,",
																		   kCFStringEncodingUTF8);
    return [result autorelease];
}

- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
    // Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) {
        int i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", 
							   name, [self _encodeString:[params objectForKey:name]]]];
        }
    }
    
    return str;
}


#pragma mark Request methods

/** 
 * Send the HTTP GET request with all required parameters
 * |params| - the query string parameters
 * |service| - the api service, search or lookup
 * |version| - the api version
 * |method| - what are we searching for, looking up
 */
- (NSString *)_sendRequestWithParameters:(NSDictionary *)params 
									service:(NSString *)service
									version:(NSString *)version
									 method:(NSString *)method
						  	    requestType:(JHSpotifyRequestType)requestType 
							   responseType:(JHSpotifyResponseType)responseType;
{
    // Construct appropriate URL string.
    NSString *queryString = @"";
    if (params) {
        queryString = [self _queryStringWithBase:method parameters:params prefixed:YES];
    }
	
	// http://ws.spotify.com/service/version/method[.format]?parameters
	NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@", 
                           SPOTIFY_METADATA_URL,
						   service,
						   version,
                           queryString];
	
    NSURL *finalURL = [NSURL URLWithString:urlString];
    if (!finalURL) {
        return nil;
    }
	
#if DEBUG
    if (YES) {
		NSLog(@"JHSpotifyEngine: finalURL = %@", finalURL);
	}
#endif
	
    // Construct an NSMutableURLRequest for the URL and set appropriate request method.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:finalURL 
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                          timeoutInterval:URL_REQUEST_TIMEOUT];
    [request setHTTPShouldHandleCookies:NO];
    
	JHSpotifyHTTPURLConnection *connection=[[JHSpotifyHTTPURLConnection alloc] initWithRequest:request 
																					  delegate:self
																				   requestType:requestType 
																				  responseType:responseType];
	if (!connection) {
        return nil;
    } else {
        [_connections setObject:connection forKey:[connection identifier]];
        [connection release];
    }
	
	return [connection identifier];
}



@end
