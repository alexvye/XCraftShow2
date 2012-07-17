//
//  CustomSaleCell.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-05-30.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *CustomSaleCellIdentifier = @"CustomSaleCell";

@interface CustomSaleCell : UITableViewCell {
    IBOutlet UILabel  *saleDateLabel;
    IBOutlet UILabel  *saleAmountLabel;
    IBOutlet UILabel  *saleQuantityLabel;
    IBOutlet UILabel  *productNameLabel;
}

@property (nonatomic,retain)IBOutlet UILabel  *saleDateLabel;
@property (nonatomic,retain)IBOutlet UILabel  *saleAmountLabel;
@property (nonatomic,retain)IBOutlet UILabel  *productNameLabel;
@property (nonatomic,retain)IBOutlet UILabel  *saleQuantityLabel;

@end
