//
//  CustomShowCell.h
//  XFloss
//
//  Created by Alex Vye on 10-08-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *CustomShowCellIdentifier = @"CustomShowCell";

@interface CustomShowCell : UITableViewCell {
	IBOutlet UILabel  *showDateLabel;
	IBOutlet UILabel  *showProfitLabel;
    IBOutlet UILabel  *showNameLabel;
}

@property (nonatomic,retain)IBOutlet UILabel  *showDateLabel;
@property (nonatomic,retain)IBOutlet UILabel  *showProfitLabel;
@property (nonatomic,retain)IBOutlet UILabel  *showNameLabel;

@end
