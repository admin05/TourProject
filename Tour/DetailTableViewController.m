//
//  DetailTableViewController.m
//  Tour
//
//  Created by rock on 12/9/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation DetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.itemToEdit != nil)
    {
        self.title = @"编辑";
        self.textField.text = self.itemToEdit.itemName;
    }else{
        self.title = @"新增";
    }
    
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
    return 1;
    //return [self.dataModel.listItems count];
}


/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...

    return cell;
}*/



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.saveButton) return;
    if (self.textField.text.length > 0)
    {
        if (self.itemToEdit == nil)
        {
            //以下为调试语句
            NSLog(@"进入新增逻辑");
            //调试语句结束
            self.NewItem = [[Item alloc] init];
            self.NewItem.itemName = self.textField.text;
        } else
        {
            //以下为调试语句
            NSLog(@"进入编辑逻辑");
            //调试语句结束
            self.itemToEdit.itemName = self.textField.text;
        }
        
        //self.NewItem.completed = NO;
    }
}


@end
