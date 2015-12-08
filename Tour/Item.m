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
//        self.itemId = [DataModel nextChecklistItemId];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.dueDate forKey:@"dueDate"];
    [aCoder encodeInteger:self.itemId forKey:@"itemId"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self =[super init]))
    {
        self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
        self.dueDate = [aDecoder decodeObjectForKey:@"dueDate"];
        self.itemId = [aDecoder decodeIntegerForKey:@"itemId"];
    }
    return self;
}

@end
