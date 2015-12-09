//
//  DetailTableViewController.m
//  Tour
//
//  Created by rock on 12/9/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *itemNameField;
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation DetailTableViewController{
    NSDate *_dueDate;
    BOOL _datePickerVisible;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)updateDueDateLabel{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dueDateLabel.text = [formatter stringFromDate:_dueDate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.itemToEdit == nil)
    {
        self.title = @"新增";
        _dueDate = [NSDate date];
    }else{
        self.title = @"编辑";
        self.itemNameField.text = self.itemToEdit.itemName;
        self.moneyField.text = @(self.itemToEdit.money).stringValue;
        _dueDate = self.itemToEdit.dueDate;
    }
    
    [self updateDueDateLabel];
    
}


-(void)showDatePicker{
    _datePickerVisible = YES;
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker*)[datePickerCell viewWithTag:100];
    [datePicker setDate:_dueDate animated:NO];
}


-(void)hideDatePicker{
    if(_datePickerVisible){
        _datePickerVisible = NO;
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)dateChanged:(UIDatePicker*)datePicker{
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //调试语句开始
    NSLog(@"cellForRowAtIndexPath section:%zd,row:%zd",indexPath.section,indexPath.row);
    //调试语句结束
    
    //检查当前是否存在日期选择器所在行对应的index-path,如果没有,跳转到第5步
    if(indexPath.section ==0 &&indexPath.row ==3)
    {
        //调试语句开始
        NSLog(@"即将开始取cell, row:%zd",indexPath.row);
        //调试语句结束
        //询问表视图是否已经有了日期选择器的cell。如果没有就创建一个新的。
        //selection style(选择样式)是none,因为我们不希望在⽤用户触碰它的时候显⽰示⼀一个已选中的状态。
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        if(cell == nil){
            //调试语句开始
            NSLog(@"cell 为空,开始新建日期选择控件,row:%zd",indexPath.row);
            //调试语句结束
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //创建一个新的UIDatePicker控件。将其tag值设置为100,以便后续使⽤用。
            UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f,216.0f)];
            datePicker.datePickerMode = UIDatePickerModeDate;
            datePicker.tag =100;
            [cell.contentView addSubview:datePicker];
            //告诉日期选择器,每当用户更改了日期的时候调⽤用dateChanged:方法。
            //UIDatePicker的 Value Changed方法将会触发dateChanged方法。
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
    //对于任何非日期选择器cell对应的index-paths,直接调⽤用super(也就是表视图控制器)。
    //这样之前的static cell不会受到任何影响。
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section ==0 && _datePickerVisible){
        return 4;
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0 &&indexPath.row ==3)
    {
        return 217.0f;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.itemNameField resignFirstResponder];
    //调试语句开始
    NSLog(@"didSelectRowAtIndexPath section:%zd,row:%zd",indexPath.section,indexPath.row);
    //调试语句结束
    if(indexPath.section ==0 &&indexPath.row ==2){
        if(!_datePickerVisible){
            //调试语句开始
            NSLog(@"didSelectRowAtIndexPath 即将showDatePicker");
            //调试语句结束
            
            [self showDatePicker];
        }else{
            //调试语句开始
            NSLog(@"didSelectRowAtIndexPath 即将hideDatePicker");
            //调试语句结束
            [self hideDatePicker];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self hideDatePicker];
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath: (NSIndexPath *)indexPath{
    if(indexPath.section ==0 &&indexPath.row ==3){
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0
                                                       inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath]; }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.saveButton)
        return;
    if (self.itemNameField.text.length > 0)
    {
        if (self.itemToEdit == nil)
        {
            //调试语句开始
            NSLog(@"开始新增处理");
            //调试语句结束
            self.NewItem = [[Item alloc] init];
            self.NewItem.itemName = self.itemNameField.text;
            self.NewItem.money = [self.moneyField.text doubleValue];
            self.NewItem.dueDate = _dueDate;
        } else
        {
            //调试语句开始
            NSLog(@"开始编辑处理");
            //调试语句结束
            self.itemToEdit.itemName = self.itemNameField.text;
            self.itemToEdit.money = [self.moneyField.text doubleValue];
            self.itemToEdit.dueDate = _dueDate;
        }
        
        //self.NewItem.completed = NO;
    }
}


@end
