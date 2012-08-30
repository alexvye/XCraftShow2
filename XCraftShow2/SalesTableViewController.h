//
//  SalesTableViewController.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-12.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Show.h"

@interface SalesTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>{
    
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Show *show;

-(IBAction) addSale: (UIButton*) aButton;
- (NSNumber*)cumulativeSales;
-(IBAction)openMail:(id)sender;
-(NSString*)generateExportBody;

@end
