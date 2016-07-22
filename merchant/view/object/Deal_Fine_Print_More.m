#import "Deal_Fine_Print_More.h"


@interface Deal_Fine_Print_More ()
{
    GTTextView *txvFinePrint;
    GTLabel *lblCharacterCount;
    
    Deal_Image *vc_deal_image;
}
@end


@implementation Deal_Fine_Print_More

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"MORE FINE PRINT";
    self.left_button = @"back";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];

    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    txvFinePrint.placeholder = self.system_controller.system_settings_obj.fine_print_more_default;
    
    if(!self.loaded)
    {
        [txvFinePrint setText:self.deal_controller.deal_obj.fine_print];
        
        NSInteger len = txvFinePrint.text.length;
        lblCharacterCount.text=[NSString stringWithFormat:@"%d%@",[self.system_controller.system_settings_obj.fine_print_more_characters integerValue]-len, @" characters left"];
    }
    
    self.loaded = YES;
    
//    if(self.debug)
//        [self Debug];
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
    NSInteger len = textView.text.length;
    lblCharacterCount.text=[NSString stringWithFormat:@"%d%@",[self.system_controller.system_settings_obj.fine_print_more_characters integerValue]-len, @" characters left"];
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
    GTLabel *lblFinePrint = [Coding Create_Label:@"Add any fine print, this will restrict the deal to whatever you like" width:self.screen_indent_width font:label_font mult:YES];
    [Coding Add_View:contentView view:lblFinePrint x:self.screen_indent_x height:[Utilities Get_Height:lblFinePrint] prev_frame:CGRectNull gap:(self.gap * 7)];
    
    txvFinePrint = [Coding Create_Text_View:@"" characters:nil width:self.screen_indent_width height:(self.screen_height/4.75) font:text_field_font];
    txvFinePrint.delegate = self;
    [Coding Add_View:contentView view:txvFinePrint x:self.screen_indent_x height:txvFinePrint.frame.size.height prev_frame:lblFinePrint.frame gap:12];
    
    lblCharacterCount = [Coding Create_Label:[NSString stringWithFormat:@"%ld%@",(long)[self.system_controller.system_settings_obj.merchant_description_characters integerValue], @" characters left"] width:self.screen_indent_width font:[UIFont fontWithName:@"AvenirNext-Medium" size:18] mult:YES];
    [lblCharacterCount setTextAlignment:NSTextAlignmentRight];
    [Coding Add_View:contentView view:lblCharacterCount x:self.screen_indent_x height:lblCharacterCount.frame.size.height prev_frame:txvFinePrint.frame gap:10];

    [self Add_View:self.screen_width height:[self Get_Scroll_Height:lblCharacterCount.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

- (void)Next_Click
{
    [super Next_Click];
    
    self.deal_controller.deal_obj.fine_print = txvFinePrint.text;
    
    if(vc_deal_image == nil)
    {
        vc_deal_image = [[Deal_Image alloc]init];
    }
    vc_deal_image.deal_controller = self.deal_controller;
    vc_deal_image.merchant_controller = self.merchant_controller;
    vc_deal_image.system_controller = self.system_controller;
    vc_deal_image.hidesBottomBarWhenPushed = YES;
    
    if(![self.navigationController.topViewController isKindOfClass:[Deal_Image class]])
    {
        [self.navigationController pushViewController:vc_deal_image animated:YES];
    }
}

-(void)Back_Click
{
    self.deal_controller.deal_obj.fine_print = txvFinePrint.text;
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)Debug
{
    txvFinePrint.text = @"Not valid any day";
}

@end
