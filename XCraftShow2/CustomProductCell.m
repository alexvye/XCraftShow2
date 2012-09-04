//
//  CustomProductCell.m
//  XCraftShow2
//
//  Created by Alex Vye on 2012-09-03.
//
//

#import "CustomProductCell.h"

@implementation CustomProductCell

@synthesize flossImage;
@synthesize primaryLabel;
@synthesize secondaryLabel;

float primaryFont;
float secondaryFont;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        primaryFont = 12.0;
        secondaryFont = 10.0;
    } else {
        primaryFont = 36.0;
        secondaryFont = 24.0;
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
		primaryLabel = [[UILabel alloc]init];
		primaryLabel.textAlignment = UITextAlignmentLeft;
		primaryLabel.font = [UIFont fontWithName:@"Helvetica" size:primaryFont];
		secondaryLabel = [[UILabel alloc]init];
		secondaryLabel.textAlignment = UITextAlignmentLeft;
		secondaryLabel.font = [UIFont fontWithName:@"Helvetica" size:secondaryFont];
		
		//
		// images
		//
		flossImage = [[UIImageView alloc]init];
        
		//
		// custom cell
		//
	    [self.contentView addSubview:primaryLabel];
		[self.contentView addSubview:secondaryLabel];
		[self.contentView addSubview:flossImage];
	}
	return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //
        // images
        //
        flossImage.frame = CGRectMake(boundsX+1.0,2.0,40.0,40.0);
        
        //
        // labels
        //
        primaryLabel.frame = CGRectMake(boundsX+44.0,0.0,38.0,20.0);
        secondaryLabel.frame = CGRectMake(boundsX+49.0,16.0,97.0,20.0);
        
    } else { //IPad
        //
        // images
        //
        flossImage.frame = CGRectMake(boundsX+10.0,10.0,79.0,79);
        
        //
        // labels
        //
        primaryLabel.frame = CGRectMake(boundsX+120,10.0,380.0,79.0);
        secondaryLabel.frame = CGRectMake(boundsX+510.0,10.0,210,79.0);
    }
}


- (void)dealloc {
}


@end

