//
//  radioStation.h
//  Lyssna NERadio
//
//  Created by Håkan Nylén on 2011-02-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class song;

@interface radioStation : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * changed;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet* station;

@end
