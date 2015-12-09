//
//  Item.m
//  Tour
//
//  Created by rock on 10/20/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "Item.h"
#import "DataModel.h"

@implementation Item

-(id)init{
    if((self =[super init])){
        self.itemId = [DataModel nextListItemId];
   }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:[NSNumber numberWithDouble: self.money] forKey:@"money"];
    [aCoder encodeObject:self.dueDate forKey:@"dueDate"];
    [aCoder encodeInteger:self.itemId forKey:@"itemId"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self =[super init]))
    {
        self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
        NSNumber *tempNum = [aDecoder decodeObjectForKey:@"money"];
        self.money = tempNum.doubleValue;
        self.dueDate = [aDecoder decodeObjectForKey:@"dueDate"];
        self.itemId = [aDecoder decodeIntegerForKey:@"itemId"];
    }
    return self;
}

@end
