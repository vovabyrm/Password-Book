//
//  MasterViewController.h
//  CDStaff
//
//  Created by Vladimir Burmistrov on 25.04.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CDStaff+CoreDataModel.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController<Debtor *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (assign, nonatomic) float totalValue;

-(void) totalCount;


@end

