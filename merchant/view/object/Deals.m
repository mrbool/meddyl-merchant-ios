#import "Deals.h"


@interface Deals ()
{
    UITableView *tblDeals;
    UITableViewController *tableViewController;
    NSMutableArray *deal_obj_array;
}
@end


@implementation Deals

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screen_title = @"YOUR DEALS";
    self.left_button = @"";
    self.right_button = @"";
    
    [self Set_Controller_Properties];
    
    [self Create_Layout];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self Load_Deals];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [deal_obj_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat image_x;
    CGFloat image_y;
    CGFloat image_width;
    CGFloat image_height;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        image_x = self.screen_width * .57;
        image_y = self.screen_height * .025;
        image_width = self.screen_width * .4;
        image_height = self.screen_height * .2;
    }
    else
    {
        image_x = self.screen_width * .66;
        image_y = self.screen_height * .052;
        image_width = self.screen_width * .3125;
        image_height = self.screen_height * .14;
    }
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Deal *deal_obj = deal_obj_array[indexPath.row];
    
    UIView* viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, (self.gap * 5), self.screen_width, self.screen_height * .26)];
    viewCell.backgroundColor = [UIColor whiteColor];
    viewCell.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *time_zone = self.merchant_controller.merchant_contact_obj.merchant_obj.zip_code_obj.time_zone_obj.abbreviation;
    NSDate * entry_date_utc_stamp = deal_obj.entry_date_utc_stamp;
    NSDateFormatter *entry_date_format = [[NSDateFormatter alloc] init];
    [entry_date_format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:time_zone]];
    [entry_date_format setDateFormat:@"M/d/yyyy"];

    GTLabel *lblCreated = [Coding Create_Label:[NSString stringWithFormat: @"%@%@", @"Issued on ", [entry_date_format stringFromDate:entry_date_utc_stamp]] width:(self.screen_width * .8) font:label_font mult:YES];
    [Coding Add_View:viewCell view:lblCreated x:self.screen_indent_x height:lblCreated.frame.size.height prev_frame:CGRectNull gap:(self.gap * 3)];
    
    GTLabel *lblDeal = [Coding Create_Label:deal_obj.deal width:(self.screen_width * .8) font:text_field_font_medium_bold mult:YES];
    [Coding Add_View:viewCell view:lblDeal x:self.screen_indent_x height:lblDeal.frame.size.height prev_frame:lblCreated.frame gap:(self.gap * 1.25)];
    
    GTLabel *lblCerts = [Coding Create_Label:[NSString stringWithFormat: @"%@%@", [deal_obj.certificate_quantity stringValue], @" certificates issued"] width:(self.screen_width * .8) font:label_font mult:YES];
    [Coding Add_View:viewCell view:lblCerts x:self.screen_indent_x height:lblCerts.frame.size.height prev_frame:lblDeal.frame gap:(self.gap * 1.25)];
    
    GTLabel *lblStatus = [Coding Create_Label:deal_obj.deal_status_obj.status width:(self.screen_width * .8) font:text_field_font_medium_bold mult:YES];
    [Coding Add_View:viewCell view:lblStatus x:self.screen_indent_x height:lblStatus.frame.size.height prev_frame:lblCerts.frame gap:(self.gap * 1.25)];
    
    CGRect frmImage = CGRectMake(image_x, image_y, image_width, image_height);
    UIImageView *imgDeal = [[UIImageView alloc]initWithFrame:frmImage];
    [imgDeal sd_setImageWithURL:[NSURL URLWithString:deal_obj.image] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [viewCell addSubview:imgDeal];
    
    [cell.contentView addSubview:viewCell];
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.screen_height * .28;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Deal *deal_obj = [deal_obj_array objectAtIndex: indexPath.row];
    self.deal_controller.deal_obj = deal_obj;

    Deal_Info* vc_deal_info = [[Deal_Info alloc]init];
    vc_deal_info.deal_controller = self.deal_controller;
    vc_deal_info.merchant_controller = self.merchant_controller;
    vc_deal_info.system_controller = self.system_controller;
    vc_deal_info.hidesBottomBarWhenPushed = YES;

    if(![self.navigationController.topViewController isKindOfClass:[Deal_Info class]])
    {
        [self.navigationController pushViewController:vc_deal_info animated:YES];
    }
}

/* public methods */
-(void)Create_Layout
{
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    tblDeals = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tblDeals.delegate = self;
    tblDeals.dataSource = self;
    tblDeals.backgroundColor = [UIColor clearColor];
    tblDeals.separatorColor = [UIColor clearColor];
    tblDeals.showsVerticalScrollIndicator = NO;
    
    /* refresh control */
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -30, 0, 0)];
    refreshControl.backgroundColor = [UIColor colorWithRed:(51/255.0) green:(105/255.0) blue:(232/255.0) alpha:1];;
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(Load_Deals) forControlEvents:UIControlEventValueChanged];
    
    tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = tblDeals;
    tableViewController.refreshControl = refreshControl;
    
    /* not sure why to set this, but tab bar will be over last cell */
    tableViewController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    
    [self.view addSubview:tblDeals];
    
    self.navigationController.navigationBar.translucent= NO; // Set transparency to no and
    
    self.tabBarController.tabBar.translucent= NO; //Set this property so that the tab bar will not be transparent
}

-(void)Load_Deals
{
    [self Progress_Show:@"Loading Deals"];
    
    self.deal_controller.merchant_contact_obj = self.merchant_controller.merchant_contact_obj;
    [self.deal_controller Get_Deals:^(void)
     {
         successful = self.deal_controller.successful;
         system_successful_obj = self.deal_controller.system_successful_obj;
         system_error_obj = self.deal_controller.system_error_obj;
         
         if(successful)
         {
             deal_obj_array = self.deal_controller.deal_obj_array;
             
             [tblDeals reloadData];
             if (deal_obj_array)
             {
                 tblDeals.backgroundView = nil;
             }
             else
             {
                 UIFont* font_no_deals = [UIFont fontWithName:@"Palatino-Italic" size:(self.label_font_height * 1.25)];
                 
                 GTLabel *lblNoDeals = [Coding Create_Label:@"You have not posted any deals\n\nPull down to refresh\n\n" width:self.screen_width font:font_no_deals mult:YES];
                 lblNoDeals.frame = CGRectMake(0, self.screen_height/3, lblNoDeals.frame.size.width, lblNoDeals.frame.size.height);
                 [lblNoDeals setTextAlignment:NSTextAlignmentCenter];
                 
                 tblDeals.backgroundView = lblNoDeals;
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:system_error_obj.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         
         if (tableViewController.refreshControl.refreshing)
         {
             [tableViewController.refreshControl endRefreshing];
         }
         
         [self Progress_Close];
     }];
}

-(void)Create_Deal
{
    [self.tabBarController setSelectedIndex:1];
}

@end
