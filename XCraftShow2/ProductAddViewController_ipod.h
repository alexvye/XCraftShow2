//
//  ProductAddViewController_ipod.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductAddViewController_ipod : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate,UITextViewDelegate,
        UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField* name;
//@property (strong, nonatomic) IBOutlet UITextView* productDescription;
@property (strong, nonatomic) IBOutlet UITextField* quantity;
@property (strong, nonatomic) IBOutlet UIButton* unitCost;
@property (strong, nonatomic) IBOutlet UIButton* defaultCost;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *selectedProduct;

- (IBAction)cancelProduct:(id)sender;
- (IBAction)saveProduct:(id)sender;
- (IBAction)openPricePicker:(id)sender;
- (IBAction)resignButton:(id)sender;
- (BOOL)doesProductExist:(NSString*)_name;
- (IBAction)takePicture:(id)sender;

@end
