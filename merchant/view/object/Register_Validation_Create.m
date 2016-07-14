#import "Register_Validation_Create.h"


@interface Register_Validation_Create ()
{
    GTTextField *txtFirstName;
    GTTextField *txtLastName;
    GTTextField *txtEmail;
    GTTextField *txtPhone;
    
    Register_Validate *vc_register_validate;
}
@end


@implementation Register_Validation_Create

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"CREATE";
    self.left_button = @"cancel";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
    
    if([self debug])
        [self Debug];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self Set_Data];
    
    /* not sure why need this code, but will lock up nav bar if not here */
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
    self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = YES;
    self.navigationController.navigationBar.topItem.backBarButtonItem.enabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* public methods */
-(void)Create_Layout
{
    txtFirstName = [Coding Create_Text_Field:@"First Name" format_type:@"name" characters:@100 width:self.screen_indent_width_half height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtFirstName x:self.screen_indent_x height:txtFirstName.frame.size.height prev_frame:CGRectNull gap:(self.gap * 7)];
    
    txtLastName = [Coding Create_Text_Field:@"Last Name" format_type:@"name" characters:@100 width:self.screen_indent_width_half height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtLastName x:self.screen_indent_x_right height:txtLastName.frame.size.height prev_frame:CGRectNull gap:(self.gap * 7)];
    
    txtEmail = [Coding Create_Text_Field:@"Email" format_type:@"email" characters:@200 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtEmail x:self.screen_indent_x height:txtEmail.frame.size.height prev_frame:txtLastName.frame gap:(self.gap)];
    
    txtPhone = [Coding Create_Text_Field:@"Phone" format_type:@"phone" characters:@200 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtPhone x:self.screen_indent_x height:txtPhone.frame.size.height prev_frame:txtEmail.frame gap:(self.gap)];
    
    GTLabel *lblPhoneNote = [Coding Create_Label:@"Your mobile phone number will never be used, it is only for validation into the software." width:self.screen_indent_width font:label_font mult:YES];
    [Coding Add_View:contentView view:lblPhoneNote x:self.screen_indent_x height:[Utilities Get_Height:lblPhoneNote] prev_frame:txtPhone.frame gap:(self.gap * 2)];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:lblPhoneNote.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

-(void)Set_Data
{
    if(self.merchant_controller.contact_obj.contact_id != nil)
    {
        txtFirstName.text = [NSString stringWithFormat:@"%@ %@", self.merchant_controller.contact_obj.first_name, self.merchant_controller.contact_obj.last_name];
        txtFirstName.enabled = NO;
        [txtFirstName setBackgroundColor:[UIColor clearColor]];
        
        [txtLastName setHidden:YES];
        txtLastName.text = self.merchant_controller.contact_obj.last_name;
        
        txtEmail.text = self.merchant_controller.contact_obj.email;
        txtEmail.enabled = NO;
        [txtEmail setBackgroundColor:[UIColor clearColor]];
    }
}

-(void)Next_Click
{
    NSString *first_name = [txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *last_name = [txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phone = [[txtPhone.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    
    if(first_name.length == [@0 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need First Name" message:@"You must enter your first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtFirstName becomeFirstResponder];
    }
    else if(last_name.length == [@0 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Last Name" message:@"You must enter your last name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtLastName becomeFirstResponder];
    }
    else if(![Utilities IsValidEmail:email])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Email" message:@"You must a valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtEmail becomeFirstResponder];
    }
    else if(phone.length != [@10 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Phone" message:@"You must enter a valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtPhone becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
        
        [self Progress_Show:@"Sending Validation Code"];
        
        if(self.merchant_controller.contact_obj.contact_id == nil)
        {
            Contact *contact_obj = [[Contact alloc] init];
            contact_obj.contact_id = 0;
            contact_obj.first_name = first_name;
            contact_obj.last_name = last_name;
            contact_obj.email = email;
            contact_obj.phone = phone;
            
            self.merchant_controller.contact_obj = contact_obj;
        }
        else
        {
            self.merchant_controller.contact_obj.phone = phone;
        }
        
//        if([self debug])
//        {
//            [self Progress_Close];
//            
//            if(vc_register_validate == nil)
//            {
//                vc_register_validate = [[Register_Validate alloc]init];
//            }
//            vc_register_validate.merchant_controller = self.merchant_controller;
//            vc_register_validate.system_controller = self.system_controller;
//            
//            [self.navigationController pushViewController:vc_register_validate animated:YES];
//        }
//        else
//        {
            [self.merchant_controller Create_Validation:^(void)
             {
                 successful = self.merchant_controller.successful;
                 system_successful_obj = self.merchant_controller.system_successful_obj;
                 system_error_obj = self.merchant_controller.system_error_obj;
                 
                 [self Progress_Close];
                 
                 if(successful)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:system_successful_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                     
                     if(vc_register_validate == nil)
                     {
                         vc_register_validate = [[Register_Validate alloc]init];
                     }
                     vc_register_validate.merchant_controller = self.merchant_controller;
                     vc_register_validate.system_controller = self.system_controller;

                     [self.navigationController pushViewController:vc_register_validate animated:YES];
                 }
                 else
                 {
                     GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Validation" message:system_error_obj.message cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     
                     alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
                     {
                         if (cancelled)
                         {
                             if([system_error_obj.code isEqualToNumber:[NSNumber numberWithInt:1005]])
                                 [self.navigationController popViewControllerAnimated:TRUE];
                         }
                     };
                     
                     [alert show];
                 }
             }];
//        }
    }
}

-(void)Cancel_Click
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

-(void) Debug
{
    txtPhone.text = @"8586990966";
    txtFirstName.text = @"George";
    txtLastName.text = @"Triarhos";
    txtEmail.text = @"gtriarhos@gmail.com";
}

@end
