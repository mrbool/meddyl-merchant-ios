#import "Login.h"
#import "Forgot_Password.h"
#import "Register_Validation_Create.h"


@interface Login ()
{
    GTTextField *txtEmail;
    GTTextField *txtPassword;
    ACPButton *btnLogIn;
    UIButton *btnForgotPassword;
}

@end


@implementation Login

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"LOGIN";
    self.left_button = @"back";
    self.right_button = @"";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *forgot_password_email = [defaults objectForKey:@"forgot_password_email"];
    [txtEmail setText:forgot_password_email];
    [Utilities Clear_NSDefaults];
    
    if([self debug])
        [self Debug];
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

-(void)Create_Layout
{
    txtEmail = [Coding Create_Text_Field:@"Email" format_type:@"email" characters:@200 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    txtEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [Coding Add_View:contentView view:txtEmail x:self.screen_indent_x height:txtEmail.frame.size.height prev_frame:CGRectNull gap:(self.gap * 10)];
    
    txtPassword = [Coding Create_Text_Field:@"Password" format_type:@"password" characters:@200 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    txtPassword.secure_entry = YES;
    [Coding Add_View:contentView view:txtPassword x:self.screen_indent_x height:txtPassword.frame.size.height prev_frame:txtEmail.frame gap:self.gap];

    btnLogIn = [Coding Create_Button:@"Log In" font:button_font style:ACPButtonDarkGrey text_color:[UIColor whiteColor] width:self.screen_indent_width height:self.button_height];
    [btnLogIn addTarget:self action:@selector(btnLogIn_Click:) forControlEvents:UIControlEventTouchUpInside];
    [Coding Add_View:contentView view:btnLogIn x:self.screen_indent_x height:btnLogIn.frame.size.height prev_frame:txtPassword.frame gap:(self.gap * 2)];

    btnForgotPassword = [Coding Create_Link_Button:@"I forgot my password" font:link_button_font];
    [btnForgotPassword addTarget:self action:@selector(btnForgotPassword_Click:) forControlEvents:UIControlEventTouchUpInside];
    [Coding Add_View:contentView view:btnForgotPassword x:self.screen_indent_x height:btnForgotPassword.frame.size.height prev_frame:btnLogIn.frame gap:(self.gap * 3)];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:btnForgotPassword.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

- (void)btnLogIn_Click:(id)sender
{
    NSString *user_name = [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([user_name isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Email" message:@"Please enter an email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([password isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Password" message:@"Please enter a password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self.view endEditing:YES];
        
        Contact *contact_obj = [[Contact alloc]init];
        contact_obj.user_name = user_name;
        contact_obj.password = password;
        
        self.merchant_controller.login_log_obj.auto_login = [NSNumber numberWithBool:NO];
        self.merchant_controller.contact_obj = contact_obj;
        
        btnLogIn.enabled = NO;
        btnForgotPassword.enabled = NO;
        [self Progress_Show:@"Logging In"];
        
        [self.merchant_controller Login:^(void)
         {
             successful = self.merchant_controller.successful;
             system_successful_obj = self.merchant_controller.system_successful_obj;
             system_error_obj = self.merchant_controller.system_error_obj;
             
             [self Progress_Close];
             btnLogIn.enabled = YES;
             btnForgotPassword.enabled = YES;
             
             if(successful)
             {
                 if(self.merchant_controller.merchant_contact_obj.merchant_contact_id != nil)
                 {
                     [SSKeychain setPassword:user_name forService:@"user_name" account:@"app"];
                     [SSKeychain setPassword:password forService:@"password" account:@"app"];

                     self.deal_controller.login_log_obj.merchant_contact_id = self.merchant_controller.merchant_contact_obj.merchant_contact_id;
                     self.merchant_controller.login_log_obj.merchant_contact_id = self.merchant_controller.merchant_contact_obj.merchant_contact_id;
                     self.system_controller.login_log_obj.merchant_contact_id = self.merchant_controller.merchant_contact_obj.merchant_contact_id;
                     
                     TabBar_Controller *tc = [[TabBar_Controller alloc] init];
                     tc.deal_controller = self.deal_controller;
                     tc.merchant_controller = self.merchant_controller;
                     tc.system_controller = self.system_controller;
                     [tc Set_Properties];
                     [self presentViewController:tc animated:YES completion:nil];
                 }
                 else
                 {
                     self.merchant_controller.contact_obj = self.merchant_controller.merchant_contact_obj.contact_obj;
                     
                     
                     Register_Validation_Create *vc_register_validation_create = [[Register_Validation_Create alloc]init];
                     vc_register_validation_create.merchant_controller = self.merchant_controller;
                     vc_register_validation_create.system_controller = self.system_controller;

                     [self.navigationController pushViewController:vc_register_validation_create animated:YES];
                 }
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
}

- (void)btnForgotPassword_Click:(id)sender
{
    Forgot_Password *vc_forgot_password = [[Forgot_Password alloc]init];
    vc_forgot_password.merchant_controller = self.merchant_controller;
    
    [self.navigationController pushViewController:vc_forgot_password animated:YES];
}

-(void)Back_Click
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void) Debug
{
    txtEmail.text = @"gtriarhos@gmail.com";
    //txtEmail.text = @"george.triarhos@lexisnexis.com";
    txtPassword.text = @"test12";
}

@end
