//
//  radioStation.m
//  Lyssna NERadio
//
//  Created by Håkan Nylén on 2011-02-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "radioStation.h"
#import "song.h"


@implementation radioStation
@dynamic changed;
@dynamic id;
@dynamic name;
@dynamic url;
@dynamic station;

- (void)addStationObject:(song *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"station" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"station"] addObject:value];
    [self didChangeValueForKey:@"station" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeStationObject:(song *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"station" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"station"] removeObject:value];
    [self didChangeValueForKey:@"station" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addStation:(NSSet *)value {    
    [self willChangeValueForKey:@"station" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"station"] unionSet:value];
    [self didChangeValueForKey:@"station" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeStation:(NSSet *)value {
    [self willChangeValueForKey:@"station" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"station"] minusSet:value];
    [self didChangeValueForKey:@"station" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
