//
//  SalesTableViewController.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-08-12.
//
//

#import <UIKit/UIKit.h>

@interface SalesTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction) addSale: (UIButton*) aButton;

@end
