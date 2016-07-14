#import "Deal_Info.h"


@interface Deal_Info ()
{
    ACPButton *btnValidate;
    ACPButton *btnModify;
    ACPButton *btnCancel;
}

@end


@implementation Deal_Info

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screen_title = @"DEAL INFO";
    self.left_button = @"back";
    self.right_button = @"";
    
    [self Set_Controller_Properties];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self Progress_Show:@"Loading"];
    
    [self Create_Layout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /* not sure why i need this, but screen will lock up without it */
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
    self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = YES;
    self.navigationController.navigationBar.topItem.backBarButtonItem.enabled = YES;
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* public methods */
-(void)Create_Layout
{
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGRect prev_frame;
    CGFloat landscape_image_height = self.screen_width * .66;
    CGFloat small_button_width = self.screen_indent_width/1.5;
    CGFloat small_button_height = (self.screen_height/19);
    
    /* start adding your views */
    UIImageView *imvLogo = [[UIImageView alloc] initWithFrame:CGRectMake(self.screen_indent_x, 12, self.screen_indent_width, landscape_image_height)];
    imvLogo.layer.borderWidth = 1.0f;
    [imvLogo sd_setImageWithURL:[NSURL URLWithString:self.deal_controller.deal_obj.image]
               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [contentView addSubview:imvLogo];
    
    GTLabel *lblDealLabel = [Coding Create_Label:@"DEAL" width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblDealLabel x:self.screen_indent_x height:[Utilities Get_Height:lblDealLabel] prev_frame:imvLogo.frame gap:(self.gap * 5)];
    
    GTLabel *lblDeal = [Coding Create_Label:self.deal_controller.deal_obj.deal width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblDeal x:self.screen_indent_x height:lblDeal.frame.size.height prev_frame:lblDealLabel.frame gap:0];
    
    UIView *vwLine1 = [[UIView alloc] initWithFrame:CGRectMake(self.screen_indent_x, 0, self.screen_indent_width, 1)];
    vwLine1.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
    [Coding Add_View:contentView view:vwLine1 x:self.screen_indent_x height:1 prev_frame:lblDeal.frame gap:(self.gap * 5)];
    
    GTLabel *lblExpirationLabel = [Coding Create_Label:@"EXPIRATION DATE" width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblExpirationLabel x:self.screen_indent_x height:[Utilities Get_Height:lblExpirationLabel] prev_frame:vwLine1.frame gap:(self.gap * 6.5)];
    
    NSString *time_zone = self.deal_controller.deal_obj.time_zone_obj.abbreviation;
    NSDate * expiration_date = self.deal_controller.deal_obj.expiration_date;
    NSDateFormatter *expiration_date_format = [[NSDateFormatter alloc] init];
    [expiration_date_format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:time_zone]];
    [expiration_date_format setDateFormat:@"M/d/yyyy"];
    GTLabel *lblExpirationDate = [Coding Create_Label:[expiration_date_format stringFromDate:expiration_date] width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblExpirationDate x:self.screen_indent_x height:[Utilities Get_Height:lblExpirationDate] prev_frame:lblExpirationLabel.frame gap:0];
    
    UIView *vwLine2 = [[UIView alloc] initWithFrame:CGRectMake(self.screen_indent_x, 0, self.screen_indent_width, 1)];
    vwLine2.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
    [Coding Add_View:contentView view:vwLine2 x:self.screen_indent_x height:1 prev_frame:lblExpirationDate.frame gap:(self.gap * 5)];
    
    GTLabel *lblStatusLabel = [Coding Create_Label:@"STATUS" width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblStatusLabel x:self.screen_indent_x height:[Utilities Get_Height:lblStatusLabel] prev_frame:vwLine2.frame gap:(self.gap * 5)];
    
    GTLabel *lblStatus = [Coding Create_Label:self.deal_controller.deal_obj.deal_status_obj.status width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblStatus x:self.screen_indent_x height:[Utilities Get_Height:lblStatus] prev_frame:lblStatusLabel.frame gap:0];
    
    if([self.deal_controller.deal_obj.deal_status_obj.status_id isEqualToNumber:[NSNumber numberWithInt:5]])
    {    btnValidate = [[ACPButton alloc]init];
        [btnValidate setStyleType:ACPButtonGreen];
        [btnValidate setLabelFont:[UIFont fontWithName:@"AvenirNext-Medium" size:18]];
        [btnValidate setLabelTextColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] disableColor:nil];
        [btnValidate addTarget:self action:@selector(btnValidate_Click:) forControlEvents:UIControlEventTouchUpInside];
        [btnValidate setTitle:@"Validate Deal" forState:UIControlStateNormal];
        btnValidate.frame = CGRectMake(self.screen_indent_x, 0, small_button_width, small_button_height);
        [Coding Add_View:contentView view:btnValidate x:self.screen_indent_x height:btnValidate.frame.size.height prev_frame:lblStatus.frame gap:(self.gap * 2.5)];
        
        prev_frame = btnValidate.frame;
    }
    else
    {
        prev_frame = lblStatus.frame;
    }

    UIView *vwLine3 = [[UIView alloc] initWithFrame:CGRectMake(self.screen_indent_x, 0, self.screen_indent_width, 1)];
    vwLine3.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
    [Coding Add_View:contentView view:vwLine3 x:self.screen_indent_x height:1 prev_frame:prev_frame gap:(self.gap * 5)];
    
    GTLabel *lblStatsLabel = [Coding Create_Label:@"STATS" width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblStatsLabel x:self.screen_indent_x height:[Utilities Get_Height:lblStatsLabel] prev_frame:vwLine3.frame gap:(self.gap * 5)];
    
    GTLabel *lblCertificatesIssued = [Coding Create_Label:[NSString stringWithFormat:@"%@%@", [self.deal_controller.deal_obj.certificate_quantity stringValue], @" certificates issued"] width:self.screen_indent_width font:label_font mult:YES];
    [Coding Add_View:contentView view:lblCertificatesIssued x:self.screen_indent_x height:[Utilities Get_Height:lblCertificatesIssued] prev_frame:lblStatsLabel.frame gap:(self.gap * 2)];
    
    GTLabel *lblCertificatesBought = [Coding Create_Label:[NSString stringWithFormat:@"%ld%@", (long)[self.deal_controller.deal_obj.certificates_sold integerValue], @" certificates bought"] width:self.screen_indent_width font:label_font mult:YES];
    [Coding Add_View:contentView view:lblCertificatesBought x:self.screen_indent_x height:[Utilities Get_Height:lblCertificatesBought] prev_frame:lblCertificatesIssued.frame gap:0];
    
    GTLabel *lblCertificatesRedeemed = [Coding Create_Label:[NSString stringWithFormat:@"%ld%@", (long)[self.deal_controller.deal_obj.certificates_redeemed integerValue], @" certificates redeemed"] width:self.screen_indent_width font:label_font mult:YES];
    [Coding Add_View:contentView view:lblCertificatesRedeemed x:self.screen_indent_x height:[Utilities Get_Height:lblCertificatesRedeemed] prev_frame:lblCertificatesBought.frame gap:0];
    
    UIView *vwLine4 = [[UIView alloc] initWithFrame:CGRectMake(self.screen_indent_x, 0, self.screen_indent_width, 1)];
    vwLine4.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
    [Coding Add_View:contentView view:vwLine4 x:self.screen_indent_x height:1 prev_frame:lblCertificatesRedeemed.frame gap:(self.gap * 5)];
    
    GTLabel *lblFinePrintLabel = [Coding Create_Label:@"FINE PRINT" width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblFinePrintLabel x:self.screen_indent_x height:[Utilities Get_Height:lblFinePrintLabel] prev_frame:vwLine4.frame gap:(self.gap * 5)];
    
    GTLabel *lblFinePrint = [Coding Create_Label:self.deal_controller.deal_obj.fine_print_ext width:self.screen_indent_width font:label_font mult:YES];
    [Coding Add_View:contentView view:lblFinePrint x:self.screen_indent_x height:[Utilities Get_Height:lblFinePrint] prev_frame:lblFinePrintLabel.frame gap:0];
    
    prev_frame = lblFinePrint.frame;
    
    btnModify = [[ACPButton alloc]init];
    [btnModify setStyleType:ACPButtonBlue];
    [btnModify setLabelTextColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] disableColor:nil];
    [btnModify addTarget:self action:@selector(btnModify_Click:) forControlEvents:UIControlEventTouchUpInside];
    [btnModify setTitle:@"Modify Deal" forState:UIControlStateNormal];
    btnModify.frame = CGRectMake(self.screen_indent_x, 0, self.screen_indent_width, self.button_height);
    
    btnCancel = [[ACPButton alloc]init];
    [btnCancel setStyleType:ACPButtonRed];
    [btnCancel setLabelTextColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] disableColor:nil];
    [btnCancel addTarget:self action:@selector(btnCancel_Click:) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setTitle:@"Cancel Deal" forState:UIControlStateNormal];
    btnCancel.frame = CGRectMake(self.screen_indent_x, 448.0, self.screen_indent_width, self.button_height);
 
    int status_id = [self.deal_controller.deal_obj.deal_status_obj.status_id intValue];
    switch (status_id)
    {
        case 1: /* Active */
        case 4: /* Pending Approval */
            [Coding Add_View:contentView view:btnCancel x:self.screen_indent_x height:btnCancel.frame.size.height prev_frame:lblFinePrint.frame gap:(self.gap * 4)];
            prev_frame = btnCancel.frame;
            break;
        case 5: /* Pending Validation */
        case 6: /* Rejected */
            [Coding Add_View:contentView view:btnModify x:self.screen_indent_x height:btnModify.frame.size.height prev_frame:lblFinePrint.frame gap:(self.gap * 4)];
            [Coding Add_View:contentView view:btnCancel x:self.screen_indent_x height:btnCancel.frame.size.height prev_frame:btnModify.frame gap:(self.gap * 2.5)];
            prev_frame = btnCancel.frame;
            break;
        default:
            break;
    }
    
    CGRect last_frame = prev_frame;
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:last_frame scroll_lag:self.gap] background_color:[UIColor whiteColor]];

    [self Progress_Close];
}

