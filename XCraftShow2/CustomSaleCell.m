//
//  CustomSaleCell.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-05-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomSaleCell.h"

@implementation CustomSaleCell

@synthesize saleDateLabel;
@synthesize productNameLabel;
@synthesize saleAmountLabel;
@synthesize saleQuantityLabel;

float primaryFont;
float secondaryFont;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        primaryFont = 12.0;
        secondaryFont = 10.0;
    } else {
        primaryFont = 24.0;
        secondaryFont = 20.0;
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
		productNameLabel = [[UILabel alloc]init];
		productNameLabel.textAlignment = UITextAlignmentLeft;
		productNameLabel.font = [UIFont fontWithName:@"Helvetica" size:primaryFont];
        saleDateLabel = [[UILabel alloc]init];
		saleDateLabel.textAlignment = UITextAlignmentLeft;
		saleDateLabel.font = [UIFont fontWithName:@"Helvetica" size:primaryFont];
		saleAmountLabel = [[UILabel alloc]init];
		saleAmountLabel.textAlignment = UITextAlignmentLeft;
		saleAmountLabel.font = [UIFont fontWithName:@"Helvetica" size:secondaryFont];
        saleQuantityLabel = [[UILabel alloc]init];
		saleQuantityLabel.textAlignment = UITextAlignmentLeft;
		saleQuantityLabel.font = [UIFont fontWithName:@"Helvetica" size:secondaryFont];
		
		//
		// custom cell
		// 
	    [self.contentView addSubview:productNameLabel];
        [self.contentView addSubview:saleDateLabel];
		[self.contentView addSubview:saleAmountLabel];
        [self.contentView addSubview:saleQuantityLabel];
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
        saleDateLabel.frame = CGRectMake(boundsX+5.0,2.0,100.0,20.0);
        productNameLabel.frame = CGRectMake(boundsX+110.0,2.0,100.0,20.0);
        saleAmountLabel.frame = CGRectMake(boundsX+215.0,2.0,35.0,20.0);
        saleQuantityLabel.frame = CGRectMake(boundsX+255.0,2.0,35.0,20.0);        
        
    } else { //IPad
        
        //
        // labels
        //
        saleDateLabel.frame = CGRectMake(boundsX+10,5.0,200.0,25.0);
        productNameLabel.frame = CGRectMake(boundsX+220,5.0,300.0,25.0);
        saleAmountLabel.frame = CGRectMake(boundsX+570,5.0,70.0,30.0);      
        saleQuantityLabel.frame = CGRectMake(boundsX+470,5.0,70.0,30.0); 
    }	
    
}


- (void)dealloc {
}

@end
