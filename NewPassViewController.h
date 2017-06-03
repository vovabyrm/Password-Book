//
//  NewPassViewController.h
//  CDStaff
//
//  Created by Vladimir Burmistrov on 28.05.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDStaff+CoreDataModel.h"

@interface NewPassViewController : UIViewController

@property (strong, nonatomic) Password *data;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
