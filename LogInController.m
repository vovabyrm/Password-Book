//
//  LogInController.m
//  CDStaff
//
//  Created by Vladimir Burmistrov on 22.05.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import "LogInController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MasterViewController.h"
#import "PassTableViewController.h"
#import "NewCodeController.h"

@interface LogInController ()

@property (strong, nonatomic) LAContext* bioContext;
@property (strong, nonatomic) Settings* settingsParams;
@property (assign, nonatomic) BOOL isSettingPass;

@end

@implementation LogInController

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"View appeared");
    [super viewDidAppear:animated];
    LAContext* context = [[LAContext alloc] init];
    self.bioContext = context;
    self.currentPass = @"";
    [self getSettingsFromData];
    if(!self.settingsParams){
        self.isSettingPass = true;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewCodeController * controller = (NewCodeController *)[sb instantiateViewControllerWithIdentifier:@"FirstLaunch"];
        controller.managedObjectContext = self.managedObjectContext;
        controller.isFirstTime = true;
        [self presentViewController:controller animated:NO completion:^{
        //
        }];
    }
    if(self.isSettingPass)
    {
        self.isSettingPass = false;
        [self performSegueWithIdentifier:@"TEST" sender:self];
    }
    self.password = self.settingsParams.codeHash;
    if(!self.settingsParams.isTouchID)
        self.touchIDtestButton.hidden = true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchIDbutton.hidden = true;
    self.backspaceButton.hidden = true;
    //self.password = @"5432";
    //self.password = [self.password MD5String];
    //NSLog(@"%@",self.password);
    
    LAContext* context = [[LAContext alloc] init];
    self.bioContext = context;
    [self getSettingsFromData];
    [self isFingerprintsChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSettingsFromData{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Settings"];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (![results firstObject]) {
        //NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        //NewCodeController* controller = [[NewCodeController alloc] init];
        //[self presentViewController:controller animated:NO completion:^{
            //
        //}];
    }
    Settings* settings = [results firstObject];
    self.settingsParams = settings;
}

- (void)isFingerprintsChanged{
    [self.bioContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    // load the last domain state from touch id
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *oldDomainState = [defaults objectForKey:@"domainTouchID"];
    
    NSData *domainState = [self.bioContext evaluatedPolicyDomainState];
    self.domainStateP = domainState;
    
    // check for domain state changes
    if (self.settingsParams.isTouchID) {
    if ([oldDomainState isEqual:domainState]) {
        // message = @"nothing change.";
        self.touchIDtestButton.hidden = false;
        [self touchID];
    } else {
        self.touchIDtestButton.hidden = true;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Touch ID unavaliable"
                                                                message:@"Enter passcode to get into app"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            // authorized = FALSE;
            // return NO;
            // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
        });
        //message = @"domain state was changed!";
    }
    }
}

#pragma mark - Segues
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    __block BOOL authorized;
    authorized = FALSE;
    if ([identifier isEqualToString:@"TEST"]) {
            [self touchID];
    } else if ([identifier isEqualToString:@"LogIn"])
        authorized = TRUE;
    return authorized;
}

-(void) touchID
{
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Use your fingerprint to unlock the app";
    
    if ([self.bioContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [self.bioContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self performSegueWithIdentifier:@"TEST" sender:nil];
                                        //self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
                                        //[super viewWillAppear:animated];
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        NSString* description = [[NSString alloc] init];
                                        switch (error.code) {
                                            case LAErrorPasscodeNotSet:
                                                description = @"Set passcode and enroll TouchID";
                                                break;
                                            case LAErrorTouchIDNotEnrolled:
                                                description = @"Enroll TouchID";
                                                break;
                                            case LAErrorTouchIDLockout:
                                                description = @"Too many failed Touch ID attempts";
                                                break;
                                                
                                            default:
                                                break;
                                        }

                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Touch ID unavaliable"
                                                                                            message:description
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil, nil];
                                        if (error.code == LAErrorTouchIDLockout ||
                                            error.code == LAErrorTouchIDNotEnrolled ||
                                            error.code == LAErrorPasscodeNotSet) {
                                            [alertView show];
                                            self.touchIDtestButton.hidden = true;
                                        }
                                        
                                        
                                       // authorized = FALSE;
                                        // return NO;
                                        // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                                    });
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* description = [[NSString alloc] init];
            /*if([authError.code isEqual:LAErrorPasscodeNotSet ])
                description = @"Set passcode and enroll TouchID";
            else if([authError isEqual:LAErrorTouchIDNotEnrolled])
                description = @"Enroll TouchID";
            else if ([authError isEqual:LAErrorTouchIDLockout])
                description = @"Too many failed Touch ID attempts";*/
            switch (authError.code) {
                case LAErrorPasscodeNotSet:
                    description = @"Set passcode and enroll TouchID";
                    break;
                case LAErrorTouchIDNotEnrolled:
                    description = @"Enroll TouchID";
                    break;
                case LAErrorTouchIDLockout:
                    description = @"Too many failed Touch ID attempts";
                    break;

                default:
                    break;
            }
            NSLog(@"%ld, %@",authError.code, authError.description);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Touch ID unavaliable"
                                                                message:description
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            self.touchIDtestButton.hidden = true;
            //authorized = FALSE;
            // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
        });
    }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"LogIn"]) {
        MasterViewController *controller = (MasterViewController *)[segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.managedObjectModel = self.managedObjectModel;

    }else if ([[segue identifier] isEqualToString:@"TEST"]) {
        PassTableViewController *controller = (PassTableViewController *)[segue destinationViewController];
        controller.managedObjectContext = self.managedObjectContext;
        controller.managedObjectModel = self.managedObjectModel;
        
    }
}

