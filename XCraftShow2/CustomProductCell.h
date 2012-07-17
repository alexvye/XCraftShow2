//
//  CustomProductCell.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-05-27.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *CustomProductCellIdentifier = @"CustomShowCell";

@interface CustomProductCell  : UITableViewCell <UITextFieldDelegate> {
	IBOutlet UIImageView  *productImage;
	IBOutlet UILabel  *productNameLabel;
    IBOutlet UITextField  *quantityTextField;    
    IBOutlet UILabel  *productDateLabel; 
}

@property (nonatomic,retain)IBOutlet UIImageView  *productImage;
@property (nonatomic,retain)IBOutlet UILabel  *productNameLabel;
@property (nonatomic,retain)IBOutlet UILabel  *productDateLabel;
@property (nonatomic,retain)IBOutlet UITextField  *quantityTextField;

@end
