#import "Base_Controller.h"


@implementation Base_Controller

@synthesize successful, message, application_type_obj, login_log_obj;

- (id) init
{
    if( self = [super init] )
    {
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString* ip_address = [Utilities getIPAddress];
        
        merchant_service = @"https://api.meddyl.com/1.11/services/MerchantService.svc/";
        
        application_type_obj = [[Application_Type alloc] init];
        application_type_obj.application_type_id = [NSNumber numberWithInt:2];
        application_type_obj.version = version;
        
        login_log_obj = [[Login_Log alloc] init];
        login_log_obj.ip_address = ip_address;
        login_log_obj.application_type_obj = application_type_obj;
    }
    
    return self;
}

@end
