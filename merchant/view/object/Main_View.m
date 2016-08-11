#import "Main_View.h"


@interface Main_View ()
{
    UIImageView* imvMain;
    ACPButton *btnLogIn;
    ACPButton *btnRegister;
}
@end


@implementation Main_View

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self Progress_Show:@"Loading"];
    
    [self Load_System_Settings];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

- (void)statusFrameChanged:(NSNotification*)note
{
    CGRect status_frame = [note.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    CGFloat status_bar_height = status_frame.size.height;
    
    CGFloat button_width = (self.screen_width/2) - (self.screen_indent_x * 1.5);
    CGFloat button_height = self.screen_height/11;
    CGFloat button_y = self.screen_height - self.screen_indent_x - btnLogIn.frame.size.height;
    
    if(status_bar_height != 20)
        button_y = button_y - 30;
    
    btnLogIn.frame = CGRectMake(self.screen_indent_x, button_y, button_width, button_height);
    
    CGFloat button_x = (self.screen_width/2) + (self.screen_indent_x * .5);
    btnRegister.frame = CGRectMake(button_x, button_y, button_width, button_height);
}

/* public methods */
-(void) Create_Layout
{
    UIImage *image = [UIImage imageNamed:@"main.png"];
    
    imvMain = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screen_width, self.screen_height)];
    imvMain.clipsToBounds = YES;
    imvMain.image = image;
    [Coding Add_View:self.view view:imvMain x:0 height:imvMain.frame.size.height prev_frame:CGRectNull gap:0];
    
    CGFloat image_width = (self.screen_width * .85);
    CGFloat image_height = 165 * (image_width/630);
    CGFloat image_x = (self.screen_width - image_width)/2;
    UIImageView* imvLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image_width, image_height)];
    imvLogo.image = [UIImage imageNamed:@"logo.png"];
    imvLogo.clipsToBounds = YES;
    [Coding Add_View:self.view view:imvLogo x:image_x height:imvLogo.frame.size.height prev_frame:CGRectNull gap:self.screen_height/3];

    btnLogIn = [[ACPButton alloc]init];
    [btnLogIn setStyleType:ACPButtonWhite];
    [btnLogIn setLabelTextColor:[UIColor redColor] highlightedColor:[UIColor redColor] disableColor:nil];
    [btnLogIn addTarget:self action:@selector(btnLogIn_Click:) forControlEvents:UIControlEventTouchUpInside];
    [btnLogIn setTitle:@"Log In" forState:UIControlStateNormal];
    [btnLogIn setLabelFont:button_font];
    CGFloat button_width = (self.screen_width/2) - (self.screen_indent_x * 1.5);
    CGFloat button_height = self.screen_height/11;
    btnLogIn.frame = CGRectMake(0, 0, button_width, button_height);
    CGFloat button_y = self.screen_height - self.screen_indent_x - btnLogIn.frame.size.height;
    [Coding Add_View:self.view view:btnLogIn x:self.screen_indent_x height:btnLogIn.frame.size.height prev_frame:CGRectNull gap:button_y];
  
    btnRegister = [[ACPButton alloc]init];
    [btnRegister setStyleType:ACPButtonBlue];
    [btnRegister setLabelTextColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] disableColor:nil];
    [btnRegister addTarget:self action:@selector(btnRegister_Click:) forControlEvents:UIControlEventTouchUpInside];
    [btnRegister setTitle:@"Register" forState:UIControlStateNormal];
    [btnRegister setLabelFont:button_font];
    btnRegister.frame = CGRectMake(0, 0, button_width, button_height);
    CGFloat button_x = (self.screen_width/2) + (self.screen_indent_x * .5);
    [Coding Add_View:self.view view:btnRegister x:button_x height:btnRegister.frame.size.height prev_frame:CGRectNull gap:button_y];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)Load_System_Settings
{
    [self.system_controller Get_System_Settings:^(void)
     {
         successful = self.system_controller.successful;
         system_successful_obj = self.system_controller.system_successful_obj;
         system_error_obj = self.system_controller.system_error_obj;
         
         if(successful)
         {
             [self Auto_Login];
         }
         else
         {
             [self Show_Error];
         }
     }];
}

-(void)Auto_Login
{
    NSString *user_name = [SSKeychain passwordForService:@"user_name" account:@"app"];
    NSString *password = [SSKeychain passwordForService:@"password" account:@"app"];
    
    if(user_name != nil)
    {
        Contact *contact_obj = [[Contact alloc]init];
        contact_obj.user_name = user_name;
        contact_obj.password = password;
        
        self.merchant_controller.login_log_obj.auto_login = [NSNumber numberWithBool:YES];
        self.merchant_controller.contact_obj = contact_obj;
        [self.merchant_controller Login:^(void)
         {
             [self Progress_Close];
             
             if(self.merchant_controller.successful)
             {
                 if(self.merchant_controller.merchant_contact_obj.merchant_contact_id != nil)
                 {
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
             }
             else
             {
                 [self Show_Error];
             }
         }];
    }
    else
    {
        self.merchant_controller.merchant_obj = nil;
        self.merchant_controller.merchant_contact_obj = nil;
        self.merchant_controller.contact_obj = nil;
        
        [self Progress_Close];
    }
}

- (void)btnRegister_Click:(id)sender
{
    Register_Validation_Create *vc=[[Register_Validation_Create alloc]init];
    vc.merchant_controller = self.merchant_controller;
    vc.system_controller = self.system_controller;

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnLogIn_Click:(id)sender
{
    Login *vc=[[Login alloc]init];
    vc.merchant_controller = self.merchant_controller;
    vc.system_controller = self.system_controller;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
