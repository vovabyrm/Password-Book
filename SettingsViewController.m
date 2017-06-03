//
//  SettingsViewController.m
//  CDStaff
//
//  Created by Vladimir Burmistrov on 02.06.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import "SettingsViewController.h"
#import "NewCodeController.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *swithcPropery;
@property (strong, nonatomic) IBOutlet UITableViewCell *TouchIDCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *passcodeCell;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Settings"];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error, no ent");
    }
    Settings* settings = [results firstObject];

    [self.swithcPropery setOn:settings.isTouchID];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TIDSwitch:(id)sender {
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Settings"];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error, no ent");
    }else{
        Settings* settings = [results firstObject];
        settings.isTouchID = self.swithcPropery.isOn;
    }
    
    [self.managedObjectContext save:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        cell = self.TouchIDCell;
    }else
    {
        cell = self.passcodeCell;
        cell.textLabel.text = @"Set new passcode";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
       // some code here
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"newCode"])
    {
        NewCodeController* vc = (NewCodeController *)[segue destinationViewController];
        vc.managedObjectContext = self.managedObjectContext;
        vc.managedObjectModel = self.managedObjectModel;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
