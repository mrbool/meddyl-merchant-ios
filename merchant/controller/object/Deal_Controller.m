#import "Deal_Controller.h"


@interface Deal_Controller()

@end


@implementation Deal_Controller

@synthesize application_type_obj_array;
@synthesize certificate_obj;
@synthesize certificate_obj_array;
@synthesize certificate_log_obj;
@synthesize certificate_log_obj_array;
@synthesize certificate_payment_obj;
@synthesize certificate_payment_obj_array;
@synthesize certificate_status_obj;
@synthesize certificate_status_obj_array;
@synthesize city_obj;
@synthesize city_obj_array;
@synthesize contact_obj;
@synthesize contact_obj_array;
@synthesize contact_gps_log_obj;
@synthesize contact_gps_log_obj_array;
@synthesize credit_card_obj;
@synthesize credit_card_obj_array;
@synthesize credit_card_type_obj;
@synthesize credit_card_type_obj_array;
@synthesize customer_obj;
@synthesize customer_obj_array;
@synthesize customer_search_location_type_obj;
@synthesize customer_search_location_type_obj_array;
@synthesize customer_status_obj;
@synthesize customer_status_obj_array;
@synthesize deal_obj;
@synthesize deal_obj_array;
@synthesize deal_fine_print_option_obj;
@synthesize deal_fine_print_option_obj_array;
@synthesize deal_log_obj;
@synthesize deal_log_obj_array;
@synthesize deal_payment_obj;
@synthesize deal_payment_obj_array;
@synthesize deal_status_obj;
@synthesize deal_status_obj_array;
@synthesize deal_validation_obj;
@synthesize deal_validation_obj_array;
@synthesize email_template_obj;
@synthesize email_template_obj_array;
@synthesize facebook_data_friends_obj;
@synthesize facebook_data_friends_obj_array;
@synthesize facebook_data_hometown_obj;
@synthesize facebook_data_hometown_obj_array;
@synthesize facebook_data_location_obj;
@synthesize facebook_data_location_obj_array;
@synthesize facebook_data_profile_obj;
@synthesize facebook_data_profile_obj_array;
@synthesize fine_print_option_obj;
@synthesize fine_print_option_obj_array;
@synthesize industry_obj;
@synthesize industry_obj_array;
@synthesize login_log_obj_array;
@synthesize merchant_obj;
@synthesize merchant_obj_array;
@synthesize merchant_contact_obj;
@synthesize merchant_contact_obj_array;
@synthesize merchant_contact_status_obj;
@synthesize merchant_contact_status_obj_array;
@synthesize merchant_contact_validation_obj;
@synthesize merchant_contact_validation_obj_array;
@synthesize merchant_rating_obj;
@synthesize merchant_rating_obj_array;
@synthesize merchant_status_obj;
@synthesize merchant_status_obj_array;
@synthesize neighborhood_obj;
@synthesize neighborhood_obj_array;
@synthesize password_reset_obj;
@synthesize password_reset_obj_array;
@synthesize password_reset_status_obj;
@synthesize password_reset_status_obj_array;
@synthesize payment_log_obj;
@synthesize payment_log_obj_array;
@synthesize plivo_phone_number_obj;
@synthesize plivo_phone_number_obj_array;
@synthesize promotion_obj;
@synthesize promotion_obj_array;
@synthesize promotion_activity_obj;
@synthesize promotion_activity_obj_array;
@synthesize promotion_type_obj;
@synthesize promotion_type_obj_array;
@synthesize sms_template_obj;
@synthesize sms_template_obj_array;
@synthesize state_obj;
@synthesize state_obj_array;
@synthesize system_error_obj;
@synthesize system_error_obj_array;
@synthesize system_settings_obj;
@synthesize system_settings_obj_array;
@synthesize system_successful_obj;
@synthesize system_successful_obj_array;
@synthesize time_zone_obj;
@synthesize time_zone_obj_array;
@synthesize twilio_phone_number_obj;
@synthesize twilio_phone_number_obj_array;
@synthesize zip_code_obj;
@synthesize zip_code_obj_array;


