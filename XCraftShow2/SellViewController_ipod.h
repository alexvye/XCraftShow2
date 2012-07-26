//
//  SellViewController_ipod.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSaleCell.h"
#import "Show.h"
#import <MessageUI/MessageUI.h>

@interface SellViewController_ipod : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>{
    
    IBOutlet UITableView* salesTable;
    IBOutlet UIButton* sellButton;
    IBOutlet UITextField* price;
    IBOutlet UITextField* quantity;
    IBOutlet UILabel* showDate;
    IBOutlet UILabel* showName;
    IBOutlet UILabel* productName;
}

@property(nonatomic, retain) Show* show;
@property(nonatomic, retain) IBOutlet UITableView* salesTable;
@property(nonatomic, retain) IBOutlet UIButton* sellButton;
@property(nonatomic, retain) IBOutlet UITextField* price;
@property(nonatomic, retain) IBOutlet UITextField* quantity;
@property(nonatomic, retain) IBOutlet UILabel* showDate;
@property(nonatomic, retain) IBOutlet UILabel* showName;
@property(nonatomic, retain) IBOutlet UILabel* productName;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSArray*)getProducts;
- (void)configureCell:(CustomSaleCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (IBAction)saveSale:(id)sender;
- (NSNumber*)cumulativeSales;
-(NSArray*)sortedSales:(NSArray*)_sales;
-(void)playSound;
-(IBAction) selectProduct:(id)sender;
-(IBAction)openMail:(id)sender;
-(NSString*) generateExportBody;
@end

