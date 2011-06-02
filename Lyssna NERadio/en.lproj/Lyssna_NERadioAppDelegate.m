//
//  Lyssna_NERadioAppDelegate.m
//  Lyssna NERadio
//
//  Created by Håkan Nylén on 2011-02-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Lyssna_NERadioAppDelegate.h"
#import "radioStation.h"
#import "radiostationerTableViewController.h"
#import "song.h"
//#import "navigationbar.h"
/*
 @interface UINavigationBar (MyCustomNavBar)
 @end
 @implementation UINavigationBar (MyCustomNavBar)
 - (void) drawRect:(CGRect)rect {
 UIImage *barImage = [UIImage imageNamed:@"navbg.png"];
 [barImage drawInRect:rect];
 }
 @end
 */

@implementation Lyssna_NERadioAppDelegate

@synthesize window;
//@synthesize navigationController;
@synthesize tabbarController;
@synthesize streamer;
@synthesize stationer;
@synthesize url;
@synthesize uiIsVisible;
@synthesize detailView;
@synthesize songs;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    //void initSettingsDefaults();

	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.stationer = tempArray;
    [tempArray release];
	tempArray = [[NSMutableArray alloc] init];
    self.songs = tempArray;
	[tempArray release];
    //Copy database to the user's phone if needed.
    //[self copyDatabaseIfNeeded];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	/*
	 radioStation *failedBankInfo = [NSEntityDescription
     insertNewObjectForEntityForName:@"radioStation" 
     inManagedObjectContext:context];
     failedBankInfo.name = @"Radioseven";
     failedBankInfo.url = @"http://sc5.radioseven.se:8002";
     */
	
	NSError *error;
	/*
     if (![context save:&error]) {
     NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
     }
     */
	// Test listing all FailedBankInfos from the store
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"radioStation" 
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (radioStation *info in fetchedObjects) {
		[self.stationer addObject:info];
	}
	[fetchRequest release];
    
	fetchRequest = [[NSFetchRequest alloc] init];
	entity = [NSEntityDescription entityForName:@"song" 
                         inManagedObjectContext:context];
    
	[fetchRequest setEntity:entity];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"added" ascending:NO];
	
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
	
	fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (song *info in fetchedObjects) {
		[self.songs addObject:info];
	}
	[fetchRequest release];
	
    //Initialize the coffee array.
    
    //Once the db is copied, get the initial data to display on the screen.
	//self.db = [FMDatabase databaseWithPath:[self getDBPath]];
    //[radioStation getInitialDataToDisplay];
    //radiostationerTableViewController *rootViewController = (radiostationerTableViewController *)[navigationController topViewController];
	
	//rootViewController.managedObjectContext = context;
	// Configure and show the window
    //[tabbarController.navigationController.navigationBar setBackgroundColor:[UIColor colorWithHue:219 saturation:41 brightness:73 alpha:1]];
    
    [window addSubview:[tabbarController view]];
    [window makeKeyAndVisible];
	[Appirater appLaunched:YES];
}

/** Loads user preferences database from Settings.bundle plists. */
+ (void)initSettingsDefaults
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	//Determine the path to our Settings.bundle.
	NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
	NSString *settingsBundlePath = [bundlePath stringByAppendingPathComponent:@"Settings.bundle"];
    
	// Load paths to all .plist files from our Settings.bundle into an array.
	NSArray *allPlistFiles = [NSBundle pathsForResourcesOfType:@"plist" inDirectory:settingsBundlePath];
    
	// Put all of the keys and values into one dictionary,
	// which we then register with the defaults.
	NSMutableDictionary *preferencesDictionary = [NSMutableDictionary dictionary];
    
	// Copy the default values loaded from each plist
	// into the system's sharedUserDefaults database.
	NSString *plistFile;
	for (plistFile in allPlistFiles)
	{
        
		// Load our plist files to get our preferences.
		NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
		NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
        
		// Iterate through the specifiers, and copy the default
		// values into the DB.
		NSDictionary *item;
		for(item in preferencesArray)
		{
			// Obtain the specifier's key value.
			NSString *keyValue = [item objectForKey:@"Key"];
            
			// Using the key, return the DefaultValue if specified in the plist.
			// Note: We won't know the object type until after loading it.
			id defaultValue = [item objectForKey:@"DefaultValue"];
            
			// Some of the items, like groups, will not have a Key, let alone
			// a default value.  We want to safely ignore these.
			if (keyValue && defaultValue)
			{
				[preferencesDictionary setObject:defaultValue forKey:keyValue];
			}
            
		}
        
	}
    
    NSString *spotifyKey    = @"SpotifyBought";
    NSDate *lastRead    = [[NSUserDefaults standardUserDefaults] objectForKey:spotifyKey];
    if (lastRead == nil)     // App first run: set up user defaults.
    {        
        // do any other initialization you want to do here - e.g. the starting default values.    
        // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"should_play_sounds"];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:spotifyKey];
    }
	// Ensure the version number is up-to-date, too.
	// This is, incidentally, how you update the value in a Title element.

    
	// Now synchronize the user defaults DB in memory
	// with the persistent copy on disk.
	[standardUserDefaults registerDefaults:preferencesDictionary];
	[standardUserDefaults synchronize];
}


- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];
    return managedObjectContext;
}
/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"radioStation" ofType:@"momd"];
	NSLog(@"Getting path to datamodel: %@", modelPath);
	NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL]; 
    return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	NSString *defaultStorePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"radiostationDatabase" ofType:@"sqlite"];
	NSString *oldStorePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"radiostationDatabase.sqlite"];
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"radiostationDatabase.sqlite"];
	
	NSError *error;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:storePath]) 
	{
		if (![[NSFileManager defaultManager] copyItemAtPath:defaultStorePath toPath:storePath error:&error])
			NSLog(@"Error copying default DB to %@ (%@)", storePath, error);
	}
	error = nil;
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
    
    return persistentStoreCoordinator;
}
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void) copyDatabaseIfNeeded {
    
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"radiostationDatabase.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}
- (NSString *) getDBPath {
    
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"radiostationDatabase.sqlite"];
}

- (void) addStation:(radioStation *)station {
    
    //Add it to the database.
    [station addStation];
    
    //Add it to the coffee array.
    [stationer addObject:station];
}
- (void) removeStation:(radioStation *)station {
    
    //Delete it from the database.
    [station deleteStation];
    
    //Remove it from the array.
    [stationer removeObject:station];
}
- (void)presentAlertWithTitle:(NSNotification *)notification
{
	if (!uiIsVisible)
		return;
	NSString *title = [[notification userInfo] objectForKey:@"title"];
	NSString *message = [[notification userInfo] objectForKey:@"message"];
#ifdef TARGET_OS_IPHONE
	UIAlertView *alert = [
						  [[UIAlertView alloc]
						   initWithTitle:title
						   message:message
						   delegate:self
						   cancelButtonTitle:NSLocalizedString(@"OK", @"")
						   otherButtonTitles: nil]
						  autorelease];
	[alert
	 performSelector:@selector(show)
	 onThread:[NSThread mainThread]
	 withObject:nil
	 waitUntilDone:NO];
#else
	NSAlert *alert =
	[NSAlert
	 alertWithMessageText:title
	 defaultButton:NSLocalizedString(@"OK", @"")
	 alternateButton:nil
	 otherButton:nil
	 informativeTextWithFormat:message];
	[alert
	 performSelector:@selector(runModal)
	 onThread:[NSThread mainThread]
	 withObject:nil
	 waitUntilDone:NO];
#endif
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	self.uiIsVisible = NO;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	self.uiIsVisible = NO;
	//[self.stationer makeObjectsPerformSelector:@selector(saveAllData)];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	self.uiIsVisible = YES;
    [self.detailView forceUIUpdate];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(presentAlertWithTitle:)
	 name:ASPresentAlertWithTitleNotification
	 object:nil];
	[Appirater appEnteredForeground:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	self.uiIsVisible = YES;
	[self.detailView forceUIUpdate];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	self.uiIsVisible = NO;
    //[self saveAllData];
	NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
    [[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:ASPresentAlertWithTitleNotification
	 object:nil];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    //Save all the dirty coffee objects and free memory.
    //[self saveAllData];
}
- (void) saveAllData
{
	//[self.db executeQuery:@"DELETE * FROM stations"];
	for (int i = 0; i<[self.stationer count]; i++) {
		radioStation *radio = [self.stationer objectAtIndex:i];
        
		
		//[self.db executeUpdate:@"insert into stations(name, url, id) Values(?, ?, ?)" , [radio.name UTF8String], [radio.url UTF8String], [NSNumber numberWithInt:radio.id]];
		//[radio release];
	}
}

- (void)dealloc {
    [detailView release];
    [streamer release];
    [stationer release];
    [tabbarController release];
	[songs release];
	//[navigationController release];
	[window release];
	[super dealloc];
}


@end
