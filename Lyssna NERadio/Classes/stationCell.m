//
//  stationCell.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-10.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import "stationCell.h"


@implementation stationCell
@synthesize title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		
		UIImage *backgroundImage = [UIImage imageNamed:@"cellbg.png"];
		UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.backgroundView.frame];
		bgView.image = backgroundImage;
		[self setBackgroundView: bgView];
		[bgView release];
		
		title = [[UILabel alloc]init];
		
		title.textAlignment = UITextAlignmentLeft;
		
		title.textColor = [UIColor colorWithRed:36.0/255.0
										  green:46.0/255.0
										   blue:52.0/255.0
										  alpha:1];
		title.backgroundColor = [UIColor clearColor];
		
		title.font = [UIFont systemFontOfSize:22];
		
		//title.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		
		[self.contentView addSubview:title];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		
		UIImage *backgroundImage = [UIImage imageNamed:@"cellbg.png"];
		UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.backgroundView.frame];
		bgView.image = backgroundImage;
		[self setBackgroundView: bgView];
		[bgView release];
		
		title = [[UILabel alloc]init];
		
		title.textAlignment = UITextAlignmentLeft;
		
		title.textColor = [UIColor colorWithRed:36.0/255.0
										  green:46.0/255.0
										   blue:52.0/255.0
										  alpha:1];
		title.backgroundColor = [UIColor clearColor];
		
		//title.font = [UIFont systemFontOfSize:22];
		
		title.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
		
		[self.contentView addSubview:title];
		
		
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}
- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame= CGRectMake(boundsX+10,19, 600, 24);
        title.frame = frame;
	}
    else {
        frame= CGRectMake(boundsX+10,19, 300, 24);
        title.frame = frame;
    }
	
}


- (void)dealloc {
    [super dealloc];
}


@end

