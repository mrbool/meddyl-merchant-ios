#import "Register_Merchant_Contact.h"


@interface Register_Merchant_Contact ()
{
    UILabel *lblName;
    UILabel *lblPhone;
    GTTextField *txtEmail;
    GTTextField *txtPassword;
    GTTextField *txtPasswordConfirm;
    
    Register_Merchant *vc_register_merchant;
}
@end


@implementation Register_Merchant_Contact

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"CONTACT";
    self.left_button = @"cancel";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self Load_Data];
    
    if([self debug])
        [self Debug];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /* not sure why need this code, but will lock up nav bar if not here */
    self.navigationController.navigationBar.topItem.leftBarButtonItem.enabled = YES;
    self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = YES;
    self.navigationController.navigationBar.topItem.backBarButtonItem.enabled = YES;
    
    [txtPassword becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url

{
    Terms_Of_Service *vc_terms_of_service = [[Terms_Of_Service alloc]init];
    vc_terms_of_service.system_controller = self.system_controller;
    vc_terms_of_service.merchant_controller = self.merchant_controller;
    vc_terms_of_service.deal_controller = self.deal_controller;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:vc_terms_of_service animated:YES];
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didLongPressLinkWithURL:(__unused NSURL *)url atPoint:(__unused CGPoint)point {
    [[[UIAlertView alloc] initWithTitle:@"URL Long Pressed"
                                message:@"You long-pressed a URL. Well done!"
                               delegate:nil
                      cancelButtonTitle:@"Woohoo!"
                      otherButtonTitles:nil] show];
}


/* public methods */
-(void)Create_Layout
{
    lblName = [Coding Create_Label:@"" width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblName x:self.screen_indent_x height:[Utilities Get_Height:lblName] prev_frame:CGRectNull gap:(self.gap * 7)];
    
    lblPhone = [Coding Create_Label:@"" width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblPhone x:self.screen_indent_x height:[Utilities Get_Height:lblPhone] prev_frame:lblName.frame gap:self.gap];

    txtEmail = [Coding Create_Text_Field:@"Email" format_type:@"email" characters:@200 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    txtEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [Coding Add_View:contentView view:txtEmail x:self.screen_indent_x height:txtEmail.frame.size.height prev_frame:lblPhone.frame gap:(self.gap * 3)];
    
    txtPassword = [Coding Create_Text_Field:@"Password" format_type:@"password" characters:@50 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    txtPassword.secure_entry = YES;
    [Coding Add_View:contentView view:txtPassword x:self.screen_indent_x height:txtPassword.frame.size.height prev_frame:txtEmail.frame gap:(self.gap)];
    
    txtPasswordConfirm = [Coding Create_Text_Field:@"Password Confirm" format_type:@"password" characters:@50 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    txtPasswordConfirm.secure_entry = YES;
    [Coding Add_View:contentView view:txtPasswordConfirm x:self.screen_indent_x height:txtPasswordConfirm.frame.size.height prev_frame:txtPassword.frame gap:(self.gap)];
    
    /* terms of service */
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink; // Automatically detect links when the label text is subsequently changed
    label.delegate = self; // Delegate methods are called when the user taps on a link (see `TTTAttributedLabelDelegate` protocol)
    label.text = @"By clicking next, I agree to Meddyl's Terms of Service"; // Repository URL will be automatically detected and linked
    NSRange range = [label.text rangeOfString:@"Terms of Service"];
    [label addLinkToURL:[NSURL URLWithString:@"http://github.com/mattt/"] withRange:range]; // Embedding a custom link in a substring
    [Coding Add_View:contentView view:label x:self.screen_indent_x height:label.frame.size.height prev_frame:txtPasswordConfirm.frame gap:(self.gap * 1)];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:txtPasswordConfirm.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

-(void)Load_Data
{
    // set name
    NSString *name = [NSString stringWithFormat:@"%@%@%@", self.merchant_controller.contact_obj.first_name, @" ", self.merchant_controller.contact_obj.last_name];
    [lblName setText:name];
    
    // set phone
    NSString *phone = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"(", [self.merchant_controller.contact_obj.phone substringWithRange:NSMakeRange (0, 3)], @") ",
                       [self.merchant_controller.contact_obj.phone substringWithRange:NSMakeRange (3, 3)], @"-",
                       [self.merchant_controller.contact_obj.phone substringWithRange:NSMakeRange (6, self.merchant_controller.contact_obj.phone.length - 6)]];
    [lblPhone setText:phone];
    
    // set email
    [txtEmail setText:self.merchant_controller.contact_obj.email];
}

- (void)Next_Click
{
    NSString *email = [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password_confirm = [txtPasswordConfirm.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(![Utilities IsValidEmail:email])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Email" message:@"You must a valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtEmail becomeFirstResponder];
    }
    else if(password.length < [@5 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Incorrect" message:@"Your password must be at least 5 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtPassword becomeFirstResponder];
    }
    
    else if(![password isEqualToString:password_confirm])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Incorrect" message:@"Your passwords do not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtPasswordConfirm becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
        
        self.merchant_controller.contact_obj.email = email;
        self.merchant_controller.contact_obj.password = password;
        
        if(vc_register_merchant == nil)
        {
            vc_register_merchant = [[Register_Merchant alloc]init];
        }
        vc_register_merchant.deal_controller = self.deal_controller;
        vc_register_merchant.merchant_controller = self.merchant_controller;
        vc_register_merchant.system_controller = self.system_controller;
        
        [self.navigationController pushViewController:vc_register_merchant animated:YES];
    }
}

-(void) Cancel_Click
{
    GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Cancel" message:@"Are you sure you want to cancel?  Your info will be lost." cancelButtonTitle:@"No" otherButtonTitles:@[@"Yes"]];
    alert.completion = ^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled)
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.navigationController popToRootViewControllerAnimated:TRUE];
        }
    };
    
    [alert show];
}

-(void) Debug
{
    txtEmail.text = @"gtriarhos@gmail.com";
    txtPassword.text = @"test12";
    txtPasswordConfirm.text = @"test12";
}

@end
