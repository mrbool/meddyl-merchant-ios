#import "Certificate_Lookup.h"


@interface Certificate_Lookup ()
{
    GTTextField* txtCertificateCode;
    
    Certificate_Redeem *vc_certificate_redeem;
}
@end


@implementation Certificate_Lookup

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screen_title = @"LOOKUP";
    self.left_button = @"";
    self.right_button = @"";
    
    [self Set_Controller_Properties];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self Create_Layout];
    
    [txtCertificateCode setText:@""];
    
    if(self.debug)
        [self Debug];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[txtCertificateCode becomeFirstResponder];
    
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
    GTLabel *lblCertificateCode = [Coding Create_Label:@"Enter a certificate code below" width:self.screen_indent_width font:label_font_medium mult:NO];
    [lblCertificateCode setTextAlignment:NSTextAlignmentCenter];
    [Coding Add_View:contentView view:lblCertificateCode x:self.screen_indent_x height:lblCertificateCode.frame.size.height prev_frame:CGRectNull gap:(self.gap * 5)];
    
    CGFloat certificate_text_width = (self.screen_indent_width * .75);
    CGFloat certificate_text_x = ((self.screen_width * .5) - (certificate_text_width * .5));
    txtCertificateCode = [Coding Create_Text_Field:@"" format_type:@"" characters:@8 width:certificate_text_width height:(self.screen_height * .1) font:text_field_font_large];
    [txtCertificateCode addTarget:self action:@selector(Check_Code) forControlEvents:UIControlEventEditingChanged];
    [Coding Add_View:contentView view:txtCertificateCode x:certificate_text_x height:txtCertificateCode.frame.size.height prev_frame:lblCertificateCode.frame gap:(self.gap * 5)];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:txtCertificateCode.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

- (void) Check_Code
{
    txtCertificateCode.text = [txtCertificateCode.text uppercaseString];
    if(txtCertificateCode.text.length > [@5 longLongValue])
    {
//        [self.view endEditing:YES];
//        [txtCertificateCode resignFirstResponder];
//        
        [self Progress_Show:@"Validating"];

        Certificate *certificate_obj = [[Certificate alloc]init];
        certificate_obj.certificate_code = txtCertificateCode.text;
        
        self.deal_controller.certificate_obj = certificate_obj;
        self.deal_controller.merchant_contact_obj = self.merchant_controller.merchant_contact_obj;
        [self.deal_controller Lookup_Certificate:^(void)
         {
             successful = self.deal_controller.successful;
             system_successful_obj = self.deal_controller.system_successful_obj;
             system_error_obj = self.deal_controller.system_error_obj;

             [self Progress_Close];

             if(successful)
             {
                 [self.view endEditing:YES];
                 [txtCertificateCode resignFirstResponder];
                 
                 if(vc_certificate_redeem == nil)
                 {
                     vc_certificate_redeem = [[Certificate_Redeem alloc]init];
                 }
                 vc_certificate_redeem.deal_controller = self.deal_controller;
                 vc_certificate_redeem.merchant_controller = self.merchant_controller;
                 vc_certificate_redeem.system_controller = self.system_controller;
                 vc_certificate_redeem.hidesBottomBarWhenPushed = YES;
        
                 [self.navigationController pushViewController:vc_certificate_redeem animated:YES];
             }
             else
             {
                 GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Validation" message:system_error_obj.message cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 
                 alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
                 {
                     if (cancelled)
                     {
                         [txtCertificateCode setText:@""];
                     }
                 };
                 
                 [alert show];
             }
         }];
    }
}

-(void)Debug
{
    txtCertificateCode.text = @"TYBTP";
}

@end
