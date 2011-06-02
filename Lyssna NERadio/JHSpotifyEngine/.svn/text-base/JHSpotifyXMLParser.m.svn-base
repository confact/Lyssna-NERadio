//
//  JHSpotifyNSXMLParser.m
//  JHSpotifyEngine
//
//  Created by Jared Holdcroft on 01/02/2010.
//  Copyright 2009 Bitformed. All rights reserved.
//

#import "JHSpotifyXMLParser.h"


@implementation JHSpotifyXMLParser

#pragma mark Creation and Destruction


+ (id)parserWithXML:(NSData *)theXML delegate:(NSObject *)theDelegate 
connectionIdentifier:(NSString *)identifier requestType:(JHSpotifyRequestType)reqType 
       responseType:(JHSpotifyResponseType)respType
{
    id parser = [[self alloc] initWithXML:theXML 
                                 delegate:theDelegate 
                     connectionIdentifier:identifier 
                              requestType:reqType
                             responseType:respType];
    return [parser autorelease];
}


- (id)initWithXML:(NSData *)theXML delegate:(NSObject *)theDelegate 
connectionIdentifier:(NSString *)theIdentifier requestType:(JHSpotifyRequestType)reqType 
     responseType:(JHSpotifyResponseType)respType
{
    if (self = [super init]) {
        xml = [theXML retain];
        identifier = [theIdentifier retain];
        requestType = reqType;
        responseType = respType;
        delegate = theDelegate;
        parsedObjects = [[NSMutableArray alloc] initWithCapacity:0];
        
        // Set up the parser object.
        parser = [[NSXMLParser alloc] initWithData:xml];
        [parser setDelegate:self];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldResolveExternalEntities:NO];
        
        // Begin parsing.
        [parser parse];
    }
    
    return self;
}


- (void)dealloc
{
    [parser release];
    [parsedObjects release];
    [xml release];
    [identifier release];
    delegate = nil;
    [super dealloc];
}


#pragma mark NSXMLParser delegate methods


- (void)parserDidStartDocument:(NSXMLParser *)theParser
{
    NSLog(@"Parsing begun");
}


- (void)parserDidEndDocument:(NSXMLParser *)theParser
{
    NSLog(@"Parsing complete: %@", parsedObjects);
    [delegate parsingSucceededForRequest:identifier ofResponseType:responseType 
                       withParsedObjects:parsedObjects];
}


- (void)parser:(NSXMLParser *)theParser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"Started element: %@ (%@)", elementName, attributeDict);
}


- (void)parser:(NSXMLParser *)theParser foundCharacters:(NSString *)characters
{
    NSLog(@"Found characters: %@", characters);
}


- (void)parser:(NSXMLParser *)theParser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"Ended element: %@", elementName);
    [self setLastOpenedElement:nil];
    
}


- (void)parser:(NSXMLParser *)theParser foundAttributeDeclarationWithName:(NSString *)attributeName 
    forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
{
    NSLog(@"Found attribute: %@ (%@) [%@] {%@}", attributeName, elementName, type, defaultValue);
}


- (void)parser:(NSXMLParser *)theParser foundIgnorableWhitespace:(NSString *)whitespaceString
{
    NSLog(@"Found ignorable whitespace: %@", whitespaceString);
}


- (void)parser:(NSXMLParser *)theParser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Parsing error occurred: %@", parseError);
    [delegate parsingFailedForRequest:identifier ofResponseType:responseType 
                            withError:parseError];
}


#pragma mark Accessors


- (NSString *)lastOpenedElement {
    return [[lastOpenedElement retain] autorelease];
}


- (void)setLastOpenedElement:(NSString *)value {
    if (lastOpenedElement != value) {
        [lastOpenedElement release];
        lastOpenedElement = [value copy];
    }
}

@end
