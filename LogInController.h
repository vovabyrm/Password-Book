//
//  LogInController.h
//  CDStaff
//
//  Created by Vladimir Burmistrov on 22.05.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CDStaff+CoreDataModel.h"
#import "NSString+MD5.h"

@interface LogInController : UIViewController

@property (strong, nonatomic) NSFetchedResultsController<Debtor *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) IBOutlet UIImageView *indicator1;
@property (strong, nonatomic) IBOutlet UIImageView *indicator2;
@property (strong, nonatomic) IBOutlet UIImageView *indicator3;
@property (strong, nonatomic) IBOutlet UIImageView *indicator4;
@property (strong, nonatomic) IBOutlet UIButton *backspaceButton;
@property (strong, nonatomic) IBOutlet UIButton *touchIDbutton;
@property (strong, nonatomic) IBOutlet UIButton *touchIDtestButton;
@property (strong, nonatomic) IBOutlet UILabel *mainLabel;

@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* currentPass;
@property (assign, nonatomic) int complet;
@property (strong, nonatomic) NSData* domainStateP;
@property (assign, nonatomic) BOOL isTID;


-(void) touchID;

- (void)isFingerprintsChanged;

@end
