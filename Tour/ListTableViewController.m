//
//  ListTableViewController.m
//  Tour
//
//  Created by rock on 10/19/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "ListTableViewController.h"
#import "Item.h"
#import "DataModel.h"
#import "DetailTableViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController


- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    DetailTableViewController *source = [segue sourceViewController];
    
    
    if (source.itemToEdit == nil)
    {
        //以下为调试语句
        NSLog(@"unwindToList segue进入新增逻辑");
        //调试语句结束
        Item *revItem = source.NewItem;
        if (revItem != nil)
        {
            [self.dataModel.listItems addObject:revItem];
            [self.tableView reloadData];
            [self.dataModel saveListItems];
        }
     }
    else{
        //todo
        NSLog(@"unwindToList segue进入编辑逻辑");
        Item *revItem = source.itemToEdit;
        if (revItem != nil)
        {
            NSLog(@"所编辑行号为%zd",source.itemPathRow);
            [self.dataModel.listItems replaceObjectAtIndex:source.itemPathRow withObject:revItem];
            [self.tableView reloadData];
            [self.dataModel saveListItems];
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

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self =[super initWithCoder:aDecoder]))
    {
        NSLog(@"下面即将执行loadListItems");
        [self.dataModel loadListItems];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return [self.dataModel.listItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Item *cellItem = [self.dataModel.listItems objectAtIndex:indexPath.row];
    cell.textLabel.text = cellItem.itemName;
    //cell.textLabel.text = [NSString stringWithFormat:@"%ld: %@",(long)cellItem.itemId,cellItem.itemName];
    //cell.detailTextLabel.text = @(cellItem.money).stringValue;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@+%@%%", @(cellItem.money).stringValue, @(cellItem.rate).stringValue ];
    
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
    if([segue.identifier isEqualToString:@"EditItem"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        DetailTableViewController *controller = (DetailTableViewController*) navigationController.topViewController;
        //controller.delegate = self;
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.dataModel.listItems[indexPath.row];
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
    [self.dataModel.listItems removeObjectAtIndex:indexPath.row];
    [self.dataModel saveListItems];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
