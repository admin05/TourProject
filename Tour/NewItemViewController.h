//
//  NewItemViewController.h
//  Tour
//
//  Created by rock on 10/19/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
@interface NewItemViewController : UIViewController
@property Item *NewItem;
@property Item *itemToEdit;
@property NSUInteger  itemPathRow;
@end
