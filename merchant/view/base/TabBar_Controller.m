#import "TabBar_Controller.h"
#import "Navigation_Controller.h"


@interface TabBar_Controller ()
{
    Deals * deals;
    Deal_Create * deal_create;
    Certificate_Lookup * certificate_lookup;
    Account * account;
}
@end


@implementation TabBar_Controller

@synthesize deal_controller;
@synthesize merchant_controller;
@synthesize system_controller;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    deal_create.loaded = NO;
    deal_create.deal_controller.deal_obj=nil;
    
    return YES;
}

/* public methods */
-(void) Set_Properties
{
    deals = [[Deals alloc] init];
    deals.deal_controller = deal_controller;
    deals.merchant_controller = merchant_controller;
    deals.system_controller = system_controller;
    
    deal_create = [[Deal_Create alloc] init];
    deal_create.merchant_controller = merchant_controller;
    deal_create.deal_controller = deal_controller;
    deal_create.system_controller = system_controller;
    deal_create.hidesBottomBarWhenPushed=YES;
    
    certificate_lookup = [[Certificate_Lookup alloc] init];
    certificate_lookup.merchant_controller = merchant_controller;
    certificate_lookup.deal_controller = deal_controller;
    certificate_lookup.system_controller = system_controller;
    
    account = [[Account alloc] init];
    account.merchant_controller = merchant_controller;
    account.deal_controller = deal_controller;
    account.system_controller = system_controller;
    
    Navigation_Controller* navController0 = [[Navigation_Controller alloc] initWithRootViewController:deals];
    Navigation_Controller* navController1 = [[Navigation_Controller alloc] initWithRootViewController:deal_create];
    Navigation_Controller* navController2 = [[Navigation_Controller alloc] initWithRootViewController:certificate_lookup];
    Navigation_Controller* navController3 = [[Navigation_Controller alloc] initWithRootViewController:account];
    
    NSArray* controllers = [NSArray arrayWithObjects:navController0, navController1, navController2, navController3, nil];
    self.viewControllers = controllers;
    self.tabBar.opaque = YES;
    self.tabBar.translucent = NO;
    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:3];
    
    tabBarItem0.title = @"Your Deals";
    tabBarItem1.title = @"Create a Deal";
    tabBarItem2.title = @"Redeem";
    tabBarItem3.title = @"Account";
    
    [tabBarItem0 setImage:[[UIImage imageNamed:@"dollar_sign.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [tabBarItem1 setImage:[[UIImage imageNamed:@"create.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [tabBarItem2 setImage:[[UIImage imageNamed:@"redeem.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [tabBarItem3 setImage:[[UIImage imageNamed:@"profile.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
}

@end
