//
//  main.m
//  Lyssna NERadio
//
//  Created by Håkan Nylén on 2011-02-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lyssna_NERadioAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([Lyssna_NERadioAppDelegate class]));
    [pool release];
    return retVal;
}
