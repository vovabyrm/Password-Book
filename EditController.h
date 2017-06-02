//
//  VBEditController.h
//  list of debtors
//
//  Created by Vladimir Burmistrov on 24.02.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDStaff+CoreDataModel.h"


@interface EditController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *valueField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) Debtor *detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end
