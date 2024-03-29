//
//  CustomShowCell.m
//  XFloss
//
//  Created by Alex Vye on 10-08-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomShowCell.h"
#import "Show.h"

@implementation CustomShowCell

@synthesize showDateLabel;
@synthesize showNameLabel;
@synthesize eventId;

float primaryFont;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        primaryFont = 12.0;
    } else {
        primaryFont = 24.0;
    }
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//
// Programattically create cell, not through IB due to mem/perf reasons
//
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// Initialization code
		
		//
		// labels
		//
		showNameLabel = [[UILabel alloc]init];
		showNameLabel.textAlignment = UITextAlignmentLeft;
		showNameLabel.font = [UIFont fontWithName:@"Helvetica" size:primaryFont];
        showDateLabel = [[UILabel alloc]init];
		showDateLabel.textAlignment = UITextAlignmentLeft;
		showDateLabel.font = [UIFont fontWithName:@"Helvetica" size:primaryFont];
		
		//
		// custom cell
		// 
	    [self.contentView addSubview:showNameLabel];
        [self.contentView addSubview:showDateLabel];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {	
	
	//
	// labels
	//
        showDateLabel.frame = CGRectMake(boundsX+5.0,5.0,80.0,30.0);
        showNameLabel.frame = CGRectMake(boundsX+90.0,5.0,100.0,30.0);
    
    } else { //IPad
    
    //
    // labels
    //
        showDateLabel.frame = CGRectMake(boundsX+10.0,5.0,160.0,80.0);
        showNameLabel.frame = CGRectMake(boundsX+200.0,5.0,300.0,80.0);
    }

}
	 
- (void)dealloc {
}


@end
