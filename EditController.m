//
//  VBEditController.m
//  list of debtors
//
//  Created by Vladimir Burmistrov on 24.02.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import "EditController.h"
#import "MasterViewController.h"
#import "CDStaff+CoreDataModel.h"

@interface EditController ()<UINavigationControllerDelegate, UITextFieldDelegate>

@end

@implementation EditController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.tabBarController.tabBar.hidden = YES;
    //UINavigationController *navController = self.navigationController;
    //self.navigationController = navController;
    [self.valueField becomeFirstResponder];
   // self.tabBarController.tabBar.back
    if(self.detailItem)
    {
        self.valueField.text = [NSString stringWithFormat:@"%1.2f", self.detailItem.value];//self.detailItem.value;
        self.nameField.text = self.detailItem.name;
        self.date.text = [self.detailItem.timestamp.description
                          substringWithRange:NSMakeRange(0, 10)];
    }
    //self.navigationItem.backBarButtonItem
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.valueField.text floatValue] > 0)
        {
            if(!self.detailItem)
            {
            Debtor* newDebtor = [[Debtor alloc] initWithContext:_managedObjectContext];
            
            // If appropriate, configure the new managed object.
            newDebtor.timestamp = [NSDate date];
            newDebtor.name = self.nameField.text;
            newDebtor.value = [self.valueField.text floatValue];
            
            // Save the context.
            NSError *error = nil;
            if (![_managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                abort();
            }
            }else
            {
                self.detailItem.name = self.nameField.text;
                self.detailItem.value = [self.valueField.text floatValue];
                
                // Save the context.
                NSError *error = nil;
                if (![_managedObjectContext save:&error]) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }

            }
            MasterViewController* vc = [self.navigationController.viewControllers objectAtIndex:1];
            [vc totalCount];
            [vc.tableView reloadData];
        }
        self.tabBarController.tabBar.hidden = NO;
    }
    [super viewWillDisappear:animated];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.navigationController popViewControllerAnimated: YES];
    return YES;
}

@end