-(void)btnValidate_Click:(id)sender
{
    [self Progress_Show:@"Sending Validation"];
    [btnValidate setEnabled:NO];
    
    self.deal_controller.merchant_contact_obj = self.merchant_controller.merchant_contact_obj;
    [self.deal_controller Send_Deal_Validation:^(void)
     {
         successful = self.deal_controller.successful;
         system_successful_obj = self.deal_controller.system_successful_obj;
         system_error_obj = self.deal_controller.system_error_obj;
         
         [self Progress_Close];
         [btnValidate setEnabled:YES];
         
         if(successful)
         {
             GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Validation" message:system_successful_obj.message cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
             {
                 Deal_Validate* deal_validate = [[Deal_Validate alloc]init];
                 deal_validate.calling_view = NSStringFromClass([self class]);
                 deal_validate.deal_controller = self.deal_controller;
                 deal_validate.merchant_controller = self.merchant_controller;
                 deal_validate.system_controller = self.system_controller;
                 deal_validate.hidesBottomBarWhenPushed = YES;
                 
                 if(![self.navigationController.topViewController isKindOfClass:[Deal_Validate class]])
                 {
                     [self.navigationController pushViewController:deal_validate animated:YES];
                 }
             };
             
             [alert show];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

-(void)btnModify_Click:(id)sender
{
    Deal_Create* deal_create = [[Deal_Create alloc]init];
    deal_create.calling_view = NSStringFromClass([self class]);
    deal_create.deal_controller = self.deal_controller;
    deal_create.merchant_controller = self.merchant_controller;
    deal_create.system_controller = self.system_controller;
    deal_create.hidesBottomBarWhenPushed = YES;

    if(![self.navigationController.topViewController isKindOfClass:[Deal_Create class]])
    {
     [self.navigationController pushViewController:deal_create animated:YES];
    }
}

-(void)btnCancel_Click:(id)sender
{
    GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Cancel Deal" message:@"Are you sure you want to cancel this deal?" cancelButtonTitle:@"No" otherButtonTitles:@[@"Yes"]];
    alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
    {
        if (!cancelled)
        {
            [self Progress_Show:@"Cancelling"];
            [btnCancel setEnabled:NO];
            
            self.deal_controller.merchant_contact_obj = self.merchant_controller.merchant_contact_obj;
            [self.deal_controller Cancel_Deal:^(void)
             {
                 successful = self.deal_controller.successful;
                 system_successful_obj = self.deal_controller.system_successful_obj;
                 system_error_obj = self.deal_controller.system_error_obj;
                 
                 [self Progress_Close];
                 [btnCancel setEnabled:YES];
                 
                 if(successful)
                 {
                     [self.navigationController popToRootViewControllerAnimated:TRUE];
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
             }];
        }
    };
    
    [alert show];
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}



@end
