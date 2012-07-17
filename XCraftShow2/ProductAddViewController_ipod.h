//
//  ProductAddViewController_ipod.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductAddViewController_ipod : UIViewController <UITextFieldDelegate,UITextViewDelegate> {
    IBOutlet UITextView* productDescription;
    IBOutlet UITextField* name;
    IBOutlet UITextField* quantity;
    IBOutlet UITextField* unitCost;
    IBOutlet UITextField* defaultCost;
}

@property (nonatomic, retain) IBOutlet UITextField* name;
@property (nonatomic, retain) IBOutlet UITextView* productDescription;
@property (nonatomic, retain) IBOutlet UITextField* quantity;
@property (nonatomic, retain) IBOutlet UITextField* unitCost;
@property (nonatomic, retain) IBOutlet UITextField* defaultCost;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *selectedProduct;

- (IBAction)saveProduct:(id)sender;
- (BOOL) doesProductExist:(NSString*)_name;

@end
