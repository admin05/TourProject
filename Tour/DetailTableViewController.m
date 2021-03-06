//
//  DetailTableViewController.m
//  Tour
//
//  Created by rock on 12/9/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *itemNameField;  //row0
@property (weak, nonatomic) IBOutlet UITextField *accountField;   //row1
@property (weak, nonatomic) IBOutlet UITextField *moneyField;     //row2
@property (weak, nonatomic) IBOutlet UITextField *rateField;      //row3
@property (weak, nonatomic) IBOutlet UILabel *valueDateLabel;     //row4
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;       //row5
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;        //row6

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;



@end
//起始row为0
int const VALueDateRow = 4;
int const DUEDateRow = 5;
int const INComeRow = 6;
int const DATePickerRow = 7;

@implementation DetailTableViewController{
    NSDate *_valueDate;
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

-(void)updateValueDateLabel{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.valueDateLabel.text = [formatter stringFromDate:_valueDate];
}


-(void)updateDueDateLabel{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dueDateLabel.text = [formatter stringFromDate:_dueDate];
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

-(double)calcIncome
{
    NSLog(@"即将执行calcIncome");
    double income=[self.moneyField.text doubleValue]*[self.rateField.text doubleValue]/100/360;
    //NSInteger days=[self daysBetweenDate:[NSDate date] andDate:_dueDate];
    NSInteger days=[self daysBetweenDate:_valueDate andDate:_dueDate];
    income *= days;
    NSLog(@"calcIncome执行完毕 %.2f",income);
    return income;

}

-(void)updateIncomeLabel{
    self.incomeLabel.text =  [NSString stringWithFormat:@"%.2f", [self calcIncome]];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.itemNameField.delegate=self;
    self.accountField.delegate=self;
    self.moneyField.delegate=self;
    self.rateField.delegate=self;

    if(self.itemToEdit == nil)
    {
        self.title = @"新增";
        _valueDate = [NSDate date];
        _dueDate = [NSDate date];
    }else{
        self.title = @"编辑";
        self.itemNameField.text = self.itemToEdit.itemName;
        self.accountField.text = self.itemToEdit.account;
        self.moneyField.text = @(self.itemToEdit.money).stringValue;
        self.rateField.text = @(self.itemToEdit.rate).stringValue;
        _valueDate = self.itemToEdit.valueDate;
        _dueDate = self.itemToEdit.dueDate;
        [self updateIncomeLabel];
        
    }
    [self updateValueDateLabel];
    [self updateDueDateLabel];
    
}


/*-(void)showDatePicker{
    _datePickerVisible = YES;
    NSIndexPath *indexPathDueDateRow = [NSIndexPath indexPathForRow:_dueDateRow inSection:0];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:_datePickerRow inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDueDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDueDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker*)[datePickerCell viewWithTag:100];
    [datePicker setDate:_dueDate animated:NO];
}*/

-(void)showDatePicker:(NSInteger)datePickerRow forDateRow:(NSInteger)dateRow {
    _datePickerVisible = YES;
    NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:dateRow inSection:0];
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:datePickerRow inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
    cell.detailTextLabel.textColor = cell.detailTextLabel.tintColor;
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker*)[datePickerCell viewWithTag:100];
    if (dateRow==VALueDateRow) {
        datePicker.tag = VALueDateRow;
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [datePicker setDate:_valueDate animated:NO];
    }
    if (dateRow==DUEDateRow) {
        datePicker.tag =DUEDateRow;
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [datePicker setDate:_dueDate animated:NO];
    }

}


/*-(void)hideDatePicker{
    if(_datePickerVisible){
        _datePickerVisible = NO;
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:_dueDateRow inSection:0];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:_datePickerRow inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}*/

-(void)hideDatePicker
{
    if(_datePickerVisible){
        _datePickerVisible = NO;
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:VALueDateRow inSection:0];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:DATePickerRow inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        indexPathDateRow = [NSIndexPath indexPathForRow:DUEDateRow inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
   
        
    }
}



/*-(void)dateChanged:(UIDatePicker*)datePicker{
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}*/

