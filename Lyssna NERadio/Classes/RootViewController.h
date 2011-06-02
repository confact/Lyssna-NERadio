//
//  RootViewController.h
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-08-20.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
}
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@end
