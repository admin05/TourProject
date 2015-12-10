//
//  Item.h
//  Tour
//
//  Created by rock on 10/20/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject <NSCoding>

@property NSString *itemName;
@property double money;
@property (readonly) NSDate *creationDate;
@property(nonatomic,copy)NSDate *dueDate;
@property(nonatomic,assign) NSInteger itemId;
-(void)scheduleNotification;
@end
