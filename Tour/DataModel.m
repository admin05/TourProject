//
//  DataModel.m
//  Tour
//
//  Created by rock on 12/8/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "DataModel.h"
#import "Item.h"

@implementation DataModel

//获取Documents目录的完整路径
-(NSString*)documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject]; return documentsDirectory;
}

//数据文件的存储路径
-(NSString*)dataFilePath{
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Lists.plist"];
}


//把数据保存到文件
-(void)saveList{
    NSLog(@"下面即将执行saveListItems");
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    //[archiver encodeObject:self.listItems forKey:@"Items"];
    NSMutableArray *_mergedArray = [NSMutableArray arrayWithArray:[self.listItems arrayByAddingObjectsFromArray:self.historyItems]];
    [archiver encodeObject:_mergedArray forKey:@"Items"];
       
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}


//从文件中读取数据
-(void)loadList{
    NSString *path =[self dataFilePath];
    if([[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        
        NSData *data = [[NSData alloc]initWithContentsOfFile:path ];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        //self.listItems = [unarchiver decodeObjectForKey:@"Items"];
        
        //读取数据后存入临时数组
        NSMutableArray *array = [unarchiver decodeObjectForKey:@"Items"];
        NSMutableArray *itemsToList = [NSMutableArray arrayWithCapacity:[array count]];
        NSMutableArray *itemsToHistory = [NSMutableArray arrayWithCapacity:[array count]];
        for (Item * _item in array) {
            
            if ([_item.dueDate compare:[NSDate date]] == NSOrderedAscending) {
                //到期日早于当前日期存入history
                [itemsToHistory addObject:_item];
            }else{
                //到期日晚于或等于当前日期存入list
                [itemsToList addObject:_item];
            }
            
        }
        self.listItems = [[NSMutableArray alloc]initWithArray:itemsToList];
        self.historyItems = [[NSMutableArray alloc]initWithArray:itemsToHistory];
        
        [unarchiver finishDecoding];
        
    }else
    {
        self.listItems = [[NSMutableArray alloc]initWithCapacity:20];
    }
}

//按照到期时间从近到远排序
-(void)sortList{
    NSLog(@"DataModel开始执行sortList");
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [self.listItems sortUsingDescriptors:sortDescriptors];
    NSLog(@"DataModel已执行完成sortList");
}

-(id)init{
    if((self =[super init])){
        [self loadList];
        [self sortList];
    }
    return self;
}

//计算项目id供添加或删除本地提醒时使用
+(NSInteger)nextListItemId{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    NSInteger itemId = [userDefaults integerForKey:@"ItemId"];
    [userDefaults setInteger:itemId +1 forKey:@"ItemId"];
    [userDefaults synchronize];
    return itemId;
}



@end
