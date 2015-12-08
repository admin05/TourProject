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
//@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
