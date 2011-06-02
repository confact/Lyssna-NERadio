//
//  JHSpotifyNSXMLParser.h
//  JHSpotifyEngine
//
//  Created by Jared Holdcroft on 01/02/2010.
//  Copyright 2009 Bitformed. All rights reserved.
//

#import "JHSpotifyGlobalHeader.h"

#import "JHSpotifyParserDelegate.h"

@interface JHSpotifyXMLParser : NSObject {
    
	__weak NSObject <JHSpotifyParserDelegate> *delegate; // weak ref
    NSString *identifier;
    JHSpotifyRequestType requestType;
    JHSpotifyResponseType responseType;
    NSData *xml;
    NSMutableArray *parsedObjects;
    NSXMLParser *parser;
    __weak NSMutableDictionary *currentNode;
    NSString *lastOpenedElement;
}

+ (id)parserWithXML:(NSData *)theXML delegate:(NSObject *)theDelegate 
connectionIdentifier:(NSString *)identifier requestType:(JHSpotifyRequestType)reqType 
       responseType:(JHSpotifyResponseType)respType;

- (id)initWithXML:(NSData *)theXML delegate:(NSObject *)theDelegate 
connectionIdentifier:(NSString *)identifier requestType:(JHSpotifyRequestType)reqType 
     responseType:(JHSpotifyResponseType)respType;

- (NSString *)lastOpenedElement;
- (void)setLastOpenedElement:(NSString *)value;

@end