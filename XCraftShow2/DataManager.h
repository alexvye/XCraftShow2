//
//  DataManager.h
//  XFloss
//
//  Created by Alex Vye on 10-08-05.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSMutableArray *shows;
extern NSMutableArray *products;
extern NSMutableArray *inventory;

@interface DataManager : NSObject {

}

+(void)startup;
@end
