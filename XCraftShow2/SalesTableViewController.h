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

@interface SalesTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,  MFMailComposeViewControllerDelegate>{
    
}

@property (strong, nonatomic) IBOutlet UITableView* salesTableView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Show *show;

-(IBAction) addSale:(id)sender;
- (NSNumber*)cumulativeSales;
-(IBAction)openMail:(id)sender;
-(NSString*)generateExportBody;

@end
