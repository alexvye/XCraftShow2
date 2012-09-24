//
//  Contact.h
//  XCraftShow2
//
//  Created by Alex Vye on 2012-09-24.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Show;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) Show *showRel;

@end
