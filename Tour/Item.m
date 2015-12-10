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

-(void)deleteNotificationForThisItem{
    NSArray *allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for(int i=0;i<allNotifications.count;i++)
    //for(UILocalNotification *notification in allNotifications)
    {
        UILocalNotification *notification=allNotifications[i];
        NSLog(@"找到提醒 %@",notification);
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        if(number != nil &&[number integerValue] == self.itemId)
        {
            NSLog(@"删除已有提醒 %@",notification);
            [[UIApplication sharedApplication]cancelLocalNotification:notification];
        }
    }

}


-(void)scheduleNotification{

    [self deleteNotificationForThisItem];
    
    if([self.dueDate compare:[NSDate date]] != NSOrderedAscending)
    {
     
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        //到期7天前提醒
        int daysToAdd = -7;
        NSDate *alertDate = [self.dueDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        //运行时1分钟后提醒 todo 需修改为固定时间提醒
        localNotification.fireDate = [alertDate dateByAddingTimeInterval:20];
        localNotification.repeatInterval = NSDayCalendarUnit;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.itemName;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{@"ItemID" : @(self.itemId)};
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
        NSLog(@"Scheduled notification %@ for itemId %ld",localNotification,(long)self.itemId);
        /*
        //3天前提醒
        daysToAdd=4;
        localNotification.fireDate = [ localNotification.fireDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSLog(@"Scheduled notification %@ for itemId %ld",localNotification,(long)self.itemId);
        //1天前提醒
        daysToAdd=2;
        localNotification.fireDate = [ localNotification.fireDate dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSLog(@"Scheduled notification %@ for itemId %ld",localNotification,(long)self.itemId);
        */

    }
}
@end
