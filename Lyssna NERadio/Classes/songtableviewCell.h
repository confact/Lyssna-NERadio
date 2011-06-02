//
//  songtableviewCell.h
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-10.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface songtableviewCell : UITableViewCell {
	UILabel *lattitle;
	UILabel *artist;
	UILabel *played;
}
@property(nonatomic,retain)	UILabel *lattitle;
@property(nonatomic,retain)	UILabel *artist;
@property(nonatomic,retain)	UILabel *played;
@end
