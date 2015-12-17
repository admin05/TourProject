//
//  DataModel.h
//  Tour
//
//  Created by rock on 12/8/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property(nonatomic,strong)NSMutableArray *listItems;
@property(nonatomic,strong)NSMutableArray *historyItems;
@property(nonatomic,copy)NSDate *dueDate;
-(void)saveList;
-(void)loadList;
-(void)sortList;
+(NSInteger)nextListItemId;
@end