- (void)Verify_Deal:(void(^)(void))completionBlock
{
	system_error_obj = nil;
	system_successful_obj = nil;

	deal_obj.login_log_obj = self.login_log_obj;

	REST_MerchantService *i_rest = [[REST_MerchantService alloc] initWithService:merchant_service];
	[i_rest Verify_Deal: deal_obj withResponse:^(JSONResponse *response)
	{
		self.successful = response.successful;

		if (!self.successful)
		{
			system_error_obj = [[System_Error alloc] init];
			system_error_obj = ((JSONErrorResponse *)response).system_error_obj;
		}
		else
		{
			system_successful_obj = [[System_Successful alloc] init];
			system_successful_obj = ((JSONSuccessfulResponse *)response).system_successful_obj;

			Deal *deal_obj_hold = ((JSONSuccessfulResponse *)response).data_obj;
            
            deal_obj.deal = deal_obj_hold.deal;
            deal_obj.fine_print_ext = deal_obj_hold.fine_print_ext;
		}

		completionBlock();
	}];
}

- (void)Add_Deal:(void(^)(void))completionBlock
{
	system_error_obj = nil;
	system_successful_obj = nil;
    
    promotion_obj = [[Promotion alloc]init];
    promotion_obj.promotion_code = @"";
    
    promotion_activity_obj = [[Promotion_Activity alloc]init];
    promotion_activity_obj.promotion_obj = promotion_obj;
    
	deal_obj.login_log_obj = self.login_log_obj;
    deal_obj.promotion_activity_obj = promotion_activity_obj;

	REST_MerchantService *i_rest = [[REST_MerchantService alloc] initWithService:merchant_service];
	[i_rest Add_Deal: deal_obj withResponse:^(JSONResponse *response)
	{
		self.successful = response.successful;

		if (!self.successful)
		{
			system_error_obj = [[System_Error alloc] init];
			system_error_obj = ((JSONErrorResponse *)response).system_error_obj;
		}
		else
		{
			system_successful_obj = [[System_Successful alloc] init];
			system_successful_obj = ((JSONSuccessfulResponse *)response).system_successful_obj;

			deal_obj = ((JSONSuccessfulResponse *)response).data_obj;
		}

		completionBlock();
	}];
}

- (void)Send_Deal_Validation:(void(^)(void))completionBlock
{
    system_error_obj = nil;
    system_successful_obj = nil;
    
    deal_obj.login_log_obj = self.login_log_obj;
    deal_obj.merchant_contact_obj = merchant_contact_obj;
    
    REST_MerchantService *i_rest = [[REST_MerchantService alloc] initWithService:merchant_service];
    [i_rest Send_Deal_Validation: deal_obj withResponse:^(JSONResponse *response)
     {
         self.successful = response.successful;
         
         if (!self.successful)
         {
             system_error_obj = [[System_Error alloc] init];
             system_error_obj = ((JSONErrorResponse *)response).system_error_obj;
         }
         else
         {
             system_successful_obj = [[System_Successful alloc] init];
             system_successful_obj = ((JSONSuccessfulResponse *)response).system_successful_obj;
         }
         
         completionBlock();
     }];
}

- (void)Validate_Deal:(void(^)(void))completionBlock
{
	system_error_obj = nil;
	system_successful_obj = nil;

	deal_obj.login_log_obj = self.login_log_obj;
    deal_obj.merchant_contact_obj = merchant_contact_obj;
	deal_obj.deal_validation_obj = deal_validation_obj;

	REST_MerchantService *i_rest = [[REST_MerchantService alloc] initWithService:merchant_service];
	[i_rest Validate_Deal: deal_obj withResponse:^(JSONResponse *response)
	{
		self.successful = response.successful;

		if (!self.successful)
		{
			system_error_obj = [[System_Error alloc] init];
			system_error_obj = ((JSONErrorResponse *)response).system_error_obj;
		}
		else
		{
			system_successful_obj = [[System_Successful alloc] init];
			system_successful_obj = ((JSONSuccessfulResponse *)response).system_successful_obj;
		}

		completionBlock();
	}];
}

- (void)Get_Deals:(void(^)(void))completionBlock
{
	system_error_obj = nil;
	system_successful_obj = nil;

	merchant_contact_obj.login_log_obj = self.login_log_obj;

	REST_MerchantService *i_rest = [[REST_MerchantService alloc] initWithService:merchant_service];
	[i_rest Get_Deals: merchant_contact_obj withResponse:^(JSONResponse *response)
	{
		self.successful = response.successful;

		if (!self.successful)
		{
			system_error_obj = [[System_Error alloc] init];
			system_error_obj = ((JSONErrorResponse *)response).system_error_obj;
		}
		else
		{
			system_successful_obj = [[System_Successful alloc] init];
			system_successful_obj = ((JSONSuccessfulResponse *)response).system_successful_obj;

			deal_obj_array = ((JSONSuccessfulResponse *)response).data_obj;
		}

		completionBlock();
	}];
}

