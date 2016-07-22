#import "Register_Description.h"


@interface Register_Description ()
{
    GTTextView *txvDescription;
    GTLabel *lblCharacterCount;
    
    Register_Logo *vc_register_logo;
}
@end


@implementation Register_Description

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screen_title = @"DESCRIPTION";
    self.left_button = @"back";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(!self.loaded)
    {
        txvDescription.placeholder = self.system_controller.system_settings_obj.merchant_description_default;
        [lblCharacterCount setText:[NSString stringWithFormat:@"%ld%@",(long)[self.system_controller.system_settings_obj.merchant_description_characters integerValue], @" characters left"]];
    }
    
    self.loaded = YES;
    
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

-(void)textViewDidChange:(UITextView *)textView
{
    lblCharacterCount.text=[NSString stringWithFormat:@"%u%@",[self.system_controller.system_settings_obj.merchant_description_characters integerValue]-textView.text.length, @" characters left"];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > [self.system_controller.system_settings_obj.fine_print_more_characters integerValue])
    {
        return NO;
    }
    return YES;
}


/* public methods */
-(void)Create_Layout
{
    GTLabel *lblDescription = [Coding Create_Label:@"Tell us about your company" width:self.screen_indent_width font:label_font mult:YES];
    [Coding Add_View:contentView view:lblDescription x:self.screen_indent_x height:lblDescription.frame.size.height prev_frame:CGRectNull gap:(self.gap * 10)];
    
    txvDescription = [Coding Create_Text_View:@"" characters:nil width:self.screen_indent_width height:(self.screen_height/4.75) font:text_field_font];
    txvDescription.delegate = self;
    [Coding Add_View:contentView view:txvDescription x:self.screen_indent_x height:txvDescription.frame.size.height prev_frame:lblDescription.frame gap:12];
    
    lblCharacterCount = [Coding Create_Label:[NSString stringWithFormat:@"%ld%@",(long)[self.system_controller.system_settings_obj.merchant_description_characters integerValue], @" characters left"] width:self.screen_indent_width font:[UIFont fontWithName:@"AvenirNext-Medium" size:18] mult:YES];
    [lblCharacterCount setTextAlignment:NSTextAlignmentRight];
    [Coding Add_View:contentView view:lblCharacterCount x:self.screen_indent_x height:lblCharacterCount.frame.size.height prev_frame:txvDescription.frame gap:10];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:lblCharacterCount.frame scroll_lag:0] background_color:[UIColor clearColor]];
}


-(void)Call_Next_Screen
{
    if(vc_register_logo == nil)
    {
        vc_register_logo = [[Register_Logo alloc]init];
    }
    vc_register_logo.deal_controller = self.deal_controller;
    vc_register_logo.merchant_controller = self.merchant_controller;
    vc_register_logo.system_controller = self.system_controller;
    
    [self.navigationController pushViewController:vc_register_logo animated:YES];
}

- (void)Next_Click
{
    NSString *description = [txvDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(description.length < [@1 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Description" message:@"Please add a company description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txvDescription becomeFirstResponder];
    }
    else
    {
        [self.view endEditing:YES];
        
        self.merchant_controller.merchant_obj.description = description;
        
        [self Call_Next_Screen];
    }
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)Debug
{
    
}

@end
