#import "Register_Logo.h"

#define COMPRESS_RATIO 0.004f


@interface Register_Logo ()
{
    UIImageView *imvLogo;
    
    BOOL new_picture;
    NSString *picked_image_file_name;
    
    Merchant_Info* vc_merchant_info;
}

@end


@implementation Register_Logo

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"LOGO";
    self.left_button = @"back";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];

    if(self.merchant_controller.merchant_obj.image != nil)
    {
        UIImage *image = [UIImage imageNamed:self.merchant_controller.merchant_obj.image];
        imvLogo.image = image;
    }
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    // save to camera roll
    if(new_picture)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    // save to app directory after compression
    NSData *picked_image_data = UIImageJPEGRepresentation(image, COMPRESS_RATIO);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document_path = [paths objectAtIndex:0]; //Get the docs directory
    picked_image_file_name = [document_path stringByAppendingPathComponent:@"company_logo.jpg"]; //Add the file name
    [picked_image_data writeToFile:picked_image_file_name atomically:YES];
    
    // load image
    self.merchant_controller.merchant_obj.image = picked_image_file_name;
    imvLogo.image = image;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


/* public properties */
-(void)Create_Layout
{
    GTLabel* lblImageNotes = [Coding Create_Label:@"Tap the image to change your logo" width:self.screen_indent_width font:label_font mult:NO];
    [lblImageNotes setNumberOfLines:1];
    lblImageNotes.adjustsFontSizeToFitWidth=YES;
    [lblImageNotes setTextAlignment:NSTextAlignmentCenter];
    [Coding Add_View:contentView view:lblImageNotes x:self.screen_indent_x height:lblImageNotes.frame.size.height prev_frame:CGRectNull gap:(self.gap * 2)];

    CGFloat image_x = (self.screen_width/2) - (self.screen_height/2/2);
    imvLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.screen_height/2, self.screen_height/2)];
    imvLogo.image = [UIImage imageNamed:@"your_logo_here.jpg"];
    imvLogo.layer.cornerRadius = 6;
    imvLogo.clipsToBounds = YES;
    imvLogo.layer.borderWidth = 1.0f;
    imvLogo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [Coding Add_View:contentView view:imvLogo x:image_x height:imvLogo.frame.size.height prev_frame:lblImageNotes.frame gap:(self.gap * 5)];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Show_Image_Menu)];
    singleTap.numberOfTapsRequired = 1;
    [imvLogo setUserInteractionEnabled:YES];
    [imvLogo addGestureRecognizer:singleTap];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:imvLogo.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

- (void)chooseImage:(id)sender
{
    [self Show_Image_Menu];
}

-(void) Show_Image_Menu
{
    if ([UIAlertController class])
    {
        //ios 8
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //show camera option only if available
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertAction *takePictureAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self Take_Picture];
            }];
            [controller addAction:takePictureAction];
        }
        
        UIAlertAction *chooseFromGalleryAction = [UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self Choose_Picture];
        }];
        [controller addAction:chooseFromGalleryAction];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //TODO take a picture
                [controller dismissViewControllerAnimated:YES completion:nil];
            }];
            [controller addAction:cancelAction];
        }
        
        UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //TODO take a picture
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        [controller addAction:cancelAction2];
        
        [controller setModalPresentationStyle:UIModalPresentationPopover];
        
        UIPopoverPresentationController *popPresenter = [controller popoverPresentationController];
        popPresenter.sourceView = imvLogo;
        popPresenter.sourceRect = imvLogo.bounds;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        //ios 7
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
        
        //show camera option only if available
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [actionSheet addButtonWithTitle:@"Take Photo"];
        }
        [actionSheet addButtonWithTitle:@"Choose Photo"];
        [actionSheet addButtonWithTitle:@"Cancel"];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [actionSheet addButtonWithTitle:@""];
            actionSheet.cancelButtonIndex = actionSheet.numberOfButtons-2;
        }
        else
        {
            actionSheet.cancelButtonIndex = actionSheet.numberOfButtons-1;
        }
        
        [actionSheet showInView:self.view];
    }
}

- (void)Take_Picture
{
    new_picture = YES;
    
    UIImagePickerController *imagePickerController = [UIImagePickerController new] ;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [imagePickerController setAllowsEditing:YES];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
    }
    else
    {
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)Choose_Picture
{
    new_picture = NO;
    
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [imagePickerController setAllowsEditing:YES];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
    }
    else
    {
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)Next_Click
{
    if(picked_image_file_name == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Logo" message:@"Please take a picture or choose an image of your company logo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [self.view endEditing:YES];

        if(vc_merchant_info == nil)
        {
            vc_merchant_info = [[Merchant_Info alloc]init];
        }
        vc_merchant_info.deal_controller = self.deal_controller;
        vc_merchant_info.merchant_controller = self.merchant_controller;
        vc_merchant_info.system_controller = self.system_controller;
        vc_merchant_info.picked_image_file_name = picked_image_file_name;
        
        [self.navigationController pushViewController:vc_merchant_info animated:YES];
    }
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void) Debug
{

}

@end
