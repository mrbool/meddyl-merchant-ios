#import "Merchant_Edit.h"

#define COMPRESS_RATIO 0.004f
#define ORIGINAL_MAX_WIDTH 640.0f

@interface Merchant_Edit ()
{
    
    UIImageView *imvLogo;
    GTTextField* txtCompanyName;
    GTPickerView_TextField* pkvIndustry;
    GTTextView* txvDescription;
    GTTextField* txtAddress1;
    GTTextField* txtAddress2;
    GTTextField* txtZipCode;
    GTPickerView_TextField* pkvNeighborhood;
    GTTextField* txtPhone;
    GTTextField* txtWebsite;
    
    BOOL keyboardIsShown;
    NSString *picked_image_file_name;
    BOOL new_picture;
}
@end


@implementation Merchant_Edit

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screen_title = @"EDIT";
    self.left_button = @"back";
    self.right_button = @"save";
    
    [self Set_Controller_Properties];
    
    keyboardIsShown = NO;
    
    [self Create_Layout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    txvDescription.placeholder = self.system_controller.system_settings_obj.customer_description_default;

    if(!self.loaded)
    {
        picked_image_file_name = @"";
        
        [self Load_Data];
        
        if(self.debug)
            [self Debug];
        
        self.loaded = YES;
        self.edited = NO;
    }
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


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    UIImage *image = editedImage;
    
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
    imvLogo.image = image;
    
    //imvLogo.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^()
    {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^
        {
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


/* public methods */
-(void) Create_Layout
{
    CGFloat image_width = self.screen_width/2;
    imvLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image_width, image_width)];
    imvLogo.layer.cornerRadius = 6;
    imvLogo.layer.borderWidth = 1.0f;
    imvLogo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [Coding Add_View:contentView view:imvLogo x:self.screen_width * .25 height:image_width prev_frame:CGRectNull gap:(self.gap * 5)];

    UITapGestureRecognizer *tapLogo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Show_Image_Menu)];
    tapLogo.numberOfTapsRequired = 1;
    [imvLogo setUserInteractionEnabled:YES];
    [imvLogo addGestureRecognizer:tapLogo];
    
    txtCompanyName = [Coding Create_Text_Field:@"Company Name" format_type:@"name" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtCompanyName x:self.screen_indent_x height:txtCompanyName.frame.size.height prev_frame:imvLogo.frame gap:(self.gap * 5)];

    pkvIndustry = [Coding Create_Picker:@"Industry" format_type:@"" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:pkvIndustry x:self.screen_indent_x height:pkvIndustry.frame.size.height prev_frame:txtCompanyName.frame gap:(self.gap * 5)];
    
    txvDescription = [[GTTextView alloc]init];
    [txvDescription setFont:text_field_font];
    txvDescription.frame = CGRectMake(self.screen_indent_x, 0, self.screen_indent_width, self.screen_height * .25);
    [Coding Add_View:contentView view:txvDescription x:self.screen_indent_x height:txvDescription.frame.size.height prev_frame:pkvIndustry.frame gap:(self.gap * 5)];
    
    txtAddress1 = [Coding Create_Text_Field:@"Address 1" format_type:@"name" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtAddress1 x:self.screen_indent_x height:txtAddress1.frame.size.height prev_frame:txvDescription.frame gap:(self.gap * 5)];
    
    txtAddress2 = [Coding Create_Text_Field:@"Address 2" format_type:@"name" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtAddress2 x:self.screen_indent_x height:txtAddress2.frame.size.height prev_frame:txtAddress1.frame gap:self.gap];
    
    txtZipCode = [Coding Create_Text_Field:@"Zip Code" format_type:@"zipcode" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [txtZipCode addTarget:self action:@selector(Edit_Zip_Code) forControlEvents:UIControlEventEditingChanged];
    [Coding Add_View:contentView view:txtZipCode x:self.screen_indent_x height:txtZipCode.frame.size.height prev_frame:txtAddress2.frame gap:self.gap];
    
    pkvNeighborhood = [Coding Create_Picker:@"Neighborhood" format_type:@"" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:pkvNeighborhood x:self.screen_indent_x height:pkvNeighborhood.frame.size.height prev_frame:txtZipCode.frame gap:self.gap];
    
    txtPhone = [Coding Create_Text_Field:@"Phone Number" format_type:@"phone" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtPhone x:self.screen_indent_x height:txtPhone.frame.size.height prev_frame:pkvNeighborhood.frame gap:(self.gap * 5)];
    
    txtWebsite = [Coding Create_Text_Field:@"Website" format_type:@"website" characters:@100 width:self.screen_indent_width height:self.text_field_height font:text_field_font];
    [Coding Add_View:contentView view:txtWebsite x:self.screen_indent_x height:txtWebsite.frame.size.height prev_frame:txtPhone.frame gap:(self.gap * 5)];
    
    [self Add_View:self.screen_width height:[self Get_Scroll_Height:txtWebsite.frame scroll_lag:0] background_color:[UIColor clearColor]];
}

