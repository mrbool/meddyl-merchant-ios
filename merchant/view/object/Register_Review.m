//
//  Register_Review.m
//  merchant
//
//  Created by George Triarhos on 1/11/16.
//  Copyright © 2016 gtsoft. All rights reserved.
//

#import "Register_Review.h"

@interface Register_Review ()

@end

@implementation Register_Review

@synthesize btnRegister;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"REVIEW";
    self.left_button = @"back";
    self.right_button = @"next";
    
    [self Set_Controller_Properties];
    
    
    [btnRegister setStyleType:ACPButtonBlue];
    [btnRegister setLabelTextColor:[UIColor whiteColor] highlightedColor:[UIColor whiteColor] disableColor:nil];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnRegister_Click:(id)sender
{
    NSData *stored_image_jpg_data = [NSData dataWithContentsOfFile:self.merchant_controller.merchant_obj.image];
    NSString *image_base64 = [stored_image_jpg_data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    self.merchant_controller.merchant_obj.image_base64 = image_base64;
    self.merchant_controller.merchant_obj.image = @"hold.png";
    
    btnRegister.enabled = NO;
    [self Progress_Show:@"Registering"];
    
    [self.merchant_controller Register:^(void)
     {
         successful = self.merchant_controller.successful;
         system_successful_obj = self.merchant_controller.system_successful_obj;
         system_error_obj = self.merchant_controller.system_error_obj;
         
         [self Progress_Close];
         btnRegister.enabled = YES;
         
         if(successful)
         {
              TabBar_Controller *tc = [[TabBar_Controller alloc] init];
             tc.merchant_controller = self.merchant_controller;
             [tc Set_Properties];
              [self presentViewController:tc animated:YES completion:nil];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}


/* public properties */
-(void)Back_Click
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
