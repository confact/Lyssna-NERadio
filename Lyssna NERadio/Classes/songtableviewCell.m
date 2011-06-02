//
//  songtableviewCell.m
//  RadioLyssnaren
//
//  Created by Håkan Nylén on 2010-11-10.
//  Copyright 2010 DevSnack Inc. All rights reserved.
//

#import "songtableviewCell.h"


@implementation songtableviewCell
@synthesize lattitle,artist, played;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
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
		lattitle = [[UILabel alloc]init];
		
		lattitle.textAlignment = UITextAlignmentLeft;
		
		lattitle.textColor = [UIColor colorWithRed:36.0/255.0
										   green:46.0/255.0
											blue:52.0/255.0
										   alpha:1];
		lattitle.backgroundColor = [UIColor clearColor];
		
		lattitle.font = [UIFont systemFontOfSize:18];
		
		artist = [[UILabel alloc]init];
		
		artist.textAlignment = UITextAlignmentLeft;
		
		artist.textColor = [UIColor colorWithRed:61.0/255.0
										   green:88.0/255.0
											blue:105.0/255.0
										   alpha:1];
		artist.backgroundColor = [UIColor clearColor];
		artist.font = [UIFont systemFontOfSize:13];
		
		played = [[UILabel alloc]init];
		
		played.textAlignment = UITextAlignmentLeft;
		
		played.textColor = [UIColor colorWithRed:61.0/255.0
										   green:88.0/255.0
											blue:105.0/255.0
										   alpha:1];
		played.backgroundColor = [UIColor clearColor];
		played.font = [UIFont systemFontOfSize:13];
		
		[self.contentView addSubview:lattitle];
		
		[self.contentView addSubview:artist];
		
		[self.contentView addSubview:played];
		
		
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
        frame= CGRectMake(boundsX+10,10, 700, 22);
        lattitle.frame = frame;
	
        frame= CGRectMake(boundsX+10,29, 470, 15);
        artist.frame = frame;
	
        frame= CGRectMake(boundsX+600,29, 150, 15);
        played.frame = frame;
	}
    else {
        frame= CGRectMake(boundsX+10,10, 300, 22);
        lattitle.frame = frame;
        
        frame= CGRectMake(boundsX+10,29, 170, 15);
        artist.frame = frame;
        
        frame= CGRectMake(boundsX+180,29, 150, 15);
        played.frame = frame; 
    }
}


- (void)dealloc {
    [super dealloc];
}


@end
