//
//  ShowViewController_ipod.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-27.
//
//

#import <UIKit/UIKit.h>

@interface ShowViewController_ipod : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UIDatePicker* datePicker;
    IBOutlet UIPickerView* feePicker;
    IBOutlet UITextField* feeTextField;
    IBOutlet UITextField* nameTextField;
}

@property(nonatomic,retain) IBOutlet UIDatePicker* datePicker;
@property(nonatomic,retain) IBOutlet UIPickerView* feePicker;
@property(nonatomic,retain) IBOutlet UITextField* feeTextField;
@property(nonatomic,retain) IBOutlet UITextField* nameTextField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)cancelShow:(id)sender;
- (IBAction)saveShow:(id)sender;

@end
