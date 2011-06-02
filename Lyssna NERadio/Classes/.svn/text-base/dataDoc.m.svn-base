//
//  database.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-08.
//  Copyright 2010 DevSnack Club. All rights reserved.
//

#import "dataDoc.h"
#pragma mark NSCoding

#define kTitleKey       @"Name"
#define kRatingKey      @"url"
#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@implementation database
@synthesize docPath = _docPath;

- (id)init {
    if ((self = [super init])) {        
    }
    return self;
}
- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeFloat:_rating forKey:kRatingKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *title = [decoder decodeObjectForKey:kTitleKey];
    float rating = [decoder decodeFloatForKey:kRatingKey];
    return [self initWithTitle:title rating:rating];
}
- (BOOL)createDataPath {
	
    if (_docPath == nil) {
        self.docPath = [ScaryBugDatabase nextScaryBugDocPath];
    }
	
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;
	
}
- (database *)data {
	
    if (_data != nil) return _data;
	
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[[NSData alloc] initWithContentsOfFile:dataPath] autorelease];
    if (codedData == nil) return nil;
	
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [[unarchiver decodeObjectForKey:kDataKey] retain];    
    [unarchiver finishDecoding];
    [unarchiver release];
	
    return _data;
	
}
- (void)saveData {
	
    if (_data == nil) return;
	
    [self createDataPath];
	
    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];          
    [archiver encodeObject:_data forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    [archiver release];
    [data release];
	
}
- (void)deleteDoc {
	
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
	
}
-(void)dealloc
{
	[_docPath release];
	_docPath = nil;	
}
@end
