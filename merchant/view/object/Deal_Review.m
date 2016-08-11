#import "Deal_Review.h"


@interface Deal_Review ()
{
    UIButton *btnPhone;
    UIButton *btnDirections;
    UIButton *btnWebsite;
    
    NSData *imageData;
    NSString *url_merchant_address;
    ACPButton *btnCreate;
    Deal_Validate *vc_deal_validate;
    Merchant_Info *vc_merchant_info;
}

@end


@implementation Deal_Review

@synthesize picked_image_file_name;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screen_title = @"REVIEW";
    self.left_button = @"back";
    self.right_button = @"";
    
    [self Set_Controller_Properties];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self Progress_Show:@"Loading"];
    
    [self Create_Layout];
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
    
    CGFloat button_y;
    if(status_bar_height == 20)
        button_y = 448;
    else
        button_y = 428;
    
    btnCreate.frame = CGRectMake(0, button_y, 320, 55.0);
}


/* public methods */
-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)Create_Layout
{
    [[contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    /* grab data */
    [self.merchant_controller Get_Merchant_Contact:^(void)
     {
         successful = self.merchant_controller.successful;
         system_successful_obj = self.merchant_controller.system_successful_obj;
         system_error_obj = self.merchant_controller.system_error_obj;
         
         if(successful)
         {
             [self.deal_controller Verify_Deal:^(void)
              {
                  successful = self.deal_controller.successful;
                  system_successful_obj = self.deal_controller.system_successful_obj;
                  system_error_obj = self.deal_controller.system_error_obj;
                  
                  if(successful)
                  {
                      Deal* deal_obj = self.deal_controller.deal_obj;
                      Merchant* merchant_obj = self.merchant_controller.merchant_obj;
                      
                      /* add deal image */
                      UIImageView *imvDeal = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.screen_width, self.screen_width * .75)];
                      NSString  *image_file = picked_image_file_name;
                      imageData = [NSData dataWithContentsOfFile:image_file];
                      UIImage *img = [UIImage imageWithData:imageData];
                      [imvDeal setImage:img];
                      [contentView addSubview:imvDeal];

                      GTLabel *lblCompanyName = [Coding Create_Label:merchant_obj.company_name width:(self.screen_indent_width * .73) font:label_font_large mult:YES];
                      [Coding Add_View:contentView view:lblCompanyName x:self.screen_indent_x height:[Utilities Get_Height:lblCompanyName] prev_frame:imvDeal.frame gap:self.gap];
                      
                      /* add company logo to the right */
                      CGFloat logo_width = self.screen_width * .25;
                      CGFloat logo_x = self.screen_width * .725;
                      UIImageView *imvLogo = [[UIImageView alloc] initWithFrame:CGRectMake(logo_x, 0, logo_width, logo_width)];
                      imvLogo.layer.cornerRadius = 6;
                      imvLogo.clipsToBounds = YES;
                      imvLogo.layer.borderWidth = 1.0f;
                      imvLogo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                      [imvLogo sd_setImageWithURL:[NSURL URLWithString:merchant_obj.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                      [Coding Add_View:contentView view:imvLogo x:logo_x height:imvLogo.frame.size.height prev_frame:imvDeal.frame gap:(self.gap * 2)];

                      UITapGestureRecognizer *tapMerchant = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imvLogo_Click)];
                      tapMerchant.numberOfTapsRequired = 1;
                      [imvLogo setUserInteractionEnabled:YES];
                      [imvLogo addGestureRecognizer:tapMerchant];
                      
                      /* get neighborhood */
                      NSString* neighborhood;
                      if(merchant_obj.neighborhood_obj.neighborhood_id == nil)
                          neighborhood = merchant_obj.zip_code_obj.city_obj.city;
                      else
                          neighborhood = merchant_obj.neighborhood_obj.neighborhood;
                      
                      GTLabel *lblNeighborhood = [Coding Create_Label:neighborhood width:(self.screen_indent_width * .73) font:label_font mult:NO];
                      [Coding Add_View:contentView view:lblNeighborhood x:self.screen_indent_x height:[Utilities Get_Height:lblNeighborhood] prev_frame:lblCompanyName.frame gap:self.gap];
                      
                      /* stars image */
                      UIImageView *imgStars = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.screen_width * .3125, self.screen_height * .035)];
                      imgStars.image = [UIImage imageNamed:merchant_obj.merchant_rating_obj.image];
                      [Coding Add_View:contentView view:imgStars x:self.screen_indent_x height:imgStars.frame.size.height prev_frame:lblNeighborhood.frame gap:(self.gap * 3)];
                      
                      UIView *vwLine0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_indent_width, 1)];
                      vwLine0.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
                      [Coding Add_View:contentView view:vwLine0 x:self.screen_indent_x height:1 prev_frame:imgStars.frame gap:(self.gap * 7)];
                      
                      GTLabel *lblDeal = [Coding Create_Label:deal_obj.deal width:self.screen_indent_width font:label_font_large mult:YES];
                      [Coding Add_View:contentView view:lblDeal x:self.screen_indent_x height:[Utilities Get_Height:lblDeal] prev_frame:vwLine0.frame gap:(self.gap * 7)];

                      /* get date info */
                      NSString *time_zone = deal_obj.time_zone_obj.abbreviation;
                      NSDate * expiration_date = deal_obj.expiration_date;
                      NSDateFormatter *expiration_date_format = [[NSDateFormatter alloc] init];
                      [expiration_date_format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:time_zone]];
                      [expiration_date_format setDateFormat:@"M/d/yyyy"];
                      
                      GTLabel *lblExpirationDate = [Coding Create_Label:[NSString stringWithFormat: @"%@%@", @"Deal ends on ", [expiration_date_format stringFromDate:expiration_date]] width:self.screen_indent_width font:label_font_large mult:YES];
                      [Coding Add_View:contentView view:lblExpirationDate x:self.screen_indent_x height:[Utilities Get_Height:lblExpirationDate] prev_frame:lblDeal.frame gap:(self.gap * 3)];
                      
                      UIView *vwLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_indent_width, 1)];
                      vwLine1.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
                      [Coding Add_View:contentView view:vwLine1 x:self.screen_indent_x height:1 prev_frame:lblExpirationDate.frame gap:(self.gap * 7)];
                      
                      GTLabel *lblFinePrintLabel = [Coding Create_Label:@"FINE PRINT" width:self.screen_indent_width font:label_font_medium mult:YES];
                      [Coding Add_View:contentView view:lblFinePrintLabel x:self.screen_indent_x height:[Utilities Get_Height:lblFinePrintLabel] prev_frame:vwLine1.frame gap:(self.gap * 7)];
                      
                      GTLabel *lblFinePrint = [Coding Create_Label:deal_obj.fine_print_ext width:self.screen_indent_width font:label_font mult:YES];
                      [Coding Add_View:contentView view:lblFinePrint x:self.screen_indent_x height:[Utilities Get_Height:lblFinePrint] prev_frame:lblFinePrintLabel.frame gap:(self.gap * 4)];
                      
                      UIView *vwLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_indent_width, 1)];
                      vwLine2.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
                      [Coding Add_View:contentView view:vwLine2 x:self.screen_indent_x height:1 prev_frame:lblFinePrint.frame gap:(self.gap * 7)];
                      
                      GTLabel *lblCertificatesRemaining = [Coding Create_Label:[NSString stringWithFormat: @"%@%@", [deal_obj.certificate_quantity stringValue], @" certificates left!"] width:self.screen_indent_width font:label_font_large mult:YES];
                      [Coding Add_View:contentView view:lblCertificatesRemaining x:self.screen_indent_x height:[Utilities Get_Height:lblCertificatesRemaining] prev_frame:vwLine2.frame gap:(self.gap * 7)];
                      
                      UIView *vwLine3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_indent_width, 1)];
                      vwLine3.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255 blue:190.0/255.0 alpha:1];
                      [Coding Add_View:contentView view:vwLine3 x:self.screen_indent_x height:1 prev_frame:lblCertificatesRemaining.frame gap:(self.gap * 7)];
                      
                      GTLabel *lblCompanyInfoLabel = [Coding Create_Label:@"COMPANY INFORMATION" width:self.screen_indent_width font:label_font mult:YES];
                      [Coding Add_View:contentView view:lblCompanyInfoLabel x:self.screen_indent_x height:[Utilities Get_Height:lblCompanyInfoLabel] prev_frame:vwLine3.frame gap:(self.gap * 7)];
                      
                      /* get address info */
                      NSString *address_1 =[NSString stringWithFormat: @"%@%@%@", merchant_obj.address_1, @" ", merchant_obj.address_2];
                      NSString *address_2 =[NSString stringWithFormat: @"%@%@%@%@%@", merchant_obj.zip_code_obj.city_obj.city, @", ", merchant_obj.zip_code_obj.city_obj.state_obj.abbreviation, @"  ", merchant_obj.zip_code_obj.zip_code];
                      NSString *phone =[NSString stringWithFormat: @"%@%@%@%@%@%@", @"(", [merchant_obj.phone substringWithRange:NSMakeRange(0, 3)], @") ", [merchant_obj.phone substringWithRange:NSMakeRange(3, 3)], @"-", [merchant_obj.phone substringWithRange:NSMakeRange(6, 4)]];
                      url_merchant_address = [NSString stringWithFormat:@"%@%@%@", address_1, @" ", address_2];
                      
                      MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.screen_width, self.screen_height * .37)];
                      [mapView setZoomEnabled:NO];
                      [mapView setScrollEnabled:NO];
                      
                      UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnDirections_Click:)];
                      [mapView addGestureRecognizer:tapGesture];
                      
                      CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                      [geocoder geocodeAddressString:[NSString stringWithFormat: @"%@%@%@", address_1, @" ", address_2] completionHandler:^(NSArray* placemarks, NSError* error){
                          for (CLPlacemark* aPlacemark in placemarks)
                          {
                              // Process the placemark.
                              NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
                              NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
                              
                              CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([latDest1 doubleValue], [lngDest1 doubleValue]);
                              
                              MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
                              MKCoordinateRegion region = {coord, span};
                              
                              MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                              [annotation setCoordinate:coord];
                              [mapView setRegion:region];
                              [annotation setTitle:merchant_obj.company_name]; //You can set the subtitle too
                              [mapView addAnnotation:annotation];
                              
                          }
                      }];
                      [Coding Add_View:contentView view:mapView x:0 height:self.screen_height * .37 prev_frame:lblCompanyInfoLabel.frame gap:(self.gap)];
                      
                      GTLabel *lblAddress1 = [Coding Create_Label:address_1 width:self.screen_indent_width font:label_font mult:YES];
                      [Coding Add_View:contentView view:lblAddress1 x:self.screen_indent_x height:[Utilities Get_Height:lblAddress1] prev_frame:mapView.frame gap:(self.gap * 2)];
                      
                      GTLabel *lblAddress2 = [Coding Create_Label:address_2 width:self.screen_indent_width font:label_font mult:YES];
                      [Coding Add_View:contentView view:lblAddress2 x:self.screen_indent_x height:[Utilities Get_Height:lblAddress2] prev_frame:lblAddress1.frame gap:(self.gap * 2)];
                      
                      btnDirections = [Coding Create_Link_Button:@"Directions" font:link_button_font];
                      [btnDirections addTarget:self action:@selector(btnDirections_Click:) forControlEvents:UIControlEventTouchUpInside];
                      [Coding Add_View:contentView view:btnDirections x:self.screen_indent_x height:btnDirections.frame.size.height prev_frame:lblAddress2.frame gap:(self.gap * 5)];
                      
                      btnPhone = [Coding Create_Link_Button:phone font:link_button_font];
                      [btnPhone addTarget:self action:@selector(btnPhone_Click:) forControlEvents:UIControlEventTouchUpInside];
                      [Coding Add_View:contentView view:btnPhone x:self.screen_indent_x height:btnPhone.frame.size.height prev_frame:btnDirections.frame gap:(self.gap * 5)];
                      
                      btnWebsite = [Coding Create_Link_Button:@"Website" font:link_button_font];
                      [btnWebsite addTarget:self action:@selector(btnWebsite_Click:) forControlEvents:UIControlEventTouchUpInside];
                      [Coding Add_View:contentView view:btnWebsite x:self.screen_indent_x height:btnWebsite.frame.size.height prev_frame:btnPhone.frame gap:(self.gap * 5)];
                      
                      [self Add_View:self.screen_width height:[self Get_Scroll_Height:btnWebsite.frame scroll_lag:self.button_height + self.gap] background_color:[UIColor whiteColor]];
                      
                      /* add layer on top of view */
                      CGFloat nav_bar_height = self.navigationController.navigationBar.frame.size.height;
                      CGRect status_frame = [(AppDelegate*)[[UIApplication sharedApplication] delegate] currentStatusBarFrame];
                      CGFloat status_bar_height = status_frame.size.height;
                      CGFloat button_y = self.screen_height - self.button_height - nav_bar_height - status_bar_height;
                      
                      NSString* button_text;
                      if(self.deal_controller.deal_obj.deal_id != nil)
                          button_text = @"Update Deal";
                      else
                          button_text = @"Create Deal";
                      
                      btnCreate = [Coding Create_Button:button_text font:button_font style:ACPButtonBlue text_color:[UIColor whiteColor] width:self.screen_width height:self.button_height];
                      [btnCreate addTarget:self action:@selector(btnCreate_Click:) forControlEvents:UIControlEventTouchUpInside];
                      [Coding Add_View:self.view view:btnCreate x:0 height:btnCreate.frame.size.height prev_frame:CGRectNull gap:button_y];

                      [scrollView setContentOffset:CGPointMake(0, -scrollView.contentInset.top) animated:YES];
                      
                      [self Progress_Close];
                  }
                  else
                  {
                      [self Show_Error];
                  }
              }];
         }
         else
         {
             [self Show_Error];
         }
     }];
}

