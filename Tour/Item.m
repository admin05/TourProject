//
//  Item.m
//  Tour
//
//  Created by rock on 10/20/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "Item.h"

@implementation Item

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    //[aCoder encodeBool:self.completed forKey:@"completed"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self =[super init]))
    {
        self.itemName= [aDecoder decodeObjectForKey:@"itemName"];
        //self.completed = [aDecoder decodeBoolForKey:@"completed"];
    }
    return self;
}

@end
