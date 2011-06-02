//
//  RadioLyssnarenAppDelegate.h
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-08-20.
//  Copyright DevSnack Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioStreamer.h"
#import "DetailView.h"
#import <sqlite3.h>
#import <iAd/iAd.h>
#import <CoreData/CoreData.h>
#import "Appirater.h"
//#import "radioStation.h"

@class AudioStreamer;

@interface RadioLyssnarenAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    IBOutlet UIWindow *window;
    IBOutlet UINavigationController *navigationController;
    IBOutlet UITabBarController *tabbarController;
    DetailView *detailView;
	AudioStreamer *streamer;
    NSMutableArray *stationer;
	NSMutableArray *songs;
	NSString *url;
	BOOL uiIsVisible;
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
}
//- (void) removeStation:(radioStation)station;
//- (void) addStation:(radioStation)station;
@property (nonatomic, retain) AudioStreamer *streamer;

- (void) copyDatabaseIfNeeded;
- (void) saveAllData;
- (NSString *) getDBPath;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain) DetailView *detailView;
@property (nonatomic, retain) NSMutableArray *stationer;
@property (nonatomic, retain) NSMutableArray *songs;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabbarController;
@property (nonatomic) BOOL uiIsVisible;

@end

