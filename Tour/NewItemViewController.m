//
//  NewItemViewController.m
//  Tour
//
//  Created by rock on 10/19/15.
//  Copyright (c) 2015 rock. All rights reserved.
//

#import "NewItemViewController.h"

@interface NewItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation NewItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.itemToEdit != nil)
    {
        self.title = @"编辑";
        self.textField.text = self.itemToEdit.itemName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
