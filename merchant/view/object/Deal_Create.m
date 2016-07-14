#import "Deal_Create.h"


@interface Deal_Create ()
{
    
    BOOL keyboardIsShown;
    
    UILabel *lblPercentOff;
    UISlider *sldPercentOff;
    GTTextField *txtMaxDollar;
    GTPopup *imvMaxDollarInfo;
    GTTextField *txtCertificateQty;
    GTPopup *imvCertificateQtyInfo;
    GTTextFieldDate *txtExpirationDate;
    GTPopup *imvExpirationDateInfo;
    
    Deal_Options *vc_deal_options;
    Deal *deal_obj;
}
@end


@implementation Deal_Create

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"CREATE";
    self.left_button = @"cancel";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    /* for some reason this must be in viewWillAppear or it is distorted */
    [self Create_Layout];
    
    keyboardIsShown = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.loaded)
    {
        [self Load_System_Settings];
    }
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
    CGFloat text_field_width = (self.screen_width * .3125);
    CGFloat text_field_x = (self.screen_width * .65);
    CGFloat text_field_y = (view_height/2) - (self.text_field_height/2);
    CGFloat label_y;
    CGFloat image_x;
    CGFloat image_y;
    CGFloat image_width = (self.screen_width * .09375);

    /* view 1 */
    UIView* view_1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_width, view_height)];
    view_1.backgroundColor = [UIColor whiteColor];

    GTLabel* lblPercentOffLabel = [Coding Create_Label:@"Percentage Off" width:self.screen_indent_width_half font:label_font mult:NO];
    label_y = (view_height/3) - ([Utilities Get_Height:lblPercentOffLabel]/2);
    [Coding Add_View:view_1 view:lblPercentOffLabel x:self.screen_indent_x height:[Utilities Get_Height:lblPercentOffLabel] prev_frame:CGRectNull gap:label_y];
    
    lblPercentOff = [Coding Create_Label:@"" width:self.screen_indent_width_half font:label_font mult:NO];
    label_y = (view_height/3) - ([Utilities Get_Height:lblPercentOff]/2);
    CGFloat right_label_x = self.screen_width - (self.gap * 15);
    [Coding Add_View:view_1 view:lblPercentOff x:right_label_x height:[Utilities Get_Height:lblPercentOff] prev_frame:CGRectNull gap:label_y];
    
    CGFloat slider_height = (self.screen_height * .0525);
    sldPercentOff = [[UISlider alloc] initWithFrame:CGRectMake(0.0, 0.0, self.screen_indent_width, slider_height)];
    [sldPercentOff addTarget:self action:@selector(sldPercentOff_Changed) forControlEvents:UIControlEventValueChanged];
    [Coding Add_View:view_1 view:sldPercentOff x:self.screen_indent_x height:sldPercentOff.frame.size.height prev_frame:lblPercentOffLabel.frame gap:(self.gap)];
    
    /* view 2 */
    UIView* view_2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_width, view_height)];
    view_2.backgroundColor = [UIColor whiteColor];

    GTLabel* lblMaxDollarLabel = [Coding Create_Label:@"Max Dollar Amount" width:self.screen_indent_width_half font:label_font mult:NO];
    label_y = (view_height/2) - ([Utilities Get_Height:lblMaxDollarLabel]/2);
    [Coding Add_View:view_2 view:lblMaxDollarLabel x:self.screen_indent_x height:[Utilities Get_Height:lblMaxDollarLabel] prev_frame:CGRectNull gap:label_y];

    imvMaxDollarInfo = [[GTPopup alloc]initWithFrame:CGRectMake(0, 0, image_width, image_width)];
    [imvMaxDollarInfo setImage:[UIImage imageNamed:@"question_mark.png"]];
    image_x = lblMaxDollarLabel.frame.origin.x + lblMaxDollarLabel.frame.size.width + self.gap;
    image_y = (view_height/2) - (imvMaxDollarInfo.frame.size.height/2);
    [Coding Add_View:view_2 view:imvMaxDollarInfo x:image_x height:imvMaxDollarInfo.frame.size.height prev_frame:CGRectNull gap:image_y];
    
    txtMaxDollar = [Coding Create_Text_Field:@"" format_type:@"number" characters:@3 width:text_field_width height:self.text_field_height font:text_field_font];
    txtMaxDollar.layer.borderWidth = .5f;
    [txtMaxDollar addTarget:self action:@selector(Set_Keyboard_Y:) forControlEvents:UIControlEventEditingDidBegin];
    [Coding Add_View:view_2 view:txtMaxDollar x:text_field_x height:txtMaxDollar.frame.size.height prev_frame:CGRectNull gap:text_field_y];
    
    /* view 3 */
    UIView* view_3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_width, view_height)];
    view_3.backgroundColor = [UIColor whiteColor];
    
    GTLabel* lblCertQtyLabel = [Coding Create_Label:@"Certificate Quantity" width:self.screen_indent_width_half font:label_font mult:NO];
    label_y = (view_height/2) - ([Utilities Get_Height:lblCertQtyLabel]/2);
    [Coding Add_View:view_3 view:lblCertQtyLabel x:self.screen_indent_x height:[Utilities Get_Height:lblCertQtyLabel] prev_frame:CGRectNull gap:label_y];
    
    imvCertificateQtyInfo = [[GTPopup alloc]initWithFrame:CGRectMake(0, 0, image_width, image_width)];
    [imvCertificateQtyInfo setImage:[UIImage imageNamed:@"question_mark.png"]];
    image_x = lblCertQtyLabel.frame.origin.x + lblCertQtyLabel.frame.size.width + self.gap;
    image_y = (view_height/2) - (imvMaxDollarInfo.frame.size.height/2);
    [Coding Add_View:view_3 view:imvCertificateQtyInfo x:image_x height:imvCertificateQtyInfo.frame.size.height prev_frame:CGRectNull gap:image_y];
    
    txtCertificateQty = [Coding Create_Text_Field:@"" format_type:@"number" characters:@4 width:text_field_width height:self.text_field_height font:text_field_font];
    txtCertificateQty.layer.borderWidth = .5f;
    [txtCertificateQty addTarget:self action:@selector(Set_Keyboard_Y:) forControlEvents:UIControlEventEditingDidBegin];
    [Coding Add_View:view_3 view:txtCertificateQty x:text_field_x height:txtCertificateQty.frame.size.height prev_frame:CGRectNull gap:text_field_y];
    
    /* view 4 */
    UIView* view_4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_width, view_height)];
    view_4.backgroundColor = [UIColor whiteColor];
    
    GTLabel* lblExpDateLabel = [Coding Create_Label:@"Expiration Date" width:self.screen_indent_width_half font:label_font mult:NO];
    label_y = (view_height/2) - ([Utilities Get_Height:lblExpDateLabel]/2);
    [Coding Add_View:view_4 view:lblExpDateLabel x:self.screen_indent_x height:[Utilities Get_Height:lblExpDateLabel] prev_frame:CGRectNull gap:label_y];
    
    imvExpirationDateInfo = [[GTPopup alloc]initWithFrame:CGRectMake(0, 0, image_width, image_width)];
    [imvExpirationDateInfo setImage:[UIImage imageNamed:@"question_mark.png"]];
    image_x = lblCertQtyLabel.frame.origin.x + lblCertQtyLabel.frame.size.width + self.gap;
    image_y = (view_height/2) - (imvMaxDollarInfo.frame.size.height/2);
    [Coding Add_View:view_4 view:imvExpirationDateInfo x:image_x height:imvExpirationDateInfo.frame.size.height prev_frame:CGRectNull gap:image_y];
    
    txtExpirationDate = [Coding Create_Date_Field:@"" width:text_field_width height:self.text_field_height font:text_field_font];
    txtExpirationDate.layer.borderWidth = .5f;
    [txtExpirationDate addTarget:self action:@selector(Set_Keyboard_Y:) forControlEvents:UIControlEventEditingDidBegin];
    [Coding Add_View:view_4 view:txtExpirationDate x:text_field_x height:txtExpirationDate.frame.size.height prev_frame:CGRectNull gap:text_field_y];
    
    [Coding Add_View:contentView view:view_1 x:0 height:view_1.frame.size.height prev_frame:CGRectNull gap:(self.gap * 7)];
    [Coding Add_View:contentView view:view_2 x:0 height:view_2.frame.size.height prev_frame:view_1.frame gap:(self.gap * 2)];
    [Coding Add_View:contentView view:view_3 x:0 height:view_3.frame.size.height prev_frame:view_2.frame gap:(self.gap * 2)];
    [Coding Add_View:contentView view:view_4 x:0 height:view_2.frame.size.height prev_frame:view_3.frame gap:(self.gap * 2)];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:view_4.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

