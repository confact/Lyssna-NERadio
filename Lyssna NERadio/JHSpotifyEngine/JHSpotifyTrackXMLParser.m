//
//  JHSpotifyTrackXMLParser.m
//  JHSpotifyEngine
//
//  Created by Jared Holdcroft on 07/02/2010.
//  Copyright 2010 Bitformed. All rights reserved.
//

#import "JHSpotifyTrackXMLParser.h"


@implementation JHSpotifyTrackXMLParser

#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)theParser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict
{
    NSLog(@"Started element: %@ (%@)", elementName, attributeDict);
    [self setLastOpenedElement:elementName];
    
    if ([elementName isEqualToString:@"track"]) {
        // Make new entry in parsedObjects.
        NSMutableDictionary *newNode = [NSMutableDictionary dictionaryWithCapacity:0];
		// Adding href attribute as dict entry
		if ([attributeDict objectForKey:@"href"] != nil) {
			[newNode setObject:[attributeDict objectForKey:@"href"] forKey:@"href"];
		}
		[parsedObjects addObject:newNode];
        currentNode = newNode;
    } else if ([elementName isEqualToString:@"artist"] ) {
        // Add an appropriate dictionary to current node.
        NSMutableDictionary *newNode = [NSMutableDictionary dictionaryWithCapacity:0];
		// Adding href attribute as dict entry
		if ([attributeDict objectForKey:@"href"] != nil) {
			[newNode setObject:[attributeDict objectForKey:@"href"] forKey:@"href"];
		}
        [currentNode setObject:newNode forKey:elementName];
        currentNode = newNode;
    } else if ([elementName isEqualToString:@"album"] ) {
        // Add an appropriate dictionary to current node.
        NSMutableDictionary *newNode = [NSMutableDictionary dictionaryWithCapacity:0];
		// Adding href attribute as dict entry
		if ([attributeDict objectForKey:@"href"] != nil) {
			[newNode setObject:[attributeDict objectForKey:@"href"] forKey:@"href"];
		}
        [currentNode setObject:newNode forKey:elementName];
        currentNode = newNode;
    } else if ([elementName isEqualToString:@"availability"] ) {
        // Add an appropriate dictionary to current node.
        NSMutableDictionary *newNode = [NSMutableDictionary dictionaryWithCapacity:0];
        [currentNode setObject:newNode forKey:elementName];
        currentNode = newNode;
    } else if (currentNode) {
        // Create relevant name-value pair.
        [currentNode setObject:[NSMutableString string] forKey:elementName];
    }
}


- (void)parser:(NSXMLParser *)theParser foundCharacters:(NSString *)characters
{
    NSLog(@"Found characters: %@ ", characters);
    // Append found characters to value of lastOpenedElement in currentNode.
    if (lastOpenedElement && currentNode) {
        [[currentNode objectForKey:lastOpenedElement] appendString:characters];
    }
}


- (void)parser:(NSXMLParser *)theParser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"Ended element: %@", elementName);
    [super parser:theParser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    
	if ([elementName isEqualToString:@"track"]) {
        currentNode = nil;
    } else if ([elementName isEqualToString:@"availability"] ) {
        currentNode = [parsedObjects lastObject];
    } else if ([elementName isEqualToString:@"artist"] ) {
        currentNode = [parsedObjects lastObject];
	} else if ([elementName isEqualToString:@"album"] ) {
        currentNode = [parsedObjects lastObject];
	}
}


@end