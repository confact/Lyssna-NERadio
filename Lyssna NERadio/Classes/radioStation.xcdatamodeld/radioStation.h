//
//  radioStation.h
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2011-01-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class song;

@interface radioStation :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * changed;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet* station;

@end


@interface radioStation (CoreDataGeneratedAccessors)
- (void)addStationObject:(song *)value;
- (void)removeStationObject:(song *)value;
- (void)addStation:(NSSet *)value;
- (void)removeStation:(NSSet *)value;

@end

