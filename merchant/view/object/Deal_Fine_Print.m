#import "Deal_Fine_Print.h"


@interface Deal_Fine_Print ()
{
    UITableView *tblOptions;
    Deal_Fine_Print_More *vc_deal_fine_print_more;
    NSMutableArray *fine_print_option_obj_array_all;
}
@end


@implementation Deal_Fine_Print

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.screen_title = @"FINE PRINT";
    self.left_button = @"back";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(!self.loaded)
    {
        if(self.deal_controller.deal_obj.deal_id == nil)
        {
            [self Set_View_Properties];
        }
        else
        {
            fine_print_option_obj_array_all = [[NSMutableArray alloc]init];
            for (NSDictionary *fine_print_option_obj_deal in self.deal_controller.deal_obj.fine_print_option_obj_array)
            {
                Fine_Print_Option *fine_print_option = [[Fine_Print_Option alloc]init];
                
                fine_print_option.option_id = [fine_print_option_obj_deal objectForKey:@"option_id"];
                fine_print_option.display = [fine_print_option_obj_deal objectForKey:@"display"];
                fine_print_option.value = [fine_print_option_obj_deal objectForKey:@"value"];
                fine_print_option.is_selected = [fine_print_option_obj_deal objectForKey:@"is_selected"];
                fine_print_option.is_active = [fine_print_option_obj_deal objectForKey:@"is_active"];
                fine_print_option.order_id = [fine_print_option_obj_deal objectForKey:@"order_id"];
                    
                [fine_print_option_obj_array_all addObject:fine_print_option];
            }
            
            [tblOptions reloadData];
        }
    }
    self.loaded = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /* not sure why need this code, but will lock up nav bar if not here */
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
    self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = YES;
    self.navigationController.navigationBar.topItem.backBarButtonItem.enabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fine_print_option_obj_array_all count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Fine_Print_Option *fine_print_option_obj = fine_print_option_obj_array_all[indexPath.row];
    
    UIView* viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_width, self.screen_height * .12)];
    viewCell.backgroundColor = [UIColor whiteColor];
    viewCell.translatesAutoresizingMaskIntoConstraints = NO;
    
    GTLabel* lblFinePrint = [Coding Create_Label:fine_print_option_obj.display width:(self.screen_width * .625) font:label_font mult:NO];
    CGFloat label_y = ((viewCell.frame.size.height/2) - ([Utilities Get_Height:lblFinePrint]/2));
    [Coding Add_View:viewCell view:lblFinePrint x:(self.screen_indent_x * 2) height:[Utilities Get_Height:lblFinePrint] prev_frame:CGRectNull gap:label_y];

    CGFloat checkbox_width = (self.screen_width * .1);
    CGFloat checkbox_x = self.screen_width - checkbox_width - (self.screen_indent_x * 2);
    CGFloat checkbox_y = ((viewCell.frame.size.height/2) - (checkbox_width/2));
    
    BOOL checked_state = [fine_print_option_obj.is_selected boolValue];

    M13Checkbox *chkFinePrint = [Coding Create_Checkbox:[fine_print_option_obj.option_id integerValue] selected:checked_state width:checkbox_width];
    [chkFinePrint setCheckState:checked_state];
    [chkFinePrint setTag:indexPath.row];
    [Coding Add_View:viewCell view:chkFinePrint x:checkbox_x height:chkFinePrint.frame.size.height prev_frame:CGRectNull gap:checkbox_y];
    [chkFinePrint addTarget:self action:@selector(setCheckedState:) forControlEvents:UIControlEventValueChanged];

    [cell.contentView addSubview:viewCell];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.screen_height * .12;
}

//check if the switch is currently ON or OFF
- (void)setCheckedState:(id)sender
{
    M13Checkbox *current_switch = (M13Checkbox*)sender;
    
    BOOL state = [sender checkState];
    NSString *rez = state == YES ? @"YES" : @"NO";
    NSLog(rez);
    
    Fine_Print_Option *fine_print_option_obj = fine_print_option_obj_array_all[current_switch.tag];
    
    if(state == YES)
        fine_print_option_obj.is_selected = @1;
    else
        fine_print_option_obj.is_selected = @0;
    
    fine_print_option_obj_array_all[current_switch.tag] = fine_print_option_obj;
}


//check if the switch is currently ON or OFF
- (void)setState:(id)sender
{
    UISwitch *current_switch = (UISwitch*)sender;
    
    BOOL state = [sender isOn];
//    NSString *rez = state == YES ? @"YES" : @"NO";
    
    Fine_Print_Option *fine_print_option_obj = fine_print_option_obj_array_all[current_switch.tag];
 
    if(state == YES)
        fine_print_option_obj.is_selected = @1;
    else
        fine_print_option_obj.is_selected = @0;
        
    fine_print_option_obj_array_all[current_switch.tag] = fine_print_option_obj;
}


/* public methods */
-(void)Create_Layout
{
    CGRect table_frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + (self.gap * 7), self.view.bounds.size.width, self.view.bounds.size.height - (self.gap * 7));
    tblOptions = [[UITableView alloc] initWithFrame:table_frame style:UITableViewStylePlain];
    tblOptions.delegate = self;
    tblOptions.dataSource = self;
    tblOptions.backgroundColor = [UIColor clearColor];
    //tblOptions.separatorColor = [UIColor clearColor];
    tblOptions.allowsSelection = NO;
    tblOptions.tableFooterView = [UIView new];
    
    [self.view addSubview:tblOptions];

    tblOptions.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
}

-(void)Set_View_Properties
{
    [self Progress_Show:@"Loading Options"];
    
    [self.system_controller Get_Fine_Print_Options:^(void)
     {
         successful = self.system_controller.successful;
         system_successful_obj = self.system_controller.system_successful_obj;
         system_error_obj = self.system_controller.system_error_obj;
         
         [self Progress_Close];
         
         if(successful)
         {
             fine_print_option_obj_array_all = self.system_controller.fine_print_option_obj_array;
             
             [tblOptions reloadData];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void)Next_Click
{
    [super Next_Click];

    NSMutableArray *fine_print_option_obj_array = [[NSMutableArray alloc] init];
    for (Fine_Print_Option *fine_print_option_obj in fine_print_option_obj_array_all)
    {
        if([fine_print_option_obj.is_selected  isEqual: @1])
            [fine_print_option_obj_array addObject:fine_print_option_obj];
    }
    
    self.deal_controller.deal_obj.fine_print_option_obj_array = fine_print_option_obj_array;
    
    if(vc_deal_fine_print_more == nil)
    {
        vc_deal_fine_print_more = [[Deal_Fine_Print_More alloc]init];
    }
    vc_deal_fine_print_more.deal_controller = self.deal_controller;
    vc_deal_fine_print_more.merchant_controller = self.merchant_controller;
    vc_deal_fine_print_more.system_controller = self.system_controller;
    vc_deal_fine_print_more.hidesBottomBarWhenPushed = YES;
    
    if(![self.navigationController.topViewController isKindOfClass:[vc_deal_fine_print_more class]])
    {
        [self.navigationController pushViewController:vc_deal_fine_print_more animated:YES];
    }
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
