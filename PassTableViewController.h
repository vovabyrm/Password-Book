//
//  PassTableViewController.h
//  CDStaff
//
//  Created by Vladimir Burmistrov on 28.05.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CDStaff+CoreDataModel.h"
#import <UIKit/UIKit.h>

@interface PassTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController<Password *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end
