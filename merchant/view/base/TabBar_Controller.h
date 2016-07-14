#import <UIKit/UIKit.h>

#import "Account.h"
#import "Deal_Create.h"
#import "Certificate_Lookup.h"
#import "Deals.h"


@interface TabBar_Controller : UITabBarController <UITabBarControllerDelegate>

@property (strong, nonatomic) Deal_Controller *deal_controller;
@property (strong, nonatomic) Merchant_Controller *merchant_controller;
@property (strong, nonatomic) System_Controller *system_controller;

-(void) Set_Properties;

@end
