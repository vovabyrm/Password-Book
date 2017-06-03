//
//  NewCodeController.h
//  CDStaff
//
//  Created by Vladimir Burmistrov on 02.06.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CDStaff+CoreDataModel.h"
#import "NSString+MD5.h"

@interface NewCodeController : UIViewController

@property (strong, nonatomic) NSFetchedResultsController<Debtor *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) IBOutlet UIImageView *indicator1;
@property (strong, nonatomic) IBOutlet UIImageView *indicator2;
@property (strong, nonatomic) IBOutlet UIImageView *indicator3;
@property (strong, nonatomic) IBOutlet UIImageView *indicator4;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (assign, nonatomic) BOOL isFirstTime;


@end
