//
//  MasterViewController.m
//  CDStaff
//
//  Created by Vladimir Burmistrov on 25.04.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "EditController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self totalCount];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //[self performSegueWithIdentifier:@"Autent" sender:self];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)insertNewObject:(id)sender {
    /*NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    Debtor* newDebtor = [[Debtor alloc] initWithContext:context];
        
    // If appropriate, configure the new managed object.
    newDebtor.timestamp = [NSDate date];
    newDebtor.name = @"VASA";
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }*/
    /*EditController* destination = [[EditController alloc] init];
    UIStoryboardSegue* segue = [[UIStoryboardSegue alloc] initWithIdentifier:
                                @"create" source:self destination:destination];
    [segue perform];*/
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (void) totalCount
{
    NSExpression *keyExpression = [NSExpression expressionForKeyPath:@"value"];
    NSExpression *sumExpression = [NSExpression expressionForFunction:@"sum:" arguments:@[keyExpression]];
    
    NSExpressionDescription *sumDescription = [[NSExpressionDescription alloc] init];
    sumDescription.name = @"sumOfSeconds";
    sumDescription.expression = sumExpression;
    [sumDescription setExpressionResultType:NSDecimalAttributeType];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Debtor"];
    request.resultType = NSDictionaryResultType;
    [request setPropertiesToFetch:@[sumDescription]];
    
    NSError *error = nil;
    //NSManagedObjectContext *context = ... //get the context somehow
    NSArray* fetchResult = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSNumber *sum = fetchResult.firstObject[sumDescription.name];
    self.totalValue = [sum floatValue];
    NSLog(@"%f", self.totalValue);
    self.navigationItem.title = [NSString stringWithFormat:@"Total - %1.2f", self.totalValue];
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        EditController *controller = (EditController *)[segue destinationViewController];
        if([self.tableView indexPathForSelectedRow])
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            Debtor *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [controller setDetailItem:object];
        }
        controller.managedObjectContext = [self.fetchedResultsController managedObjectContext];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonSystemItemDone target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:backItem];
    }
    if ([[segue identifier] isEqualToString:@"create"]) {
        EditController *controller = (EditController *)[segue destinationViewController];
        controller.managedObjectContext = [self.fetchedResultsController managedObjectContext];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Debtor *debtor = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withEvent:debtor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", debtor.value];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
        [self totalCount];
    }
}


- (void)configureCell:(UITableViewCell *)cell withEvent:(Debtor *)debtor {
    cell.textLabel.text = debtor.name;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%f",debtor.value];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController<Debtor *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Debtor *> *fetchRequest = Debtor.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<Debtor *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[self totalCount];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[self totalCount];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withEvent:anObject];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
