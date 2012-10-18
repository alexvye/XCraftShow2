//
//  ProductAddViewController_ipod.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductAddViewController_ipod : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* name;
@property (strong, nonatomic) IBOutlet UITextField* unitCostTextField;
@property (strong, nonatomic) IBOutlet UITextField* defaultPriceTextField;
@property (strong, nonatomic) IBOutlet UIImageView* productImageView;
@property (strong, nonatomic) IBOutlet UITextField* quantity;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *selectedProduct;
@property (strong, nonatomic) NSData* image;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

- (IBAction)cancelProduct:(id)sender;
- (IBAction)saveProduct:(id)sender;
- (IBAction)resignButton:(id)sender;
- (BOOL)doesProductExist:(NSString*)_name;
- (IBAction)takePicture:(id)sender;
@end
