//
//  ShowAddViewController_ipod.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Show.h"

@interface ShowAddViewController_ipod : UIViewController<UITextFieldDelegate,UIPickerViewDelegate> {
    UIDatePicker *datePicker;
    IBOutlet UITextField* showName;
    IBOutlet NSDate* showDate;
    IBOutlet UITextField *showAddress;
    IBOutlet UITextField *showUrl;
    IBOutlet UITextField *showFee;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property(nonatomic,retain) IBOutlet UITextField* showName;
@property(nonatomic,retain) IBOutlet NSDate* showDate;
@property(nonatomic,retain) IBOutlet UITextField *showAddress;
@property(nonatomic,retain) IBOutlet UITextField *showUrl;
@property(nonatomic,retain) IBOutlet UITextField *showFee;
@property(nonatomic, retain) Show *selectedShow;

- (IBAction)saveShow:(id)sender;
- (IBAction)changeDateInLabel:(id)sender;
@end
