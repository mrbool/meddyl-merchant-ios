#import "Deal_Image.h"

#define COMPRESS_RATIO 0.08f


@interface Deal_Image ()
{
    UIImageView *imgDeal;
    
    BOOL new_picture;
    NSString *picked_image_file_name;
    
    Deal_Review *vc_deal_review;
}
@end


@implementation Deal_Image

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"IMAGE";
    self.left_button = @"back";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
    
//    if(self.debug)
//        [self Debug];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if((self.deal_controller.deal_obj.deal_id != nil) && (!self.loaded))
    {
        NSURL* url = [NSURL URLWithString:self.deal_controller.deal_obj.image];
        NSData *receivedData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:receivedData];
        
        // save to app directory after compression
        NSData *picked_image_data = UIImageJPEGRepresentation(image, COMPRESS_RATIO);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *document_path = [paths objectAtIndex:0]; //Get the docs directory
        picked_image_file_name = [document_path stringByAppendingPathComponent:@"deal_image.jpg"]; //Add the file name
        [picked_image_data writeToFile:picked_image_file_name atomically:YES];
        
        // load image
        self.deal_controller.deal_obj.image = picked_image_file_name;
        imgDeal.image = image;
    }
    
    self.loaded = YES;
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
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //resize
    image = [Utilities imageWithImage:image scaledToSize:CGSizeMake(self.screen_indent_width, self.screen_indent_width * .66)];
    
    // save to camera roll
    if(new_picture)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    // save to app directory after compression
    NSData *picked_image_data = UIImageJPEGRepresentation(image, COMPRESS_RATIO);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document_path = [paths objectAtIndex:0]; //Get the docs directory
    picked_image_file_name = [document_path stringByAppendingPathComponent:@"deal_image.jpg"]; //Add the file name
    [picked_image_data writeToFile:picked_image_file_name atomically:YES];

    // load image
    self.deal_controller.deal_obj.image = picked_image_file_name;
    imgDeal.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
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
    
    imgDeal = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.screen_indent_width, self.screen_indent_width * .66)];
    imgDeal.image = [UIImage imageNamed:@"deal_image_placeholder.png"];
    imgDeal.clipsToBounds = YES;
    [Coding Add_View:contentView view:imgDeal x:self.screen_indent_x height:imgDeal.frame.size.height prev_frame:lblImageNotes.frame gap:(self.gap * 5)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Show_Image_Menu)];
    singleTap.numberOfTapsRequired = 1;
    [imgDeal setUserInteractionEnabled:YES];
    [imgDeal addGestureRecognizer:singleTap];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:imgDeal.frame scroll_lag:0] background_color:[UIColor clearColor]];
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
        popPresenter.sourceView = imgDeal;
        popPresenter.sourceRect = imgDeal.bounds;
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
    GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Take a Picture" message:@"For best results, rotate your camera sideways" cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alert.completion = ^(BOOL cancelled, NSInteger buttonIndex) {
        if (cancelled)
        {
            new_picture = YES;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
    };
    
    [alert show];
}

- (void)Choose_Picture
{
    new_picture = NO;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)Next_Click
{
    if(picked_image_file_name == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image" message:@"You must add an image for this deal" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [super Next_Click];
        
        if(vc_deal_review == nil)
        {
            vc_deal_review = [[Deal_Review alloc]init];
        }
        vc_deal_review.deal_controller = self.deal_controller;
        vc_deal_review.merchant_controller = self.merchant_controller;
        vc_deal_review.system_controller = self.system_controller;
        vc_deal_review.picked_image_file_name = picked_image_file_name;
        vc_deal_review.hidesBottomBarWhenPushed = YES;
        
        if(![self.navigationController.topViewController isKindOfClass:[Deal_Review class]])
        {
            [self.navigationController pushViewController:vc_deal_review animated:YES];
        }
    }
}

-(void) Debug
{

//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *document_path = [paths objectAtIndex:0]; //Get the docs directory
//    NSString *picked_image_file_name = [document_path stringByAppendingPathComponent:@"deal_image.jpg"]; //Add the file name
    //UIImage *image = [UIImage imageWithContentsOfFile:picked_image_file_name];
    
    // load image
    //self.deal_controller.deal_obj.image = picked_image_file_name;
    //imgDeal.image = image;
}

@end
