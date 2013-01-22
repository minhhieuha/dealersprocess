
#import "LoginViewController.h"
#import "ColorDirective.h"
#import "UIViewExtension.h"
#import "FontLabelExtension.h"
#import "NSNotificationPoster.h"
#import "FontLabel.h"

#define LineStyle UITableViewCellSeparatorStyleNone
#define LOGINWITHFACEBOOK

@implementation LoginViewController

@synthesize loginCellTitle;
@synthesize FBUserID;
@synthesize tableView;
@synthesize api;
@synthesize la;
@synthesize lo;

- (id)init
{
	if (self = [super init]) {
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Login"];
	}
	return self;
}

- (void)loadView {
	
	[super loadView];
	UITableView *tableView = [[UITableView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain] ;
	[self setTableView:tableView];
	[tableView release];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	self.tableView.separatorStyle = LineStyle;
	self.tableView.separatorColor = [UIColor colorWithRed:0xff green:0xff blue:0xff alpha:0.1];
	
	[self.view addSubview:self.tableView];
	[self.tableView setDataSource:self];
	[self.tableView setDelegate:self];
	[self.tableView setBackgroundColor:[UIColor blackColor]];
	self.tableView.scrollEnabled = NO;
	self.view.backgroundColor = [UIColor clearColor];
	[self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

	[self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view addSubview:[SHKActivityIndicator currentIndicator]];
	[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Loading...")];
	[[SHKActivityIndicator currentIndicator] setTop:300];
}

-(void)viewLoading
{
    	[self goToMainScreen];
}

-(void)locationManager: (CLLocationManager *)manager didUpdateToLocation: (CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[manager stopUpdatingLocation];
	XQDebug(@"\nLoginViewController Latitude = %@\n Longitude = %@",[NSString stringWithFormat:@"%.7f",newLocation.coordinate.latitude],[NSString stringWithFormat:@"%.7f",newLocation.coordinate.longitude]);	
}

-(void)goToMainScreen{
	
	MainScreenViewContoller *mainViewController = [[MainScreenViewContoller alloc] init];
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    del.mainMenu = mainViewController;
	[self.navigationController pushViewController:mainViewController animated:YES];
	[mainViewController release];
}

#pragma mark DBRequestDelegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].hidden = NO;
	[[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
	[[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].hidden = NO;
	[[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
	
	[[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
	
	NSDictionary *dic = (NSDictionary*)result;
	XQDebug(@"\nResutl: %@\n", dic);
	
	FacebookInfo *info = [[FacebookInfo alloc] init];
	info.name = [dic objectForKey:@"name"];
	info.uid = [dic objectForKey:@"id"];
	info.location = [((NSDictionary*)[dic objectForKey:@"location"]) objectForKey:@"name"];
	
	StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
	del.fbuserinfo = info;
	self.api.userID = info.uid;
	self.api.userName = info.name;
	XQDebug(@"\nInfo of user: %@\n", info);
	StylelogueAppDelegate *dele = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	((APIController*)[APIController api]).userID = info.uid;
	((APIController*)[APIController api]).userName = info.name;
	((APIController*)[APIController api]).currentCity = info.location;
	
	AppMainNavigationController *mainController = (AppMainNavigationController *)self.navigationController;
	mainController.userID = info.uid;
	
	[[APIController api] createUser: dele.deviceToken];
	
	[info release];
	
	[self goToMainScreen];
}
#pragma mark ----

- (void)login {	

#ifdef LOGINWITHFACEBOOK
	
	XQDebug(@"\nBegin to login\n");
	NSArray* permissions =  [[NSArray arrayWithObjects: @"offline_access", @"read_stream", @"publish_stream", @"user_about_me", @"email",nil] retain];
	StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    XQDebug(@"\nfacebook accessloken: %@\n", del.facebook.accessToken);
	[del.facebook authorize:permissions delegate:self];
	[permissions release];	
	
#else

	FacebookInfo *info = [[FacebookInfo alloc] init];
	info.name = @"Quang Nguyen Xuan";
	info.uid = @"100001900168958";
	info.location = @"Singapore, Singapore";
	
	StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
	del.fbuserinfo = info;
	self.api.userID = info.uid;
	self.api.userName = info.name;
	XQDebug(@"\nInfo of user: %@\n", info);
	StylelogueAppDelegate *dele = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	((APIController*)[APIController api]).userID = info.uid;
	((APIController*)[APIController api]).userName = info.name;
	((APIController*)[APIController api]).currentCity = info.location;
	
	AppMainNavigationController *mainController = (AppMainNavigationController *)self.navigationController;
	mainController.userID = info.uid;
	
	[[APIController api] createUser: dele.deviceToken];
	
	[info release];
	
	[self goToMainScreen];
#endif
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}   

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UILabel *topLabel;
	UITextView *text;
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		if ([indexPath row] ==1) {
            
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		else if([indexPath row] ==0) {
			
			UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(cell.frame.origin.x + 10, cell.frame.origin.y + 150, 304,40)];
			img.image = [UIImage imageNamed:@"images/homescreen.logo.png"];
			[img setWidth:img.image.size.width];
			[img setHeight:img.image.size.height];
			[img setTop:img.top + 30];
			[img setLeft:(320-img.width)/2];
			[cell.contentView addSubview:img];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[img release];
		}
	}
	cell.backgroundColor = [UIColor blackColor];
	
	return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath row] == 1) {
		return 60;
	} else if ([indexPath row] == 0) {
		return 400;
	}
	return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)fbDidLogin
{
	[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].hidden = YES;
	[[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
	[self.view addSubview:[SHKActivityIndicator currentIndicator]];
	[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Loading...")];
	[[SHKActivityIndicator currentIndicator] setTop:300];
	
	StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    XQDebug(@"\nYou have login with facebook: Access token: %@\n", del.facebook.accessToken);
	[del.facebook requestWithGraphPath:@"me" andDelegate:self];
    
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	
	[[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];

	XQDebug(@"\nYou can not login with facebook\n");
}

- (void)fbDidLogout
{
	XQDebug(@"\nYou have logout Facebook\n");
}

- (void)viewWillAppear:(BOOL)animated
{	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	self.view.backgroundColor = [UIColor blackColor];
}

#pragma mark Did finish parsing delegate

-(void)didFinishParsing:(NSMutableArray *)parsedData
{
	AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
	[mainController setQuestions:parsedData];
	XQDebug(@"\n-------------Question count: %d---------------\n", [mainController.questions count]);
}

#pragma mark ---------------------------

- (void)dealloc {
	
	self.la = nil;
	self.lo = nil;
	self.tableView = nil;
	self.api = nil;
    [super dealloc];
}

@end