-(void)Load_System_Settings
{
    CGFloat popup_width = (self.screen_width * .875);
    CGFloat popup_height = (self.screen_height * .70);
    
    [self Progress_Show:@"Loading"];
    
    [self.system_controller Get_System_Settings:^(void)
     {
         successful = self.system_controller.successful;
         system_successful_obj = self.system_controller.system_successful_obj;
         system_error_obj = self.system_controller.system_error_obj;
         
         if(successful)
         {
             sldPercentOff.minimumValue = [self.system_controller.system_settings_obj.percent_off_min floatValue];
             sldPercentOff.maximumValue = [self.system_controller.system_settings_obj.percent_off_max floatValue];
             sldPercentOff.value = [self.system_controller.system_settings_obj.percent_off_default floatValue];
             [self sldPercentOff_Changed];
    
             sldPercentOff.minimumValue = [@40 floatValue];// [self.system_controller.system_settings_obj.percent_off_min floatValue];
             sldPercentOff.maximumValue = [@90 floatValue];//[self.system_controller.system_settings_obj.percent_off_max floatValue];
             sldPercentOff.value = [@50 floatValue];//[self.system_controller.system_settings_obj.percent_off_default floatValue];
             [self sldPercentOff_Changed];

             [imvMaxDollarInfo Initialize:[UIImage imageNamed:@"question_mark.png"]
                                view_size:CGSizeMake(popup_width, popup_height)
                               input_text:self.system_controller.system_settings_obj.dollar_value_info];

             [imvCertificateQtyInfo Initialize:[UIImage imageNamed:@"question_mark.png"]
                                     view_size:CGSizeMake(popup_width, popup_height)
                                    input_text:self.system_controller.system_settings_obj.certificate_quantity_info];

             [imvExpirationDateInfo Initialize:[UIImage imageNamed:@"question_mark.png"]
                                     view_size:CGSizeMake(popup_width, popup_height)
                                    input_text:self.system_controller.system_settings_obj.expiration_days_info];
    
             if((self.deal_controller.deal_obj.deal_id != nil) &&(!self.loaded))
             {
                 sldPercentOff.value = [self.deal_controller.deal_obj.percent_off floatValue];
                 [self sldPercentOff_Changed];
                 
                 [txtMaxDollar setText:[self.deal_controller.deal_obj.max_dollar_amount stringValue]];
                 [txtCertificateQty setText:[self.deal_controller.deal_obj.certificate_quantity stringValue]];
                 
                 NSString *time_zone = self.merchant_controller.merchant_contact_obj.merchant_obj.zip_code_obj.time_zone_obj.abbreviation;
                 NSDate * expiration_date = self.deal_controller.deal_obj.expiration_date;
                 NSDateFormatter *expiration_date_format = [[NSDateFormatter alloc] init];
                 [expiration_date_format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:time_zone]];
                 [expiration_date_format setDateFormat:@"M/d/yyyy"];
                 [txtExpirationDate setText:[expiration_date_format stringFromDate:expiration_date]];
             }
             else
             {
                 deal_obj = nil;
                 vc_deal_options = nil;
                 
                 [lblPercentOff setText:[NSString stringWithFormat:@"%d%%",(int)sldPercentOff.value]];
                 [txtMaxDollar setText:@""];
                 [txtCertificateQty setText:@""];
                 [txtExpirationDate setText:@""];
             }
             
             self.loaded = YES;
             
             [self Progress_Close];
             
             if(self.debug)
                 [self Debug];
         }
         else
         {
             [self Progress_Close];
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void)sldPercentOff_Changed
{
    [lblPercentOff setText:[NSString stringWithFormat:@"%d%%",(int)sldPercentOff.value]];
}

-(void)Set_Keyboard_Y:(id)sender
{
    if ([sender isEqual:txtMaxDollar])
    {
        self.keyboard_y_coordinate = 50;
    }
    else if ([sender isEqual:txtCertificateQty])
    {
        self.keyboard_y_coordinate = 100;
    }
    else if ([sender isEqual:txtExpirationDate])
    {
        self.keyboard_y_coordinate = 150;
    }
}

- (void)Next_Click
{
    NSDecimalNumber *certificate_quantity;
    NSDecimalNumber *dollar_value;
    NSNumber *percent_off;
    
    percent_off = [NSNumber numberWithInt:sldPercentOff.value];
    
    if([Utilities IsNumeric:txtCertificateQty.text])
    {
        certificate_quantity = [NSDecimalNumber decimalNumberWithString:txtCertificateQty.text];
    }
    
    if([Utilities IsNumeric:txtMaxDollar.text])
    {
        dollar_value = [NSDecimalNumber decimalNumberWithString:txtMaxDollar.text];
    }
    
    NSString *time_zone = self.merchant_controller.merchant_contact_obj.merchant_obj.zip_code_obj.time_zone_obj.abbreviation;
    NSDateFormatter *expiration_date_format = [[NSDateFormatter alloc] init];
    [expiration_date_format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:time_zone]];
    [expiration_date_format setDateFormat:@"M/d/yyyy"];
    NSDate *expiration_date = [expiration_date_format dateFromString:txtExpirationDate.text];
    deal_obj.expiration_date = expiration_date;
    
    NSComparisonResult compare_min_dollar_value = [dollar_value compare:self.system_controller.system_settings_obj.dollar_value_min];
    NSComparisonResult compare_max_dollar_value = [dollar_value compare:self.system_controller.system_settings_obj.dollar_value_max];
    NSComparisonResult compare_min_certificate_quantity = [certificate_quantity compare:self.system_controller.system_settings_obj.certificate_quantity_min];
    NSComparisonResult compare_max_certificate_quantity = [certificate_quantity compare:self.system_controller.system_settings_obj.certificate_quantity_max];
   
    NSInteger expiration_date_days = [Utilities daysBetweenDate:[NSDate date] andDate:expiration_date];
    
    NSDateFormatter *today_format = [[NSDateFormatter alloc] init];
    [today_format setDateFormat:@"M/d/yyyy"];
    [today_format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:time_zone]];
    NSDate *today = [[NSDate alloc] init];
    NSString *today_string = [today_format stringFromDate:today];
    NSDate *today_short = [expiration_date_format dateFromString:today_string];
    NSDate *min_expiration_date = [today_short dateByAddingTimeInterval:60*60*24*([self.system_controller.system_settings_obj.expiration_days_min integerValue]-1)];
    NSDate *max_expiration_date = [today_short dateByAddingTimeInterval:60*60*24*([self.system_controller.system_settings_obj.expiration_days_max integerValue]+1)];
  
    if(dollar_value == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must enter a maxiumum dollar value" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtMaxDollar becomeFirstResponder];
    }
    else if(compare_min_dollar_value == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Maximum dollar amount is too low" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtMaxDollar becomeFirstResponder];
    }
    else if(compare_max_dollar_value == NSOrderedDescending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Maximum dollar amount is too high" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtMaxDollar becomeFirstResponder];
    }
    else if(certificate_quantity == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must the number of certificates" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtCertificateQty becomeFirstResponder];
    }
    else if(compare_min_certificate_quantity == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Certificate quantity too low" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtCertificateQty becomeFirstResponder];
    }
    else if(compare_max_certificate_quantity == NSOrderedDescending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Certificate quantity is too high" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtCertificateQty becomeFirstResponder];
    }
    else if(expiration_date_days < [self.system_controller.system_settings_obj.expiration_days_min integerValue])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yyyy"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:time_zone]];
        NSString *stringFromDate = [formatter stringFromDate:min_expiration_date];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@%@", @"Expiration date must be after ", stringFromDate]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtExpirationDate becomeFirstResponder];
    }
    else if(expiration_date_days > [self.system_controller.system_settings_obj.expiration_days_max integerValue])
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yyyy"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:time_zone]];
        NSString *stringFromDate = [formatter stringFromDate:max_expiration_date];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@%@", @"Expiration date must be before ", stringFromDate]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtExpirationDate becomeFirstResponder];
    }
    else
    {
        [super Next_Click];

        if(self.deal_controller.deal_obj.deal_id == nil)
        {
            deal_obj = nil;
            deal_obj = [[Deal alloc]init];
        }
        else
        {
            deal_obj = self.deal_controller.deal_obj;
        }
        
        deal_obj.percent_off = percent_off;
        deal_obj.max_dollar_amount = dollar_value;
        deal_obj.certificate_quantity = certificate_quantity;
        deal_obj.expiration_date = expiration_date;
        deal_obj.merchant_contact_obj = self.merchant_controller.merchant_contact_obj;
        
        self.deal_controller.deal_obj = deal_obj;
        
        if(vc_deal_options == nil)
        {
            vc_deal_options = [[Deal_Options alloc]init];
        }
        vc_deal_options.deal_controller = self.deal_controller;
        vc_deal_options.merchant_controller = self.merchant_controller;
        vc_deal_options.system_controller = self.system_controller;
        vc_deal_options.hidesBottomBarWhenPushed = YES;
        
        if(![self.navigationController.topViewController isKindOfClass:[Deal_Options class]])
        {
            [self.navigationController pushViewController:vc_deal_options animated:YES];
        }
    }
}

-(void) Cancel_Click
{
    GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Cancel" message:@"Are you sure you want to cancel?" cancelButtonTitle:@"Yes" otherButtonTitles:@[@"No"]];
    alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
    {
        if (cancelled)
        {
            deal_obj = nil;
            self.deal_controller.deal_obj = nil;
            self.loaded  = NO;
            
            [self.tabBarController setSelectedIndex:0];
            [self.navigationController popToRootViewControllerAnimated:TRUE];
        }
    };
    
    [alert show];
}

-(void)Back_Click
{
    [lblPercentOff setText:@""];
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)Debug
{
    txtMaxDollar.text = @"25";
    txtCertificateQty.text = @"250";
    txtExpirationDate.text = @"8/1/2016";
}

@end