-(void)imvLogo_Click
{
    if(vc_merchant_info == nil)
    {
        vc_merchant_info = [[Merchant_Info alloc]init];
    }
    vc_merchant_info.deal_controller = self.deal_controller;
    vc_merchant_info.merchant_controller = self.merchant_controller;
    vc_merchant_info.system_controller = self.system_controller;
    vc_merchant_info.hidesBottomBarWhenPushed = YES;
    
    if(![self.navigationController.topViewController isKindOfClass:[Merchant_Info class]])
    {
        [self.navigationController pushViewController:vc_merchant_info animated:YES];
    }
}

-(void)btnPhone_Click:(id)sender
{
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *phone_number = [[btnPhone.currentTitle componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"telprompt:", phone_number]]];
}

- (void)btnDirections_Click:(id)sender
{
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *destination_address = [[url_merchant_address componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@"+"];
    
    NSURL *google_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", @"comgooglemaps://?saddr=&daddr=", destination_address, @"&directionsmode=driving"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:google_url])
    {
        [[UIApplication sharedApplication] openURL:google_url];
    }
    else
    {
        NSURL *apple_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", @"http://maps.apple.com/?saddr=Current+Location&daddr=", destination_address, @"&directionsmode=driving"]];
        [[UIApplication sharedApplication] openURL:apple_url];
    }
}

-(void)btnWebsite_Click:(id)sender
{
    NSString *website = self.merchant_controller.merchant_obj.website;
    
    NSRange range = [website rangeOfString:@"http://"];
    
    if (range.location == NSNotFound)
        website = [NSString stringWithFormat:@"%@%@", @"http://", website];
    
    NSURL *url = [NSURL URLWithString:website];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)btnCreate_Click:(id)sender
{
    [self.view endEditing:YES];
    
    if(self.deal_controller.deal_obj.deal_id != nil)
        [self Progress_Show:@"Updating Deal"];
    else
        [self Progress_Show:@"Creating Deal"];
    
    /* image info here */
    NSData *stored_image_jpg_data = [NSData dataWithContentsOfFile:picked_image_file_name];
    NSString *image_base64 = [stored_image_jpg_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    self.deal_controller.deal_obj.image_base64 = image_base64;
    self.deal_controller.deal_obj.image = picked_image_file_name;
    [self.deal_controller Add_Deal:^(void)
     {
         successful = self.deal_controller.successful;
         system_successful_obj = self.deal_controller.system_successful_obj;
         system_error_obj = self.deal_controller.system_error_obj;
         
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
                     if(vc_deal_validate == nil)
                     {
                         vc_deal_validate = [[Deal_Validate alloc]init];
                     }
                     vc_deal_validate.calling_view = NSStringFromClass([self class]);
                     vc_deal_validate.deal_controller = self.deal_controller;
                     vc_deal_validate.merchant_controller = self.merchant_controller;
                     vc_deal_validate.system_controller = self.system_controller;
                     vc_deal_validate.hidesBottomBarWhenPushed = YES;
                    
                     if(![self.navigationController.topViewController isKindOfClass:[Deal_Validate class]])
                     {
                         [self.navigationController pushViewController:vc_deal_validate animated:YES];
                     }
                 }
             };
             
             [alert show];
         }
         else
         {
             if([system_error_obj.code isEqualToNumber:[NSNumber numberWithInt:2025]])
             {
                 GTAlertView *alert = [[GTAlertView alloc] initWithTitle:@"Credit Card" message:system_error_obj.message cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 
                 alert.completion = ^(BOOL cancelled, NSInteger buttonIndex)
                 {
                     if (cancelled)
                     {
                         Credit_Card_Add* vc_credit_card_add = [[Credit_Card_Add alloc]init];
                         vc_credit_card_add.deal_controller = self.deal_controller;
                         vc_credit_card_add.merchant_controller = self.merchant_controller;
                         vc_credit_card_add.system_controller = self.system_controller;
                         vc_credit_card_add.hidesBottomBarWhenPushed = YES;
                         vc_credit_card_add.screen_type = @"present";
                         //[vc_credit_card_add Initialize];
                         
                         UINavigationController *navigationController =
                         [[UINavigationController alloc] initWithRootViewController:vc_credit_card_add];
                         
                         [self presentViewController:navigationController animated:YES completion:^{}];
                     }
                 };
                 
                 [alert show];
             }
             else
             {
                 [self Show_Error];
             }
         }
     }];
}


@end
