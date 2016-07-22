#import "Register_Merchant.h"


@interface Register_Merchant ()
{
    GTTextField *txtCompanyName;
    GTTextField *txtCompanyPhone;
    GTTextField *txtTitle;
    GTTextField *txtWebsite;
    GTPickerView_TextField *pkvIndustry;
    
    System_Settings *vc_system_settings_obj;
    Register_Location *vc_register_location;
}
@end


@implementation Register_Merchant

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.screen_title = @"MERCHANT";
    self.left_button = @"back";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
 
    [self Load_Industries];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* public methods */
-(void)Create_Layout
{
    txtCompanyName = [Coding Create_Text_Field:@"Company Name" format_type:@"name" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtCompanyName x:self.screen_indent_x height:txtCompanyName.frame.size.height prev_frame:CGRectNull gap:(self.gap * 7)];
    
    txtCompanyPhone = [Coding Create_Text_Field:@"Company Phone" format_type:@"phone" characters:nil width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtCompanyPhone x:self.screen_indent_x height:txtCompanyPhone.frame.size.height prev_frame:txtCompanyName.frame gap:(self.gap)];
    
    txtWebsite = [Coding Create_Text_Field:@"Website" format_type:@"website" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    txtWebsite.keyboardType = UIKeyboardTypeURL;
    txtWebsite.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [Coding Add_View:contentView view:txtWebsite x:self.screen_indent_x height:txtWebsite.frame.size.height prev_frame:txtCompanyPhone.frame gap:(self.gap)];
    
    pkvIndustry = [Coding Create_Picker:@"Industry" format_type:@"" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:pkvIndustry x:self.screen_indent_x height:pkvIndustry.frame.size.height prev_frame:txtWebsite.frame gap:(self.gap)];

    txtTitle = [Coding Create_Text_Field:@"Your Title (ie. Owner, Manager, Marketer)" format_type:@"name" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtTitle x:self.screen_indent_x height:txtTitle.frame.size.height prev_frame:pkvIndustry.frame gap:(self.gap)];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:txtTitle.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

-(void)Load_Industries
{
    /* load industry pick list */
    Industry *industry_obj = [[Industry alloc]init];
    industry_obj.parent_industry_id = @2;
    
    [self Progress_Show:@"Loading"];
    
    self.system_controller.industry_obj_array = nil;
    self.system_controller.industry_obj = industry_obj;
    [self.system_controller Get_Industry_Parent_Level:^(void)
     {
         successful = self.system_controller.successful;
         system_successful_obj = self.system_controller.system_successful_obj;
         system_error_obj = self.system_controller.system_error_obj;
         
         NSMutableArray *industry_obj_array = self.system_controller.industry_obj_array;
         
         pkvIndustry.column_id = @"industry_id";
         pkvIndustry.column_text = @"industry";
         pkvIndustry.input_array = industry_obj_array;
         
         [self Progress_Close];
         
         if(!successful)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

- (void)Next_Click
{
    NSString *company_name = [txtCompanyName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *company_phone = [[txtCompanyPhone.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    NSString *website = [txtWebsite.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *title = [txtTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSNumber *industry_id = pkvIndustry.selected_id;
    
    if(company_name.length < [@1 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Company Name" message:@"Company name cannot be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtCompanyName becomeFirstResponder];
    }
    else if(company_phone.length != [@10 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Incorrect" message:@"You must enter a valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtCompanyPhone becomeFirstResponder];
    }
    else if(industry_id == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Industry" message:@"Please select and industry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [pkvIndustry becomeFirstResponder];
    }
    else if(title.length < [@1 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Title" message:@"Please enter a title" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtTitle becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
        
        Industry *industry_obj = [[Industry alloc] init];
        industry_obj.industry_id = industry_id;
        
        Merchant *merchant_obj = [[Merchant alloc]init];
        merchant_obj.company_name = company_name;
        merchant_obj.phone = company_phone;
        merchant_obj.website = website;
        merchant_obj.industry_obj = industry_obj;
        
        self.merchant_controller.merchant_contact_obj.title = title;
        self.merchant_controller.merchant_obj = merchant_obj;
        
        if(vc_register_location == nil)
        {
            vc_register_location = [[Register_Location alloc]init];
        }     
        vc_register_location.deal_controller = self.deal_controller;
        vc_register_location.merchant_controller = self.merchant_controller;
        vc_register_location.system_controller = self.system_controller;
        
        [self.navigationController pushViewController:vc_register_location animated:YES];
    }
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void) Debug
{
    txtCompanyName.text = @"George's Donuts";
    txtCompanyPhone.text = @"(858) 699-0966";
    txtTitle.text = @"manager";
    txtWebsite.text = @"wwww.meddyl.com";
}

@end