#pragma mark - Buttons

- (IBAction)numb1:(UIButton *)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,1];
    _currentPass = [self.currentPass stringByAppendingString:@"1"];
    self.complet++;
    [self checkForComplet];
    
}
- (IBAction)numb2:(UIButton *)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,2];
    _currentPass = [self.currentPass stringByAppendingString:@"2"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)numb3:(UIButton *)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,3];
    _currentPass = [self.currentPass stringByAppendingString:@"3"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)numb4:(id)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,4];
    _currentPass = [self.currentPass stringByAppendingString:@"4"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)numb5:(UIButton *)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,5];
    self.currentPass = [self.currentPass stringByAppendingString:@"5"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)numb6:(UIButton *)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,6];
    _currentPass = [self.currentPass stringByAppendingString:@"6"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)numb7:(UIButton *)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,7];
    _currentPass = [self.currentPass stringByAppendingString:@"7"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)numb8:(UIButton *)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,8];
    _currentPass = [self.currentPass stringByAppendingString:@"8"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)numb9:(UIButton *)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,9];
    _currentPass = [self.currentPass stringByAppendingString:@"9"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)numb0:(UIButton *)sender {
    //_currentPass = [NSString stringWithFormat:@"%@%d",self.currentPass,0];
    _currentPass = [self.currentPass stringByAppendingString:@"0"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)backSpace:(UIButton *)sender {
    self.currentPass = [self.currentPass substringToIndex:[self.currentPass length]-1];
    switch (self.complet) {
        case 1:
            self.indicator1.image = [UIImage imageNamed:@"passiveDot.png"];
            self.backspaceButton.hidden = true;
            break;
            
        case 2:
            self.indicator2.image = [UIImage imageNamed:@"passiveDot.png"];
            break;
            
        case 3:
            self.indicator3.image = [UIImage imageNamed:@"passiveDot.png"];
            break;
            
        default:
            break;
    }
    self.complet--;
}

-(void) checkForComplet
{
    self.backspaceButton.hidden = false;
    if(self.complet == 4)
    {
        
        self.currentPass = [self.currentPass MD5String];
        if([self.currentPass isEqualToString:self.password]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.domainStateP forKey:@"domainTouchID"];
            [defaults synchronize];
            
            if(self.settingsParams.isTouchID)
            self.touchIDtestButton.hidden = false;
            
            self.indicator1.image = [UIImage imageNamed:@"passiveDot.png"];
            self.indicator2.image = [UIImage imageNamed:@"passiveDot.png"];
            self.indicator3.image = [UIImage imageNamed:@"passiveDot.png"];
            self.currentPass = @"";
            self.complet = 0;
            self.backspaceButton.hidden = true;
            [self performSegueWithIdentifier:@"TEST" sender:self];
        }
        else{
            self.indicator1.image = [UIImage imageNamed:@"passiveDot.png"];
            self.indicator2.image = [UIImage imageNamed:@"passiveDot.png"];
            self.indicator3.image = [UIImage imageNamed:@"passiveDot.png"];
            //self.indicator4.image = [UIImage imageNamed:@"passiveDot.png"];
            self.currentPass = @"";
            self.complet = 0;
            self.backspaceButton.hidden = true;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Incorrect Password"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else
    {
        switch (self.complet) {
            case 1:
                self.indicator1.image = [UIImage imageNamed:@"activeDot.png"];
                break;
                
            case 2:
                self.indicator2.image = [UIImage imageNamed:@"activeDot.png"];
                break;
                
            case 3:
                self.indicator3.image = [UIImage imageNamed:@"activeDot.png"];
                break;
                
            default:
                break;
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