- (void)Get_Deal_Details:(void(^)(void))completionBlock
{
	system_error_obj = nil;
	system_successful_obj = nil;

	deal_obj = [[Deal alloc]init];

	deal_obj.login_log_obj = self.login_log_obj;

	REST_MerchantService *i_rest = [[REST_MerchantService alloc] initWithService:merchant_service];
	[i_rest Get_Deal_Details: deal_obj withResponse:^(JSONResponse *response)
	{
		self.successful = response.successful;

		if (!self.successful)
		{
			system_error_obj = [[System_Error alloc] init];
			system_error_obj = ((JSONErrorResponse *)response).system_error_obj;
		}
		else
		{
			system_successful_obj = [[System_Successful alloc] init];
			system_successful_obj = ((JSONSuccessfulResponse *)response).system_successful_obj;

			deal_obj = ((JSONSuccessfulResponse *)response).data_obj;
		}

		completionBlock();
	}];
}

- (void)Cancel_Deal:(void(^)(void))completionBlock
{
    system_error_obj = nil;
    system_successful_obj = nil;
    
    deal_obj.login_log_obj = self.login_log_obj;
    deal_obj.merchant_contact_obj = merchant_contact_obj;
    
    REST_MerchantService *i_rest = [[REST_MerchantService alloc] initWithService:merchant_service];
    [i_rest Cancel_Deal: deal_obj withResponse:^(JSONResponse *response)
     {
         self.successful = response.successful;
         
         if (!self.successful)
         {
             system_error_obj = [[System_Error alloc] init];
             system_error_obj = ((JSONErrorResponse *)response).system_error_obj;
         }
         else
         {
             system_successful_obj = [[System_Successful alloc] init];
             system_successful_obj = ((JSONSuccessfulResponse *)response).system_successful_obj;
         }
         
         completionBlock();
     }];
}

- (void)Lookup_Certificate:(void(^)(void))completionBlock
{
	system_error_obj = nil;
	system_successful_obj = nil;

    deal_obj = [[Deal alloc]init];
    deal_obj.merchant_contact_obj = merchant_contact_obj;
    
	certificate_obj.login_log_obj = self.login_log_obj;
    certificate_obj.deal_obj = deal_obj;

	REST_MerchantService *i_rest = [[REST_MerchantService alloc] initWithService:merchant_service];
	[i_rest Lookup_Certificate: certificate_obj withResponse:^(JSONResponse *response)
	{
		self.successful = response.successful;

		if (!self.successful)
		{
			system_error_obj = [[System_Error alloc] init];
			system_error_obj = ((JSONErrorResponse *)response).system_error_obj;
		}
		else
		{
			system_successful_obj = [[System_Successful alloc] init];
			system_successful_obj = ((JSONSuccessfulResponse *)response).system_successful_obj;

			certificate_payment_obj = ((JSONSuccessfulResponse *)response).data_obj;
            certificate_obj = certificate_payment_obj.certificate_obj;
            customer_obj = certificate_obj.customer_obj;
            deal_obj = certificate_obj.deal_obj;
		}

		completionBlock();
	}];
}

- (void)Redeem_Certificate:(void(^)(void))completionBlock
{
	system_error_obj = nil;
	system_successful_obj = nil;

    deal_obj = [[Deal alloc]init];
    deal_obj.merchant_contact_obj = merchant_contact_obj;
    
    certificate_obj.login_log_obj = self.login_log_obj;
    certificate_obj.deal_obj = deal_obj;

	REST_MerchantService *i_rest = [[REST_MerchantService alloc] initWithService:merchant_service];
	[i_rest Redeem_Certificate: certificate_obj withResponse:^(JSONResponse *response)
	{
		self.successful = response.successful;

		if (!self.successful)
		{
			system_error_obj = [[System_Error alloc] init];
			system_error_obj = ((JSONErrorResponse *)response).system_error_obj;
		}
		else
		{
			system_successful_obj = [[System_Successful alloc] init];
			system_successful_obj = ((JSONSuccessfulResponse *)response).system_successful_obj;
		}

		completionBlock();
	}];
}


@end
