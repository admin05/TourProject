//
//  DataModel.m
//  Tour
//
//  Created by rock on 12/8/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "DataModel.h"

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
-(void)saveListItems{
    NSLog(@"下面即将执行saveListItems");
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.listItems forKey:@"Items"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}


//从文件中读取数据
-(void)loadListItems{
    NSString *path =[self dataFilePath];
    if([[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        
        NSData *data = [[NSData alloc]initWithContentsOfFile:path ];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.listItems = [unarchiver decodeObjectForKey:@"Items"];
        [unarchiver finishDecoding];
        NSLog(@"已执行完成finishDecoding");
    }else
    {
        self.listItems = [[NSMutableArray alloc]initWithCapacity:20];
    }
}


-(id)init{
    if((self =[super init])){
        [self loadListItems];
    }
    return self;
}

+(NSInteger)nextListItemId{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    NSInteger itemId = [userDefaults integerForKey:@"ItemId"];
    [userDefaults setInteger:itemId +1 forKey:@"ItemId"];
    [userDefaults synchronize];
    return itemId;
}

@end
