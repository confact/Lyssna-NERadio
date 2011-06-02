//
//  JHSpotifyGlobalHeader.h
//  JHSpotifyEngine
//
//  Created by Jared Holdcroft on 01/02/2010.
//  Copyright 2009 Bitformed. All rights reserved.
//

/*
 This file conditionally includes the correct headers for either Mac OS X or iPhone deployment.
 */

#if TARGET_OS_IPHONE
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

