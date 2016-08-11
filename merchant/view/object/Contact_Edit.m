#import "Contact_Edit.h"


@interface Contact_Edit ()
{
    GTTextField* txtFirstName;
    GTTextField* txtLastName;
    GTLabel* lblPhone;
    GTTextField* txtEmail;
    GTTextField* txtTitle;
}
@end


@implementation Contact_Edit

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screen_title = @"EDIT";
    self.left_button = @"back";
    self.right_button = @"save";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self Load_Data];
    
    if(self.debug)
        [self Debug];
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
    txtFirstName = [Coding Create_Text_Field:@"First Name" format_type:@"name" characters:@100 width:self.screen_indent_width_half height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtFirstName x:self.screen_indent_x height:txtFirstName.frame.size.height prev_frame:CGRectNull gap:(self.gap * 5)];
    
    txtLastName = [Coding Create_Text_Field:@"Last Name" format_type:@"name" characters:@100 width:self.screen_indent_width_half height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtLastName x:self.screen_indent_x_right height:txtLastName.frame.size.height prev_frame:CGRectNull gap:(self.gap * 5)];
    
    lblPhone = [Coding Create_Label:@"" width:self.screen_indent_width font:label_font mult:NO];
    [Coding Add_View:contentView view:lblPhone x:self.screen_indent_x height:lblPhone.frame.size.height prev_frame:txtFirstName.frame gap:self.gap];
    
    txtEmail = [Coding Create_Text_Field:@"Email" format_type:@"email" characters:@200 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    txtEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [Coding Add_View:contentView view:txtEmail x:self.screen_indent_x height:txtEmail.frame.size.height prev_frame:lblPhone.frame gap:(self.gap * 5)];
    
    txtTitle = [Coding Create_Text_Field:@"Title" format_type:@"" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtTitle x:self.screen_indent_x height:txtTitle.frame.size.height prev_frame:txtEmail.frame gap:self.gap];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:txtTitle.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

-(void)Load_Data
{
    [self Progress_Show:@"Loading"];
    
    [self.merchant_controller Get_Merchant_Contact:^(void)
     {
         successful = self.merchant_controller.successful;
         system_successful_obj = self.merchant_controller.system_successful_obj;
         system_error_obj = self.merchant_controller.system_error_obj;
         
         [self Progress_Close];
         
         if(successful)
         {
             NSString *phone = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"(", [self.merchant_controller.contact_obj.phone substringWithRange:NSMakeRange (0, 3)], @") ",
                                [self.merchant_controller.contact_obj.phone substringWithRange:NSMakeRange (3, 3)], @"-",
                                [self.merchant_controller.contact_obj.phone substringWithRange:NSMakeRange (6, self.merchant_controller.contact_obj.phone.length - 6)]];
             
             txtFirstName.text = self.merchant_controller.merchant_contact_obj.contact_obj.first_name;
             txtLastName.text = self.merchant_controller.merchant_contact_obj.contact_obj.last_name;
             lblPhone.text = phone;
             txtEmail.text = self.merchant_controller.merchant_contact_obj.contact_obj.email;
             txtTitle.text = self.merchant_controller.merchant_contact_obj.title;
         }
         else
         {
             [self Show_Error];
         }
     }];
}

-(void)Save_Click
{
    NSString *first_name = [txtFirstName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *last_name = [txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *email = [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *title = [txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(first_name.length == [@0 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Name" message:@"You must enter your first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtFirstName becomeFirstResponder];
    }
    else if(last_name.length == [@0 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Last Name" message:@"You must enter your last name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtLastName becomeFirstResponder];
    }
    else if(![Utilities IsValidEmail:email])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"You must a valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtEmail becomeFirstResponder];
    }
    else if(title.length == [@0 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"You must enter a job title" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtTitle becomeFirstResponder];
    }
    else
    {
        [self Progress_Show:@"Updating"];

        /* if fails, reset to this */
        Merchant_Contact* merchant_contact_obj_update = [[Merchant_Contact alloc]init];
        merchant_contact_obj_update = self.merchant_controller.merchant_contact_obj;
        merchant_contact_obj_update.contact_obj = self.merchant_controller.contact_obj;
        
        Contact *contact_obj = [[Contact alloc] init];
        contact_obj.first_name = first_name;
        contact_obj.last_name = last_name;
        contact_obj.email = email;
        contact_obj.phone = self.merchant_controller.contact_obj.phone;
        
        self.merchant_controller.merchant_contact_obj.title = title;
        self.merchant_controller.contact_obj = contact_obj;
        [self.merchant_controller Update_Merchant_Contact:^(void)
         {
             [self.view endEditing:YES];
             
             successful = self.merchant_controller.successful;
             system_successful_obj = self.merchant_controller.system_successful_obj;
             system_error_obj = self.merchant_controller.system_error_obj;
             
             [self Progress_Close];
             
             if(successful)
             {
                 GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Successful" message:system_successful_obj.message cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 
                 alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
                 {
                     if (cancelled)
                     {
                         [self.navigationController popViewControllerAnimated:TRUE];
                     }
                 };
                 
                 [alert show];
             }
             else
             {
                 self.merchant_controller.merchant_contact_obj = merchant_contact_obj_update;
                 self.merchant_controller.contact_obj = merchant_contact_obj_update.contact_obj;
                 
                 [self Show_Error];
             }
         }];
    }
}

-(void)Back_Click
{
    if(![self.merchant_controller.merchant_contact_obj.contact_obj.first_name isEqualToString:txtFirstName.text])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_contact_obj.contact_obj.last_name isEqualToString:txtLastName.text])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_contact_obj.contact_obj.email isEqualToString:txtEmail.text])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_contact_obj.title isEqualToString:txtTitle.text])
    {
        self.edited = YES;
    }
    else
    {
        self.edited = NO;
    }
    
    if(self.edited)
    {
        GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Cancel" message:@"You have unsaved changes, are you sure you want to cancel?" cancelButtonTitle:@"No" otherButtonTitles:@[@"Yes"]];
        alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
        {
            if (!cancelled)
            {
                [self.view endEditing:YES];
                [self.navigationController popViewControllerAnimated:TRUE];
            }
        };
        
        [alert show];
    }
    else
    {
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

-(void)Debug
{

}

@end
