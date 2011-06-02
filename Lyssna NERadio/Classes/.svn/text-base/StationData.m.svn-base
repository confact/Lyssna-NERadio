//
//  untitled.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-08.
//  Copyright 2010 DevSnack Club. All rights reserved.
//

#import "StationData.h"
#import "RadioLyssnarenAppDelegate.h"
#import "radioStation.h"

@implementation StationData
-(void)init
{
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
	NSString *documentsDirectory = [paths objectAtIndex:0]; //2
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Stationdata.plist"]; //3
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if (![fileManager fileExistsAtPath: path]) //4
	{
		NSString *bundle = [[NSBundle mainBundle] pathForResource:@”dokument” ofType:@”plist”]; //5
		
		[fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
	}
}
-(void)saveData:(NSIndexPath)indexpath
{
	NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
	
	NSString *stationDataName = "name";
	NSString *stationDataName = "url";
	
	
	
	//load from savedStock example int value
	int value;
	value = [[savedStock objectForKey:@"value"] intValue];
	
	[savedStock release];
}
@end
