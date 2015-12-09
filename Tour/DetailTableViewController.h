//
//  DetailTableViewController.h
//  Tour
//
//  Created by rock on 12/9/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface DetailTableViewController : UITableViewController

@property Item *NewItem;  //新增的项目
@property Item *itemToEdit;  //编辑的项目
@property NSUInteger itemPathRow; // 编辑的项目所在行号
@end