-(void)Load_Data
{
    [self Progress_Show:@"Loading"];
    
    [self.merchant_controller Get_Merchant_Contact:^(void)
     {
         successful = self.merchant_controller.successful;
         system_successful_obj = self.merchant_controller.system_successful_obj;
         system_error_obj = self.merchant_controller.system_error_obj;
         
         if(successful)
         {
             NSString *phone = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"(", [self.merchant_controller.merchant_obj.phone substringWithRange:NSMakeRange (0, 3)], @") ",
                                [self.merchant_controller.merchant_obj.phone substringWithRange:NSMakeRange (3, 3)], @"-",
                                [self.merchant_controller.merchant_obj.phone substringWithRange:NSMakeRange (6, self.merchant_controller.contact_obj.phone.length - 6)]];
             
             [imvLogo sd_setImageWithURL:[NSURL URLWithString:self.merchant_controller.merchant_obj.image]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
             txtCompanyName.text = self.merchant_controller.merchant_obj.company_name;
             txvDescription.text = self.merchant_controller.merchant_obj.description;
             txtAddress1.text = self.merchant_controller.merchant_obj.address_1;
             txtAddress2.text = self.merchant_controller.merchant_obj.address_2;
             txtZipCode.text = self.merchant_controller.merchant_obj.zip_code_obj.zip_code;
             txtPhone.text = phone;
             txtWebsite.text = self.merchant_controller.merchant_obj.website;
             
             [self Load_Industry];
             [self Load_Neighborhood];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         
         [self Progress_Close];
     }];
}

-(void)Load_Industry
{
    /* load industry pick list */
    Industry *industry_obj = [[Industry alloc]init];
    industry_obj.parent_industry_id = @2;
    
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
         pkvIndustry.default_id = self.merchant_controller.merchant_obj.industry_obj.industry_id;
         [pkvIndustry Set_Selected];
         pkvIndustry.text = self.merchant_controller.merchant_obj.industry_obj.industry;
         
         if(!successful)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

-(void)Load_Neighborhood
{
    Zip_Code *zip_code_obj = [[Zip_Code alloc]init];
    zip_code_obj.zip_code = txtZipCode.text;
    
    self.system_controller.zip_code_obj = zip_code_obj;
    [self.system_controller Get_Neighborhood_By_Zip:^(void)
     {
         successful = self.system_controller.successful;
         system_successful_obj = self.system_controller.system_successful_obj;
         system_error_obj = self.system_controller.system_error_obj;
         
         if(successful)
         {
             NSMutableArray *neighborhood_obj_array = self.system_controller.neighborhood_obj_array;
             pkvNeighborhood.input_array = neighborhood_obj_array;
             
             if(neighborhood_obj_array.count >= 1)
             {
                 [pkvNeighborhood setHidden:NO];
                 
                 pkvNeighborhood.column_id = @"neighborhood_id";
                 pkvNeighborhood.column_text = @"neighborhood";
                 if([txtZipCode.text isEqualToString:self.merchant_controller.merchant_obj.zip_code_obj.zip_code])
                 {
                     pkvNeighborhood.default_id = self.merchant_controller.merchant_obj.neighborhood_obj.neighborhood_id;
                     [pkvNeighborhood Set_Selected];
                     pkvNeighborhood.text = self.merchant_controller.merchant_obj.neighborhood_obj.neighborhood;
                 }
             }
             else
             {
                 [pkvNeighborhood setHidden:YES];
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zip Code Incorrect" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
    }];
}

-(void)Edit_Zip_Code
{
    if(txtZipCode.text.length > [@4 longLongValue])
    {
        [self Load_Neighborhood];
    }
    else
    {
        pkvNeighborhood.selected_id = nil;
        [pkvNeighborhood setText:@""];
        [pkvNeighborhood setHidden:YES];
    }
}

- (void) Edit_Text
{
    self.edited = YES;
}

-(void)Save_Click
{
    NSString *company_name = [txtCompanyName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSNumber *industry_id = pkvIndustry.selected_id;
    NSString *description = [txvDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *address_1 = [txtAddress1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *address_2 = [txtAddress2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *zip_code = [txtZipCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSNumber *neighborhood_id = pkvNeighborhood.selected_id;
    NSString *phone = [[txtPhone.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    NSString *website = [txtWebsite.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
    /* get image info */
    NSString* image_base64 = @"";
    
    if(![picked_image_file_name isEqualToString:@""])
    {
        NSData *stored_image_jpg_data = [NSData dataWithContentsOfFile:picked_image_file_name];
        image_base64 = [stored_image_jpg_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    self.merchant_controller.merchant_obj.image_base64 = image_base64;
    
    if(company_name.length == [@0 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Company Name" message:@"You must enter a company name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtCompanyName becomeFirstResponder];
    }
    else if(industry_id == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Industry" message:@"Please select and industry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [pkvIndustry becomeFirstResponder];
    }
    else if(description.length == [@0 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Description" message:@"You must enter a description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txvDescription becomeFirstResponder];
    }
    else if(address_1.length == [@0 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Company Name" message:@"You must enter a company name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtAddress1 becomeFirstResponder];
    }
    else if(zip_code.length != [@5 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zip Code" message:@"Zip code is incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtZipCode becomeFirstResponder];
    }
    else if(phone.length != [@10 longLongValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone" message:@"You must enter a valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [txtPhone becomeFirstResponder];
    }
    else
    {
        /* if fails, reset to this */
        Merchant* merchant_obj_update = [[Merchant alloc]init];
        merchant_obj_update = self.merchant_controller.merchant_obj;
        
        Zip_Code* zip_code_obj = [[Zip_Code alloc]init];
        zip_code_obj.zip_code = zip_code;
        
        Industry* industry_obj = [[Industry alloc]init];
        industry_obj.industry_id = industry_id;
        
        Neighborhood* neighborhood_obj = [[Neighborhood alloc]init];
        neighborhood_obj.neighborhood_id = neighborhood_id;
        
        Merchant *merchant_obj = [[Merchant alloc] init];
        merchant_obj.company_name = company_name;
        merchant_obj.description = description;
        merchant_obj.address_1 = address_1;
        merchant_obj.address_2 = address_2;
        merchant_obj.phone = phone;
        merchant_obj.website = website;
        merchant_obj.image_base64 = image_base64;
        merchant_obj.zip_code_obj = zip_code_obj;
        merchant_obj.industry_obj = industry_obj;
        merchant_obj.neighborhood_obj = neighborhood_obj;
        
        if((pkvNeighborhood.input_array.count >= 1) && (neighborhood_id == nil))
        {
            GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Neighborhood" message:@"Would you like to add a neighborhood?" cancelButtonTitle:@"Yes" otherButtonTitles:@[@"No"]];
            alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
            {
                if (!cancelled)
                {
                    [self Update_Merchant:merchant_obj];
                }
            };
            
            [alert show];
        }
        else
        {
            [self Update_Merchant:merchant_obj];
        }
    }
}

-(void)Update_Merchant:(Merchant*)merchant_obj
{
    [self Progress_Show:@"Updating"];
    
    self.merchant_controller.merchant_obj = merchant_obj;
    [self.merchant_controller Update_Merchant:^(void)
     {
         [self.view endEditing:YES];
         
         successful = self.merchant_controller.successful;
         system_successful_obj = self.merchant_controller.system_successful_obj;
         system_error_obj = self.merchant_controller.system_error_obj;
         
         [self Progress_Close];
         
         if(successful)
         {
             SDImageCache *imageCache = [SDImageCache sharedImageCache];
             [imageCache clearMemory];
             [imageCache clearDisk];

             GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Successful" message:system_successful_obj.message cancelButtonTitle:@"OK" otherButtonTitles:nil];
             
             alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
             {
                 if (cancelled)
                 {
                     [self.view endEditing:YES];
                     [self.navigationController popViewControllerAnimated:TRUE];
                 }
             };
             
             [alert show];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
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
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;

    [self presentViewController:imagePickerController animated:YES completion:^(void){
        NSLog(@"Picker View Controller is presented");
    }];
}

- (void)Choose_Picture
{
    new_picture = NO;

    UIImagePickerController *imagePickerController = [UIImagePickerController new] ;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:^(void){
        NSLog(@"Picker View Controller is presented");
    }];
}

-(void)Back_Click
{
    if(![picked_image_file_name isEqualToString:@""])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_obj.company_name isEqualToString:txtCompanyName.text])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_obj.industry_obj.industry_id isEqual:pkvIndustry.selected_id])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_obj.description isEqualToString:txvDescription.text])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_obj.address_1 isEqualToString:txtAddress1.text])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_obj.address_2 isEqualToString:txtAddress2.text])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_obj.zip_code_obj.zip_code isEqualToString:txtZipCode.text])
    {
        self.edited = YES;
    }
    else if((![self.merchant_controller.merchant_obj.neighborhood_obj.neighborhood_id isEqual:pkvNeighborhood.selected_id]) &&
            ((self.merchant_controller.merchant_obj.neighborhood_obj.neighborhood_id !=nil) && pkvNeighborhood.selected_id != nil))
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_obj.phone isEqualToString:[[txtPhone.text componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""]])
    {
        self.edited = YES;
    }
    else if(![self.merchant_controller.merchant_obj.website isEqualToString:txtWebsite.text])
    {
        self.edited = YES;
    }
    else
    {
        self.edited = NO;
    }
    
    if(self.edited)
    {
        GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Cancel" message:@"You have unsaved changes, are you sure you want to cancel?" cancelButtonTitle:@"Yes" otherButtonTitles:@[@"No"]];
        alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
        {
            if (cancelled)
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

- (void)keyboardWillHide:(NSNotification *)n
{
    //NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    //CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the scrollview
    CGRect viewFrame = scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
//    viewFrame.size.height += (keyboardSize.height - 50);
    viewFrame.size.height = self.screen_height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = scrollView.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    //viewFrame.size.height -= (keyboardSize.height - 20);
    viewFrame.size.height = (keyboardSize.height - 20);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [scrollView setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

@end
