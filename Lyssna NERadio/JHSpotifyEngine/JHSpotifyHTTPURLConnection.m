//
//  JHSpotifyHTTPURLConnection.m
//  JHSpotifyEngine
//
//  Created by Jared Holdcroft on 01/02/2010.
//  Copyright 2010 Bitformed. All rights reserved.
//

#import "JHSpotifyHTTPURLConnection.h"

#import "NSString+UUID.h"


@implementation JHSpotifyHTTPURLConnection


#pragma mark Initializer


- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate 
          requestType:(JHSpotifyRequestType)requestType responseType:(JHSpotifyResponseType)responseType
{
    if (self = [super initWithRequest:request delegate:delegate]) {
        _data = [[NSMutableData alloc] initWithCapacity:0];
        _identifier = [[NSString stringWithNewUUID] retain];
        _requestType = requestType;
        _responseType = responseType;
		_URL = [[request URL] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [_data release];
    [_identifier release];
	[_URL release];
    [super dealloc];
}


#pragma mark Data helper methods


- (void)resetDataLength
{
    [_data setLength:0];
}


- (void)appendData:(NSData *)data
{
    [_data appendData:data];
}


#pragma mark Accessors


- (NSString *)identifier
{
    return [[_identifier retain] autorelease];
}


- (NSData *)data
{
    return [[_data retain] autorelease];
}


- (NSURL *)URL
{
    return [[_URL retain] autorelease];
}


- (JHSpotifyRequestType)requestType
{
    return _requestType;
}


- (JHSpotifyResponseType)responseType
{
    return _responseType;
}


- (NSString *)description
{
    NSString *description = [super description];
    
    return [description stringByAppendingFormat:@" (requestType = %d, identifier = %@)", _requestType, _identifier];
}


@end
