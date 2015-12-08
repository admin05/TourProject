//
//  ListTableViewController.h
//  Tour
//
//  Created by rock on 10/19/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataModel;
@interface ListTableViewController : UITableViewController
@property(nonatomic,strong)DataModel *dataModel;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
