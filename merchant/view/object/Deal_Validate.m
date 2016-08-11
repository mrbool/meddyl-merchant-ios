#import "Deal_Validate.h"
#import "Deal_Create.h"


@interface Deal_Validate ()
{
    GTLabel *lblPhone;
    GTTextField *txtValidationCode;
    ACPButton *btnSendValidation;
}
@end


@implementation Deal_Validate
{
    Deal_Create *deal_create;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"VALIDATE DEAL";
    self.left_button = @"later";
    self.right_button = @"";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self Load_Data];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* public methods */
-(void) Create_Layout
{
    CGFloat certificate_text_width = (self.screen_indent_width * .75);
    CGFloat certificate_text_x = ((self.screen_width * .5) - (certificate_text_width * .5));
    txtValidationCode = [Coding Create_Text_Field:@"" format_type:@"number" characters:@4 width:certificate_text_width height:(self.screen_height * .1) font:text_field_font_large];
    [txtValidationCode addTarget:self action:@selector(Validate_Code) forControlEvents:UIControlEventEditingChanged];
    [Coding Add_View:contentView view:txtValidationCode x:certificate_text_x height:txtValidationCode.frame.size.height prev_frame:CGRectNull gap:(self.gap * 20)];
    
    lblPhone = [Coding Create_Label:@"" width:self.screen_indent_width font:label_font mult:NO];
    [lblPhone setNumberOfLines:1];
    lblPhone.adjustsFontSizeToFitWidth=YES;
    [lblPhone setTextAlignment:NSTextAlignmentCenter];
    [Coding Add_View:contentView view:lblPhone x:self.screen_indent_x height:lblPhone.frame.size.height prev_frame:txtValidationCode.frame gap:(self.gap * 2)];
    
    btnSendValidation = [Coding Create_Button:@"Resend Code" font:button_font style:ACPButtonDarkGrey text_color:[UIColor whiteColor] width:self.screen_indent_width height:self.button_height];
    [btnSendValidation addTarget:self action:@selector(btnSendValidation_Click:) forControlEvents:UIControlEventTouchUpInside];
    [Coding Add_View:contentView view:btnSendValidation x:self.screen_indent_x height:btnSendValidation.frame.size.height prev_frame:lblPhone.frame gap:(self.gap * 5)];

    [self Add_View:self.screen_width height:[self Get_Scroll_Height:btnSendValidation.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

-(void)Load_Data
{
    NSString *phone;
    
    phone = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"(", [self.merchant_controller.contact_obj.phone substringWithRange:NSMakeRange (0, 3)], @") ",
             [self.merchant_controller.contact_obj.phone substringWithRange:NSMakeRange (3, 3)], @"-",
             [self.merchant_controller.contact_obj.phone substringWithRange:NSMakeRange (6, self.merchant_controller.contact_obj.phone.length - 6)]];
    
    NSString *labelText = [NSString stringWithFormat:@"%@%@", @"Enter the code sent to ", phone];
    [lblPhone setText:labelText];
}

- (void)btnSendValidation_Click:(id)sender
{
    btnSendValidation.enabled = NO;
    [self Progress_Show:@"Sending Validation Code"];
    
    self.deal_controller.merchant_contact_obj = self.merchant_controller.merchant_contact_obj;
    [self.deal_controller Send_Deal_Validation:^(void)
     {
         successful = self.deal_controller.successful;
         system_successful_obj = self.deal_controller.system_successful_obj;
         system_error_obj = self.deal_controller.system_error_obj;
         
         [self Progress_Close];
         btnSendValidation.enabled = YES;
         if(successful)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:system_successful_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void) Validate_Code
{
    if(txtValidationCode.text.length > [@3 longLongValue])
    {
        [self.view endEditing:YES];
        
        [self Progress_Show:@"Validating"];
        
        Deal_Validation *deal_validation_obj = [[Deal_Validation alloc]init];
        deal_validation_obj.validation_code = txtValidationCode.text;
        
        self.deal_controller.merchant_contact_obj = self.merchant_controller.merchant_contact_obj;
        self.deal_controller.deal_validation_obj = deal_validation_obj;
        [self.deal_controller Validate_Deal:^(void)
         {
             successful = self.deal_controller.successful;
             system_successful_obj = self.deal_controller.system_successful_obj;
             system_error_obj = self.deal_controller.system_error_obj;
             
             [self Progress_Close];
             
             if(successful)
             {
                 GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Validation" message:system_successful_obj.message cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 
                 alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
                 {
                     if (cancelled)
                     {
                         [self.view endEditing:YES];
                         
                         [self.tabBarController setSelectedIndex:0];
                         [self.navigationController popToRootViewControllerAnimated:TRUE];
                     }
                 };
                 
                 [alert show];
             }
             else
             {
                 [txtValidationCode setText:@""];
                 
                 [self Show_Error];
             }
         }];
    }
}

-(void) Cancel_Click
{
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

@end
