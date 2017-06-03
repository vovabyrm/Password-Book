//
//  NewPassViewController.m
//  CDStaff
//
//  Created by Vladimir Burmistrov on 28.05.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import "NewPassViewController.h"
#import "PassTableViewController.h"

@interface NewPassViewController () <UINavigationControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *passField;

@end

@implementation NewPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameField becomeFirstResponder];
    if(self.data)
    {
        self.nameField.text = [NSString stringWithFormat:@"%@", self.data.name];//self.detailItem.value;
        self.passField.text = [NSString stringWithFormat:@"%@", self.data.pass];
    }

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
        if(![self.nameField.text isEqualToString:@""] && ![self.passField.text isEqualToString:@""])
        {
            //NSLog(@"%@,%@",self.nameField.text, self.passField.text);
            if(!self.data)
            {
                Password* newData = [[Password alloc] initWithContext:_managedObjectContext];
                
                // If appropriate, configure the new managed object.
                newData.name = self.nameField.text;
                newData.pass = self.passField.text;
                
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
                self.data.name = self.nameField.text;
                self.data.pass = self.passField.text;
                
                // Save the context.
                NSError *error = nil;
                if (![_managedObjectContext save:&error]) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
                
            }
            //PassTableViewController* vc = [self.navigationController.viewControllers objectAtIndex:1];
            //[vc totalCount];
            //[vc.tableView reloadData];
        }
        self.tabBarController.tabBar.hidden = NO;
    }
    [super viewWillDisappear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PassTableViewController *controller = (PassTableViewController *)[segue destinationViewController];
    [controller.tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.nameField])
    {
        [self.passField becomeFirstResponder];
    }else if ([textField isEqual:self.passField]){
    [self.navigationController popViewControllerAnimated: YES];
    }
    return YES;
}

@end
