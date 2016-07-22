#import "Register_Validate.h"


@interface Register_Validate ()
{
    GTTextField *txtValidationCode;
    ACPButton *btnSendValidation;
    GTLabel *lblPhone;
    Register_Merchant_Contact *vc_register_merchant_contact;
    Register_Merchant *vc_register_merchant;
}
@end


@implementation Register_Validate

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"VALIDATE";
    self.left_button = @"cancel";
    self.right_button = @"";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self Set_Data];
    
    txtValidationCode.text = @"";
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
-(void) Create_Layout
{
    [[contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat certificate_text_width = (self.screen_indent_width * .75);
    CGFloat certificate_text_x = ((self.screen_width * .5) - (certificate_text_width * .5));
    txtValidationCode = [Coding Create_Text_Field:@"" format_type:@"number" characters:@4 width:certificate_text_width height:(self.screen_height/10) font:text_field_font_large];
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

-(void)Set_Data
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
    
    [self.merchant_controller Create_Validation:^(void)
     {
         successful = self.merchant_controller.successful;
         system_successful_obj = self.merchant_controller.system_successful_obj;
         system_error_obj = self.merchant_controller.system_error_obj;
         
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
        
        Merchant_Contact_Validation *merchant_contact_validation_obj = [[Merchant_Contact_Validation alloc]init];
        merchant_contact_validation_obj.validation_code = txtValidationCode.text;
        
//        if([self debug])
//        {
//            [self Progress_Close];
//
//            self.merchant_controller.merchant_contact_obj = [[Merchant_Contact alloc]init];
//            
//            merchant_contact_validation_obj.validation_id = @9;
//        
//            self.merchant_controller.merchant_contact_validation_obj = merchant_contact_validation_obj;
//
//            if(vc_register_merchant_contact == nil)
//            {
//                vc_register_merchant_contact = [[Register_Merchant_Contact alloc]init];
//            }
//            vc_register_merchant_contact.merchant_controller = self.merchant_controller;
//            vc_register_merchant_contact.system_controller = self.system_controller;
//            
//            [self.navigationController pushViewController:vc_register_merchant_contact animated:YES];
//        }
//        else
//        {
            self.merchant_controller.merchant_contact_validation_obj = merchant_contact_validation_obj;
            [self.merchant_controller Validate:^(void)
             {
                 successful = self.merchant_controller.successful;
                 system_successful_obj = self.merchant_controller.system_successful_obj;
                 system_error_obj = self.merchant_controller.system_error_obj;
                 
                 [self Progress_Close];
                 
                 if(successful)
                 {
                     if(self.merchant_controller.contact_obj.contact_id == nil)
                     {
                         if(vc_register_merchant_contact == nil)
                         {
                             vc_register_merchant_contact = [[Register_Merchant_Contact alloc]init];
                         }
                         vc_register_merchant_contact.merchant_controller = self.merchant_controller;
                         vc_register_merchant_contact.system_controller = self.system_controller;
                         
                         [self.navigationController pushViewController:vc_register_merchant_contact animated:YES];
                     }
                     else
                     {
                         if(vc_register_merchant == nil)
                         {
                             vc_register_merchant = [[Register_Merchant alloc]init];
                         }
                         vc_register_merchant.merchant_controller = self.merchant_controller;
                         vc_register_merchant.system_controller = self.system_controller;
                         [self.navigationController pushViewController:vc_register_merchant animated:YES];
                     }
                 }
                 else
                 {
                     [txtValidationCode setText:@""];
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
             }];
//        }
    }
}

-(void) Cancel_Click
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

@end
