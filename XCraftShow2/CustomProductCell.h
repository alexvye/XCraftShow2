//
//  CustomProductCell.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-09-03.
//
//

#import <UIKit/UIKit.h>

@interface CustomProductCell : UITableViewCell {
    IBOutlet UIImageView *flossImage;
    IBOutlet UILabel  *primaryLabel;
    IBOutlet UILabel  *secondaryLabel;
}

@property (nonatomic,retain)IBOutlet UIImageView *flossImage;
@property (nonatomic,retain)IBOutlet UILabel  *primaryLabel;
@property (nonatomic,retain)IBOutlet UILabel  *secondaryLabel;

@end
