//
//  song.h
//  Lyssna NERadio
//
//  Created by Håkan Nylén on 2011-02-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class radioStation;

@interface song : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * added;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) radioStation * songs;

@end
