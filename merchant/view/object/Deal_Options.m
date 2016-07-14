#import "Deal_Options.h"


@interface Deal_Options ()
{
    GTPopup *imvUseImmediatelyInfo;
    UISwitch *swtUseImmediately;
    GTPopup *imvNewCustomerInfo;
    UISwitch *swtNewCustomer;
    
    Deal_Fine_Print *vc_deal_fine_print;
}

@end


@implementation Deal_Options

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"OPTIONS";
    self.left_button = @"back";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [imvUseImmediatelyInfo Initialize:[UIImage imageNamed:@"question_mark.png"]
                         view_size:CGSizeMake(280, 400)
                        input_text:self.system_controller.system_settings_obj.deal_use_immediately_info];
    
    [imvNewCustomerInfo Initialize:[UIImage imageNamed:@"question_mark.png"]
                         view_size:CGSizeMake(280, 400)
                        input_text:self.system_controller.system_settings_obj.deal_new_customer_only_info];
    
    if((self.deal_controller.deal_obj.deal_id != nil) && (!self.loaded))
    {
        [swtUseImmediately setOn:[self.deal_controller.deal_obj.use_deal_immediately boolValue] animated:YES];
        [swtNewCustomer setOn:[self.deal_controller.deal_obj.is_valid_new_customer_only boolValue] animated:YES];
    }
    else if(!self.loaded)
    {
        [self Set_View_Properties];
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


/* public methods */
-(void)Create_Layout
{
    CGFloat view_height = (self.screen_height * .13);
    CGFloat label_y;
    CGFloat label_width = self.screen_indent_width * .60;
    CGFloat image_x;
    CGFloat image_y;
    CGFloat image_width = (self.screen_width * .09375);
    CGFloat switch_width = self.screen_width * .15;
    CGFloat switch_x = self.screen_width - self.screen_indent_x - switch_width;
    CGFloat switch_y;
    
    /* view 1 */
    UIView* view_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_width, view_height)];
    view_1.backgroundColor = [UIColor whiteColor];
    
    GTLabel* lblUseImmediatelyLabel = [Coding Create_Label:@"Use Deal Immediately" width:label_width font:label_font mult:NO];
    label_y = (view_height/2) - ([Utilities Get_Height:lblUseImmediatelyLabel]/2);
    [Coding Add_View:view_1 view:lblUseImmediatelyLabel x:self.screen_indent_x height:[Utilities Get_Height:lblUseImmediatelyLabel] prev_frame:CGRectNull gap:label_y];
    
    imvUseImmediatelyInfo = [[GTPopup alloc]initWithFrame:CGRectMake(0, 0, image_width, image_width)];
    [imvUseImmediatelyInfo setImage:[UIImage imageNamed:@"question_mark.png"]];
    image_x = lblUseImmediatelyLabel.frame.origin.x + lblUseImmediatelyLabel.frame.size.width + self.gap;
    image_y = (view_height/2) - (imvUseImmediatelyInfo.frame.size.height/2);
    [Coding Add_View:view_1 view:imvUseImmediatelyInfo x:image_x height:imvUseImmediatelyInfo.frame.size.height prev_frame:CGRectNull gap:image_y];
    
    swtUseImmediately = [[UISwitch alloc] init];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        swtUseImmediately.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }
    switch_y = (view_height/2) - (swtUseImmediately.frame.size.height/2);
    [Coding Add_View:view_1 view:swtUseImmediately x:switch_x height:swtUseImmediately.frame.size.height prev_frame:CGRectNull gap:switch_y];
    
    /* view 2 */
    UIView* view_2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_width, view_height)];
    view_2.backgroundColor = [UIColor whiteColor];
    
    GTLabel* lblNewCustomerLabel = [Coding Create_Label:@"New Customers Only" width:label_width font:label_font mult:NO];
    label_y = (view_height/2) - ([Utilities Get_Height:lblNewCustomerLabel]/2);
    [Coding Add_View:view_2 view:lblNewCustomerLabel x:self.screen_indent_x height:[Utilities Get_Height:lblNewCustomerLabel] prev_frame:CGRectNull gap:label_y];
    
    imvNewCustomerInfo = [[GTPopup alloc]initWithFrame:CGRectMake(0, 0, image_width, image_width)];
    [imvNewCustomerInfo setImage:[UIImage imageNamed:@"question_mark.png"]];
    image_x = lblNewCustomerLabel.frame.origin.x + lblNewCustomerLabel.frame.size.width + self.gap;
    image_y = (view_height/2) - (imvNewCustomerInfo.frame.size.height/2);
    [Coding Add_View:view_2 view:imvNewCustomerInfo x:image_x height:imvNewCustomerInfo.frame.size.height prev_frame:CGRectNull gap:image_y];
    
    swtNewCustomer = [[UISwitch alloc] init];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        swtNewCustomer.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }
    switch_y = (view_height/2) - (swtUseImmediately.frame.size.height/2);
    [Coding Add_View:view_2 view:swtNewCustomer x:switch_x height:swtNewCustomer.frame.size.height prev_frame:CGRectNull gap:switch_y];
    
    [Coding Add_View:contentView view:view_1 x:0 height:view_1.frame.size.height prev_frame:CGRectNull gap:(self.gap * 7)];
    [Coding Add_View:contentView view:view_2 x:0 height:view_2.frame.size.height prev_frame:view_1.frame gap:(self.gap * 2)];

    [self Add_View:self.screen_width height:[self Get_Scroll_Height:contentView.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

-(void) Set_View_Properties
{
    if(self.system_controller.system_settings_obj.deal_new_customer_only)
        [swtNewCustomer setOn:YES];
    else
        [swtNewCustomer setOn:NO];
    
    if(self.system_controller.system_settings_obj.deal_use_immediately)
        [swtUseImmediately setOn:YES];
    else
        [swtUseImmediately setOn:NO];
}

- (void)Next_Click
{
    [super Next_Click];
    
    NSNumber *is_valid_new_customer_only;
    NSNumber *use_immediately;
    
    is_valid_new_customer_only = [NSNumber numberWithBool:swtNewCustomer.on];
    use_immediately = [NSNumber numberWithBool:swtUseImmediately.on];
    
    self.deal_controller.deal_obj.is_valid_new_customer_only = is_valid_new_customer_only;
    self.deal_controller.deal_obj.use_deal_immediately = use_immediately;

    if(vc_deal_fine_print == nil)
    {
        vc_deal_fine_print = [[Deal_Fine_Print alloc]init];
    }
    vc_deal_fine_print.deal_controller = self.deal_controller;
    vc_deal_fine_print.merchant_controller = self.merchant_controller;
    vc_deal_fine_print.system_controller = self.system_controller;
    vc_deal_fine_print.hidesBottomBarWhenPushed = YES;
    
    if(![self.navigationController.topViewController isKindOfClass:[Deal_Fine_Print class]])
    {
        [self.navigationController pushViewController:vc_deal_fine_print animated:YES];
    }
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}


@end
