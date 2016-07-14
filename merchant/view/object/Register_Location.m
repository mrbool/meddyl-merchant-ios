#import "Register_Location.h"


@interface Register_Location ()
{
    GTTextField *txtAddress1;
    GTTextField *txtAddress2;
    GTTextField *txtZipCode;
    GTPickerView_TextField *pkvNeighborhood;
    
    Register_Description *vc_register_description;
}
@end


@implementation Register_Location

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"LOCATION";
    self.left_button = @"back";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];

    if([self debug])
        [self Debug];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
    txtAddress1 = [Coding Create_Text_Field:@"Address 1" format_type:@"name" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtAddress1 x:self.screen_indent_x height:txtAddress1.frame.size.height prev_frame:CGRectNull gap:(self.gap * 7)];
    
    txtAddress2 = [Coding Create_Text_Field:@"Address 2" format_type:@"name" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtAddress2 x:self.screen_indent_x height:txtAddress2.frame.size.height prev_frame:txtAddress1.frame gap:(self.gap)];
    
    txtZipCode = [Coding Create_Text_Field:@"Zip Code" format_type:@"zipcode" characters:nil width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [txtZipCode addTarget:self action:@selector(Get_Neighborhoods) forControlEvents:UIControlEventEditingChanged];
    [Coding Add_View:contentView view:txtZipCode x:self.screen_indent_x height:txtZipCode.frame.size.height prev_frame:txtAddress2.frame gap:(self.gap)];
    
    pkvNeighborhood = [Coding Create_Picker:@"Neighborhood" format_type:@"" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:pkvNeighborhood x:self.screen_indent_x height:pkvNeighborhood.frame.size.height prev_frame:txtZipCode.frame gap:(self.gap)];
    [pkvNeighborhood setHidden:YES];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:pkvNeighborhood.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

- (void) Get_Neighborhoods
{
    if(txtZipCode.text.length > [@4 longLongValue])
    {
        [self Progress_Show:@"Validating"];
        
        Zip_Code *zip_code_obj = [[Zip_Code alloc]init];
        zip_code_obj.zip_code = txtZipCode.text;
        
        self.system_controller.zip_code_obj = zip_code_obj;
        [self.system_controller Get_Neighborhood_By_Zip:^(void)
         {
             successful = self.system_controller.successful;
             system_successful_obj = self.system_controller.system_successful_obj;
             system_error_obj = self.system_controller.system_error_obj;
             
             [self Progress_Close];
             
             if(successful)
             {
                 self.merchant_controller.contact_obj.zip_code_obj = self.system_controller.zip_code_obj;
                 NSMutableArray *neighborhood_obj_array = self.system_controller.zip_code_obj.neighborhood_obj_array;
                 
                 if(neighborhood_obj_array.count >= 1)
                 {
                     [pkvNeighborhood setHidden:NO];
                     
                     pkvNeighborhood.column_id = @"neighborhood_id";
                     pkvNeighborhood.column_text = @"neighborhood";
                     pkvNeighborhood.input_array = neighborhood_obj_array;
                 }
                 else
                 {
                     [pkvNeighborhood setHidden:YES];
                 }
             }
             else
             {
                 [txtZipCode setText:@""];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zip Code Incorrect" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
    else
    {
        pkvNeighborhood.selected_id = nil;
        [pkvNeighborhood setText:@""];
        [pkvNeighborhood setHidden:YES];
    }
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)Next_Click
{
    NSString *address_1 = [txtAddress1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *address_2 = [txtAddress2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *zip_code = [txtZipCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSNumber *neighborhood_id = pkvNeighborhood.selected_id;
    NSString* neighborhood = pkvNeighborhood.text;
    
    if(address_1.length < [@1 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Address" message:@"Address cannot be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtAddress1 becomeFirstResponder];
    }
    else if(zip_code.length != [@5 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zip Code Incorrect" message:@"Zip code is incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtZipCode becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
        
        Neighborhood *neighborhood_obj = [[Neighborhood alloc]init];
        neighborhood_obj.neighborhood_id = neighborhood_id;
        neighborhood_obj.neighborhood = neighborhood;
        
        self.merchant_controller.merchant_obj.address_1 = address_1;
        self.merchant_controller.merchant_obj.address_2 = address_2;
        self.merchant_controller.merchant_obj.zip_code_obj = self.merchant_controller.contact_obj.zip_code_obj;
        self.merchant_controller.merchant_obj.neighborhood_obj = neighborhood_obj;
        
        if((pkvNeighborhood.input_array.count >= 1) && (neighborhood_id == nil))
        {
            GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Neighborhood" message:@"Would you like to add a neighborhood?" cancelButtonTitle:@"Yes" otherButtonTitles:@[@"No"]];
            alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
            {
                if (!cancelled)
                {
                    [self Call_Next_Screen];
                }
            };
            
            [alert show];
        }
        else
        {
            [self Call_Next_Screen];
        }

    }
}

-(void)Call_Next_Screen
{
    if(vc_register_description == nil)
    {
        vc_register_description = [[Register_Description alloc]init];
    }
    vc_register_description.deal_controller = self.deal_controller;
    vc_register_description.system_controller = self.system_controller;
    vc_register_description.merchant_controller = self.merchant_controller;
    
    if(![self.navigationController.topViewController isKindOfClass:[Register_Description class]])
    {
        [self.navigationController pushViewController:vc_register_description animated:YES];
    }
}

-(void) Debug
{
    txtAddress1.text = @"2600 Torrey Pines Rd";
    txtAddress2.text = @"B19";
    txtZipCode.text = @"";
}

@end
