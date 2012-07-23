//
//  CustomProductCell.m
//  XCraftShow2
//
//  Created by Alex Vye on 12-05-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomProductCell.h"
#import "Product.h"
#import "Utilities.h"

@implementation CustomProductCell
@synthesize productImage;
@synthesize productNameLabel,productDateLabel;
@synthesize quantityTextField;

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
		// images
		//
		productImage = [[UIImageView alloc]init];
		
		//
		// labels
		//
		productNameLabel = [[UILabel alloc]init];
		productNameLabel.textAlignment = UITextAlignmentLeft;
		productNameLabel.font = [UIFont fontWithName:@"Helvetica" size:primaryFont];
        productDateLabel = [[UILabel alloc]init];
		productDateLabel.textAlignment = UITextAlignmentLeft;
		productDateLabel.font = [UIFont fontWithName:@"Helvetica" size:primaryFont];
        
        //
        // text fields
        //
        
        quantityTextField = [[UITextField alloc] init];
        [quantityTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [quantityTextField setReturnKeyType:UIReturnKeyDone];
        quantityTextField.delegate = self;
        quantityTextField.textAlignment = UITextAlignmentRight;
        quantityTextField.clearsOnBeginEditing = YES;
        quantityTextField.borderStyle = UITextBorderStyleBezel;
        quantityTextField.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
        quantityTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		
		//
		// custom cell
		// 
	    [self.contentView addSubview:productNameLabel];
        [self.contentView addSubview:productDateLabel];
        [self.contentView addSubview:productImage];
		[self.contentView addSubview:quantityTextField];        
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
        productImage.frame = CGRectMake(boundsX+5.0,5.0,40.0,30.0);
        
        //
        // labels
        //
        productNameLabel.frame = CGRectMake(boundsX+50.0,5.0,135.0,30.0);
        
        //
        // text fields
        //
        quantityTextField.frame = CGRectMake(boundsX+190.0,5.0,60.0,30.0);
        
    } else { //IPad
        //
        // images
        //
        productImage.frame = CGRectMake(boundsX+10.0,5.0,80.0,80.0);
        
        //
        // labels
        //
        productNameLabel.frame = CGRectMake(boundsX+100,5.0,300.0,42.0);
        productDateLabel.frame = CGRectMake(boundsX+100,52.0,300.0,42.0);
        
        //
        // text fields
        //
        quantityTextField.frame = CGRectMake(boundsX+510,5.0,80.0,80.0);    
    }	
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //
    // convert the string to a number. nil if invalid, becomes 0
    //
    NSNumber *quantity = [NUMBER_FORMATTER numberFromString:[(UITextField *)[self quantityTextField] text]];
    if(quantity == nil) {
        quantity = [NSNumber numberWithInt:0];
    }
}


- (void)dealloc {
}


@end
