#import <UIKit/UIKit.h>

#import "Merchant_Controller.h"
#import "Main_View.h"
#import "ACPButton.h"
#import "GTTextField.h"
#import "NSString+FormatTextField.h"


@interface Navigation_Controller : UINavigationController
{
    BOOL successful;
    
    System_Error *system_error_obj;
    System_Successful *system_successful_obj;
}

@property (strong, nonatomic) Merchant_Controller *merchant_controller;

@end
