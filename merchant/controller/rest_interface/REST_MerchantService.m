#import "REST_MerchantService.h"

@implementation REST_MerchantService

@synthesize web_service;

-(id)initWithService:(NSString *)web_service_config
{
	self = [super init];
	if(self)
	{
		self.web_service = web_service_config;
	}
	return self;
}


-(void)Get_Application_Settings:(Login_Log*)login_log_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"system/application_settings"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"login_log_obj": [login_log_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Application_Type objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Get_System_Settings:(System_Settings*)system_settings_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"system/system_settings"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"system_settings_obj": [system_settings_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [System_Settings objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Get_Industry_Parent_Level:(Industry*)industry_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"system/industry/parent"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"industry_obj": [industry_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSArray *dictionary_data = [res objectForKey:@"JSONResponse"][@"data_obj"];
					NSMutableArray *industry_obj_array = dictionary_data.count > 0 ? [NSMutableArray new] : nil;
					[dictionary_data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
						[industry_obj_array addObject:[Industry objectFromJSON:obj]];
					}];
					response.data_obj = industry_obj_array;

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Get_Neighborhood_By_Zip:(Zip_Code*)zip_code_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"system/neighborhood"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"zip_code_obj": [zip_code_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Zip_Code objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Get_Fine_Print_Options:(Login_Log*)login_log_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"system/fine_print_options"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"login_log_obj": [login_log_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSArray *dictionary_data = [res objectForKey:@"JSONResponse"][@"data_obj"];
					NSMutableArray *fine_print_option_obj_array = dictionary_data.count > 0 ? [NSMutableArray new] : nil;
					[dictionary_data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
						[fine_print_option_obj_array addObject:[Fine_Print_Option objectFromJSON:obj]];
					}];
					response.data_obj = fine_print_option_obj_array;

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Create_Validation:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/create_validation"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Validate:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/validate"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Merchant_Contact_Validation objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Register:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/register"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Merchant_Contact objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Login:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/login"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Merchant_Contact objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Forgot_Password:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/forgot_password"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Get_Merchant_Contact:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/details"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Merchant_Contact objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Update_Merchant:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/update"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Update_Merchant_Contact:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/update"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Add_Credit_Card:(Credit_Card*)credit_card_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/credit_card/add"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"credit_card_obj": [credit_card_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Credit_Card objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Delete_Credit_Card:(Credit_Card*)credit_card_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/credit_card/delete"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"credit_card_obj": [credit_card_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Set_Default_Credit_Card:(Credit_Card*)credit_card_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/credit_card/set_default"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"credit_card_obj": [credit_card_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Get_Credit_Cards:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/credit_card/get_all"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSArray *dictionary_data = [res objectForKey:@"JSONResponse"][@"data_obj"];
					NSMutableArray *credit_card_obj_array = dictionary_data.count > 0 ? [NSMutableArray new] : nil;
					[dictionary_data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
						[credit_card_obj_array addObject:[Credit_Card objectFromJSON:obj]];
					}];
					response.data_obj = credit_card_obj_array;

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Get_Default_Credit_Card:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"merchant/merchant_contact/credit_card/get_default"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Credit_Card objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Verify_Deal:(Deal*)deal_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"deal/verify"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"deal_obj": [deal_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Deal objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Add_Deal:(Deal*)deal_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"deal/add"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"deal_obj": [deal_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Deal objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Send_Deal_Validation:(Deal*)deal_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"deal/send_validation_code"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"deal_obj": [deal_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Validate_Deal:(Deal*)deal_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"deal/validate"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"deal_obj": [deal_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Get_Deals:(Merchant_Contact*)merchant_contact_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"deal/deals"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"merchant_contact_obj": [merchant_contact_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSArray *dictionary_data = [res objectForKey:@"JSONResponse"][@"data_obj"];
					NSMutableArray *deal_obj_array = dictionary_data.count > 0 ? [NSMutableArray new] : nil;
					[dictionary_data enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
						[deal_obj_array addObject:[Deal objectFromJSON:obj]];
					}];
					response.data_obj = deal_obj_array;

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Get_Deal_Details:(Deal*)deal_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"deal/detail"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"deal_obj": [deal_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Deal objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Cancel_Deal:(Deal*)deal_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"deal/cancel"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"deal_obj": [deal_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Lookup_Certificate:(Certificate*)certificate_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"deal/certificate/lookup"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"certificate_obj": [certificate_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					NSDictionary *dictionary_data = res[@"JSONResponse"][@"data_obj"];
					response.data_obj = [Certificate_Payment objectFromJSON:dictionary_data];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


-(void)Redeem_Certificate:(Certificate*)certificate_obj withResponse:(void (^)(JSONResponse *))completionBlock
{
	NSString *uri=[NSString stringWithFormat:@"deal/certificate/redeem"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", web_service, uri]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

	NSString *json_request = [@{@"certificate_obj": [certificate_obj jsonValue]} jsonString];
	NSData *json_data = [json_request dataUsingEncoding:NSUTF8StringEncoding];

	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [json_data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody: json_data];

	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
	{
		if(data == nil)
		{
			System_Error *system_error_obj = [[System_Error alloc]init];
			system_error_obj.code = @500;
			system_error_obj.message = @"Web service error.  Please check your internet connection";

			JSONErrorResponse *response = [JSONErrorResponse new];
			response.successful = NO;
			response.system_error_obj = system_error_obj;

			completionBlock(response);
		}
		else
		{
			NSError *_errorJson = nil;
			NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson];
			if (_errorJson != nil)
			{
				System_Error *system_error_obj = [[System_Error alloc]init];
				system_error_obj.code = @500;
				system_error_obj.message = @"Web service error.  Please check your internet connection";

				JSONErrorResponse *response = [JSONErrorResponse new];
				response.successful = NO;
				response.system_error_obj = system_error_obj;

				completionBlock(response);
			}
			else
			{
				NSNumber *successful = res[@"JSONResponse"][@"successful"];
				if (successful.boolValue)
				{
					JSONSuccessfulResponse *response = [JSONSuccessfulResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_success = res[@"JSONResponse"][@"system_successful_obj"];
					response.system_successful_obj = [System_Successful objectFromJSON:dictionary_success];

					completionBlock(response);
				}
				else
				{
					JSONErrorResponse *response = [JSONErrorResponse new];
					response.successful = [successful boolValue];

					NSDictionary *dictionary_error = res[@"JSONResponse"][@"system_error_obj"];
					response.system_error_obj = [System_Error objectFromJSON:dictionary_error];

					completionBlock(response);
				}
			}
		}
	}];
}


@end

