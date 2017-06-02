//
//  DetailViewController.h
//  CDStaff
//
//  Created by Vladimir Burmistrov on 25.04.17.
//  Copyright © 2017 Vladimir Burmistrov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDStaff+CoreDataModel.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Debtor *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