-(void)dateChanged:(UIDatePicker*)datePicker
{
    if (datePicker.tag==VALueDateRow) {
        _valueDate = datePicker.date;
        [self updateValueDateLabel];
    }
    if (datePicker.tag==DUEDateRow) {
        _dueDate = datePicker.date;
        [self updateDueDateLabel];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //调试语句开始
    //NSLog(@"cellForRowAtIndexPath section:%zd,row:%zd",indexPath.section,indexPath.row);
    //调试语句结束
    //检查当前是否存在日期选择器所在行对应的index-path
    if(indexPath.section ==0 &&indexPath.row == DATePickerRow)
    {
        //询问表视图是否已经有了日期选择器的cell。如果没有就创建一个新的。
        //selection style(选择样式)是none,因为我们不希望在用户触碰它的时候显示一个已选中的状态。
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        if(cell == nil)
        {
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
            //[datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            
            //调试语句开始
            NSLog(@"cellForRowAtIndexPath 日期选择控件新建完成");
            //调试语句结束
        }
        return cell;
        //对于任何非日期选择器cell对应的index-paths,直接调⽤用super(也就是表视图控制器)。
        //这样之前的static cell不会受到任何影响。
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
        return DATePickerRow+1;
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0 &&indexPath.row ==DATePickerRow)
    {
        return 217.0f;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.itemNameField resignFirstResponder];
    [self.accountField resignFirstResponder];
    [self.moneyField resignFirstResponder];
    [self.rateField resignFirstResponder];
    [self updateIncomeLabel];
    
    //调试语句开始
    NSLog(@"didSelectRowAtIndexPath money =%@, rate=%@, label= %@",self.moneyField.text,self.rateField.text,
          self.incomeLabel.text);
    //调试语句结束
    
    
    //如果选中起息日所在行则显示或隐藏日期控件
    if(indexPath.section ==0 &&indexPath.row == VALueDateRow){
        if(!_datePickerVisible){
            NSLog(@"已选中 %zd 行,即将showDatePicker",indexPath.row);
            [self showDatePicker:DATePickerRow forDateRow:VALueDateRow ];
        }else{
            NSLog(@"已选中 %zd 行 即将hideDatePicker",indexPath.row);
            [self hideDatePicker];
            [self showDatePicker:DATePickerRow forDateRow:VALueDateRow ];
        }
    }
    
    //如果选中到期日所在行则显示或隐藏日期控件
    if(indexPath.section ==0 &&indexPath.row == DUEDateRow){
        if(!_datePickerVisible){
            NSLog(@"已选中 %zd 行,即将showDatePicker",indexPath.row);
            [self showDatePicker:DATePickerRow forDateRow:DUEDateRow ];
        }else{
            NSLog(@"已选中 %zd 行 即将hideDatePicker",indexPath.row);
            [self hideDatePicker];
            [self showDatePicker:DATePickerRow forDateRow:DUEDateRow ];
        }
    }
    
    //如果选中预期收益所在行,且日期控件可见,则隐藏日期控件
    if(indexPath.section ==0 &&indexPath.row == INComeRow && _datePickerVisible){
        [self hideDatePicker];

    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self hideDatePicker];
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath: (NSIndexPath *)indexPath{
    if(indexPath.section ==0 &&indexPath.row ==DATePickerRow)
    {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0
                                                       inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
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
            NSLog(@"准备传递新增对象");
            //调试语句结束
            self.NewItem = [[Item alloc] init];
            self.NewItem.itemName = self.itemNameField.text;
            self.NewItem.account = self.accountField.text;
            self.NewItem.money = [self.moneyField.text doubleValue];
            self.NewItem.rate = [self.rateField.text doubleValue];
            self.NewItem.valueDate=_valueDate;
            self.NewItem.dueDate = _dueDate;
            [self.NewItem scheduleNotification];
  
        } else
        {
            //调试语句开始
            NSLog(@"准备传递编辑对象");
            //调试语句结束
            self.itemToEdit.itemName = self.itemNameField.text;
            self.itemToEdit.account = self.accountField.text;
            self.itemToEdit.money = [self.moneyField.text doubleValue];
            self.itemToEdit.rate = [self.rateField.text doubleValue];
            self.itemToEdit.valueDate=_valueDate;
            self.itemToEdit.dueDate = _dueDate;
            [self.itemToEdit scheduleNotification];
        }
        
    }
}


@end
