//
//  NewCodeController.m
//  CDStaff
//
//  Created by Vladimir Burmistrov on 02.06.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import "NewCodeController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface NewCodeController ()

@property (assign, nonatomic) int complet;
@property (strong, nonatomic) NSString* currentPass;
@property (strong, nonatomic) NSString* hash1;
@property (strong, nonatomic) NSString* hash2;

@end

@implementation NewCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deleteButton.hidden = true;
    self.mainLabel.text = @"Enter new passcode";
    self.currentPass = @"";
    self.hash1 = @"";
    self.hash2 = @"";
    
    if(self.isFirstTime)
        self.cancel.hidden = true;
    
    [self managedObjectContext];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)pad1:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"1"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)pad2:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"2"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)pad3:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"3"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)pad4:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"4"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)pad5:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"5"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)pad6:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"6"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)pad7:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"7"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)pad8:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"8"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)pad9:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"9"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)pad0:(id)sender {
    _currentPass = [self.currentPass stringByAppendingString:@"0"];
    self.complet++;
    [self checkForComplet];
}
- (IBAction)backSpaceAction:(id)sender {
        self.currentPass = [self.currentPass substringToIndex:[self.currentPass length]-1];
        switch (self.complet) {
            case 1:
                self.indicator1.image = [UIImage imageNamed:@"passiveDot.png"];
                self.deleteButton.hidden = true;
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
- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Logic

-(void) backAnimation{
    [UIView animateWithDuration:0.3 delay:0 options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.indicator1.center = CGPointMake(self.indicator1.center.x - CGRectGetWidth(self.view.frame) ,
                                                              self.indicator1.center.y);
                         self.indicator2.center = CGPointMake(self.indicator2.center.x - CGRectGetWidth(self.view.frame) ,
                                                              self.indicator2.center.y);
                         self.indicator3.center = CGPointMake(self.indicator3.center.x - CGRectGetWidth(self.view.frame) ,
                                                              self.indicator3.center.y);
                         self.indicator4.center = CGPointMake(self.indicator4.center.x - CGRectGetWidth(self.view.frame) ,
                                                              self.indicator4.center.y);
                         self.mainLabel.center = CGPointMake(self.mainLabel.center.x - CGRectGetWidth(self.view.frame),
                                                             self.mainLabel.center.y );
                     } completion:^(BOOL finished) {
                         self.view.userInteractionEnabled = true;
                     }];
}

-(void) checkForComplet
{
    self.deleteButton.hidden = false;
    if(self.complet == 4)
    {
        if([self.hash1 isEqualToString:@""]){
            //self.indicator1.image = [UIImage imageNamed:@"passiveDot.png"];
            //self.indicator2.image = [UIImage imageNamed:@"passiveDot.png"];
            self.indicator4.image = [UIImage imageNamed:@"activeDot.png"];
            self.hash1 = [self.currentPass MD5String];
            self.currentPass = @"";
            self.complet = 0;
            self.deleteButton.hidden = true;
            //perform animation
            self.view.userInteractionEnabled = false;
            [UIView animateWithDuration:0.2
                             animations:^{
                self.indicator1.center = CGPointMake(self.indicator1.center.x - CGRectGetWidth(self.view.frame) ,
                                                                      self.indicator1.center.y);
                self.indicator2.center = CGPointMake(self.indicator2.center.x - CGRectGetWidth(self.view.frame) ,
                                                                      self.indicator2.center.y);
                self.indicator3.center = CGPointMake(self.indicator3.center.x - CGRectGetWidth(self.view.frame) ,
                                                                      self.indicator3.center.y);
                self.indicator4.center = CGPointMake(self.indicator4.center.x - CGRectGetWidth(self.view.frame) ,
                                                                      self.indicator4.center.y);
                self.mainLabel.center = CGPointMake(self.mainLabel.center.x - CGRectGetWidth(self.view.frame),
                                                    self.mainLabel.center.y );
            } completion:^(BOOL finished) {
                self.indicator1.center = CGPointMake(self.indicator1.center.x + 2*CGRectGetWidth(self.view.frame) ,
                                                     self.indicator1.center.y);
                self.indicator2.center = CGPointMake(self.indicator2.center.x + 2*CGRectGetWidth(self.view.frame) ,
                                                     self.indicator2.center.y);
                self.indicator3.center = CGPointMake(self.indicator3.center.x + 2*CGRectGetWidth(self.view.frame) ,
                                                     self.indicator3.center.y);
                self.indicator4.center = CGPointMake(self.indicator4.center.x + 2*CGRectGetWidth(self.view.frame) ,
                                                     self.indicator4.center.y);
                self.mainLabel.center = CGPointMake(self.mainLabel.center.x + 2*CGRectGetWidth(self.view.frame),
                                                    self.mainLabel.center.y );
                self.indicator1.image = [UIImage imageNamed:@"passiveDot.png"];
                self.indicator2.image = [UIImage imageNamed:@"passiveDot.png"];
                self.indicator3.image = [UIImage imageNamed:@"passiveDot.png"];
                self.indicator4.image = [UIImage imageNamed:@"passiveDot.png"];
                self.mainLabel.text = @"Enter passcode again";
                [self backAnimation];
            }];
        }
        else {
            self.indicator1.image = [UIImage imageNamed:@"passiveDot.png"];
            self.indicator2.image = [UIImage imageNamed:@"passiveDot.png"];
            self.indicator3.image = [UIImage imageNamed:@"passiveDot.png"];
            //self.indicator4.image = [UIImage imageNamed:@"passiveDot.png"];
            self.hash2 = [self.currentPass MD5String];
            self.currentPass = @"";
            self.complet = 0;
            self.deleteButton.hidden = true;
            if([self.hash1 isEqualToString:self.hash2])
            {
                NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Settings"];
                NSError *error = nil;
                NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
                if (![results firstObject]) {
                    Settings* settings = [NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:self.managedObjectContext];
                    settings.codeHash = self.hash2;
                }else{
                    Settings* settings = [results firstObject];
                    settings.codeHash = self.hash2;
                }

                [self.managedObjectContext save:nil];
                
                LAContext* context = [[LAContext alloc] init];
                [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
                // load the last domain state from touch id
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                NSData *domainState = [context evaluatedPolicyDomainState];
                
                [defaults setObject:domainState forKey:@"domainTouchID"];
                [defaults synchronize];
                
                
               // [self performSegueWithIdentifier:nil sender:self];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Passcodes are not the same"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
                self.hash1 = @"";
                self.hash2 = @"";
                self.mainLabel.text = @"Enter new passcode";
            }
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
