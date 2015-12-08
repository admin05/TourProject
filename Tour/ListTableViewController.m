//
//  ListTableViewController.m
//  Tour
//
//  Created by rock on 10/19/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ListTableViewController.h"
#import "Item.h"
#import "NewItemViewController.h"

@interface ListTableViewController ()
@property NSMutableArray *Items;
@end

@implementation ListTableViewController

//初始化时生成固定数据，已不使用
/*- (void)loadInitialData {
    Item *item1 = [[Item alloc] init];
    item1.itemName = @"工";
    [self.Items addObject:item1];
    Item *item2 = [[Item alloc] init];
    item2.itemName = @"农";
    [self.Items addObject:item2];
    Item *item3 = [[Item alloc] init];
    item3.itemName = @"中";
    [self.Items addObject:item3];
    Item *item4 = [[Item alloc] init];
    item4.itemName = @"建";
    [self.Items addObject:item4];

}*/


- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    NewItemViewController *source = [segue sourceViewController];
    
    
    if (source.itemToEdit == nil)
    {
        //以下为调试语句
        NSLog(@"unwindToList segue进入新增逻辑");
        //调试语句结束
        Item *revItem = source.NewItem;
        if (revItem != nil)
        {
            [self.Items addObject:revItem];
            [self.tableView reloadData];
            [self saveListItems];
        }
     }
    else{
        //todo
        NSLog(@"unwindToList segue进入编辑逻辑");
        Item *revItem = source.itemToEdit;
        if (revItem != nil)
        {
            NSLog(@"所编辑行号为%zd",source.itemPathRow);
            [self.Items replaceObjectAtIndex:source.itemPathRow withObject:revItem];
            [self.tableView reloadData];
            [self saveListItems];
        }
    }

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)loadListItems{
    NSString *path =[self dataFilePath];
    if([[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        
        NSData *data = [[NSData alloc]initWithContentsOfFile:path ];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.Items = [unarchiver decodeObjectForKey:@"Items"];
        [unarchiver finishDecoding];
        NSLog(@"已执行完成finishDecoding");
        //以下为调试语句
        //for (Item * object in self.Items)
        //{
        //    NSLog(@"数组对象:%@", object.itemName);
        // }
        //调试语句结束
    }else
    {
        self.Items = [[NSMutableArray alloc]initWithCapacity:20];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self =[super initWithCoder:aDecoder]))
    {
        NSLog(@"下面即将执行loadListItems");
        [self loadListItems];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.Items = [[NSMutableArray alloc] init];
    //[self loadInitialData];
    
    //NSLog(@"文件夹的目录是:%@",[self documentsDirectory]);
    //NSLog(@"数据文件的路径是:%@",[self dataFilePath]);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

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
    [archiver encodeObject:self.Items forKey:@"Items"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.Items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Item *item1 = [self.Items objectAtIndex:indexPath.row];
    cell.textLabel.text = item1.itemName;
    /*if (item1.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }*/
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"AddItem"])
    {

        //UINavigationController *navigationController = segue.destinationViewController;
        //NewItemViewController *controller = (NewItemViewController*) navigationController.topViewController;
        //controller.delegate = self;
    }else if([segue.identifier isEqualToString:@"EditItem"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        NewItemViewController *controller = (NewItemViewController*) navigationController.topViewController;
        //controller.delegate = self;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.Items[indexPath.row];
        controller.itemPathRow=indexPath.row;
    }
}



#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath
                                                                    *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //Item *tappedItem = [self.Items objectAtIndex:indexPath.row];
    //tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationNone];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.Items removeObjectAtIndex:indexPath.row];
    [self saveListItems];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
