#import "Certificate_Redeem.h"


@interface Certificate_Redeem ()
{
    ACPButton* btnRedeem;
}
@end


@implementation Certificate_Redeem

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screen_title = @"REDEEM";
    self.left_button = @"back";
    self.right_button = @"";
    
    [self Set_Controller_Properties];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self Create_Layout];
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

- (void)statusFrameChanged:(NSNotification*)note
{
    CGRect status_frame = [note.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    CGFloat status_bar_height = status_frame.size.height;
    
    CGFloat button_y;
    if(status_bar_height == 20)
        button_y = 448;
    else
        button_y = 428;

    btnRedeem.frame = CGRectMake(0, button_y, 320, 55.0);
}


/* public methods */

-(void) Create_Layout
{
    [[contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    /* start adding your views */
    GTLabel *lblCertificateCode = [Coding Create_Label:self.deal_controller.certificate_obj.certificate_code width:self.screen_indent_width font:label_font_medium mult:NO];
    [Coding Add_View:contentView view:lblCertificateCode x:self.screen_indent_x height:lblCertificateCode.frame.size.height prev_frame:CGRectNull gap:(self.gap * 5)];
    
    GTLabel *lblStatus = [Coding Create_Label:self.deal_controller.certificate_obj.status_text_1 width:self.screen_indent_width font:label_font mult:YES];
    [Coding Add_View:contentView view:lblStatus x:self.screen_indent_x height:[Utilities Get_Height:lblStatus] prev_frame:lblCertificateCode.frame gap:self.gap];
    
    UIView *vwLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_indent_width, 1)];
    vwLine1.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
    [Coding Add_View:contentView view:vwLine1 x:self.screen_indent_x height:1 prev_frame:lblStatus.frame gap:20];
    
    GTLabel *lblName = [Coding Create_Label:[NSString stringWithFormat:@"%@%@%@", self.deal_controller.customer_obj.contact_obj.first_name, @" ", self.deal_controller.customer_obj.contact_obj.last_name] width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblName x:self.screen_indent_x height:lblName.frame.size.height prev_frame:vwLine1.frame gap:(self.gap * 5)];
    
    GTLabel *lblEmail = [Coding Create_Label:self.deal_controller.customer_obj.contact_obj.email width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblEmail x:self.screen_indent_x height:lblEmail.frame.size.height prev_frame:lblName.frame gap:(self.gap * 2)];
    
    /* set assigned date */
    NSString *time_zone = self.deal_controller.deal_obj.time_zone_obj.abbreviation;
    NSDate * assigned_date = self.deal_controller.certificate_obj.assigned_date;
    NSDateFormatter *assigned_date_format = [[NSDateFormatter alloc] init];
    [assigned_date_format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:time_zone]];
    [assigned_date_format setDateFormat:@"M/d/yyyy"];
    GTLabel *lblPurchased = [Coding Create_Label:[NSString stringWithFormat:@"%@%@", @"Purchased on ", [assigned_date_format stringFromDate:assigned_date]] width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblPurchased x:self.screen_indent_x height:lblPurchased.frame.size.height prev_frame:lblEmail.frame gap:(self.gap * 2)];
    
    GTLabel *lblPayment = [Coding Create_Label:self.deal_controller.certificate_payment_obj.card_number width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblPayment x:self.screen_indent_x height:lblPayment.frame.size.height prev_frame:lblPurchased.frame gap:(self.gap * 2)];
    
    UIView *vwLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_indent_width, 1)];
    vwLine2.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
    [Coding Add_View:contentView view:vwLine2 x:self.screen_indent_x height:1 prev_frame:lblPayment.frame gap:(self.gap * 5)];
    
    GTLabel *lblDeal = [Coding Create_Label:self.deal_controller.deal_obj.deal width:self.screen_indent_width font:label_font_medium mult:NO];
    [Coding Add_View:contentView view:lblDeal x:self.screen_indent_x height:lblDeal.frame.size.height prev_frame:vwLine2.frame gap:(self.gap * 5)];
    
    GTLabel *lblFinePrint = [Coding Create_Label:self.deal_controller.deal_obj.fine_print_ext width:self.screen_indent_width font:label_font mult:YES];
    [Coding Add_View:contentView view:lblFinePrint x:self.screen_indent_x height:[Utilities Get_Height:lblFinePrint] prev_frame:lblDeal.frame gap:(self.gap * 5)];

    [self Add_View:self.screen_width height:[self Get_Scroll_Height:lblFinePrint.frame scroll_lag:self.button_height] background_color:[UIColor whiteColor]];

    if([self.deal_controller.certificate_obj.certificate_status_obj.status isEqualToString:@"Active"])
    {
        /* add layer on top */
        CGFloat nav_bar_height = self.navigationController.navigationBar.frame.size.height;
        CGRect status_frame = [(AppDelegate*)[[UIApplication sharedApplication] delegate] currentStatusBarFrame];
        CGFloat status_bar_height = status_frame.size.height;
        CGFloat button_y = self.screen_height - self.button_height - nav_bar_height - status_bar_height;
        
        btnRedeem = [Coding Create_Button:@"Redeem" font:button_font style:ACPButtonGreen text_color:[UIColor whiteColor] width:self.screen_width height:self.button_height];
        [btnRedeem addTarget:self action:@selector(btnRedeem_Click) forControlEvents:UIControlEventTouchUpInside];
        [Coding Add_View:self.view view:btnRedeem x:0 height:btnRedeem.frame.size.height prev_frame:CGRectNull gap:button_y];
    }
}

-(void)btnRedeem_Click
{
    [self.deal_controller Redeem_Certificate:^(void)
     {
         successful = self.deal_controller.successful;
         system_successful_obj = self.deal_controller.system_successful_obj;
         system_error_obj = self.deal_controller.system_error_obj;
         
         [self Progress_Close];
         
         if(successful)
         {
             GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Successful" message:system_successful_obj.message cancelButtonTitle:@"OK" otherButtonTitles:nil];
             
             alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
             {
                 if (cancelled)
                 {
                     [self.navigationController popToRootViewControllerAnimated:TRUE];
                 }
             };
             
             [alert show];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
