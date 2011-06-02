//
//  JHSpotifyParserDelegate.h
//  JHSpotifyParser
//
//  Created by Jared Holdcroft on 01/02/2010.
//  Copyright 2009 Bitformed. All rights reserved.
//

#import "JHSpotifyGlobalHeader.h"

#import "JHSpotifyRequestTypes.h"

@protocol JHSpotifyParserDelegate

- (void)parsingSucceededForRequest:(NSString *)identifier 
                    ofResponseType:(JHSpotifyResponseType)responseType 
                 withParsedObjects:(NSArray *)parsedObjects;

- (void)parsingFailedForRequest:(NSString *)requestIdentifier 
                 ofResponseType:(JHSpotifyResponseType)responseType 
                      withError:(NSError *)error;


@end
