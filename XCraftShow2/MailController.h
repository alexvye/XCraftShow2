//
//  MailController.h
//  XCraftShow2
//
//  Created by Alex Vye on 12-07-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MailController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)openMail:(id)sender;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
