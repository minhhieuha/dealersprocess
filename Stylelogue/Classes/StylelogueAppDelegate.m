//
//  StylelogueAppDelegate.m
//  Stylelogue
//
//  Created by Freddy Wang on 12/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "StylelogueAppDelegate.h"
#import "StylelogueViewController.h"
#import "UISilentView.h"
#import "SheetPickerView.h"
#import "UIImage+WhiteBorder.h"

@implementation StylelogueAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize mainNavController;
@synthesize api;
@synthesize deviceToken;
@synthesize deviceAlias;
@synthesize locationManager;
@synthesize latitude;
@synthesize longitude;
@synthesize delegate;
@synthesize facebook;
@synthesize fbuserinfo;
@synthesize user;
@synthesize mainMenu;
@synthesize  loginController;
//BOOL gLogging = TRUE;

#pragma mark Location manager Methods

- (void) timerTick: (NSTimer*)timer
{
	XQDebug(@"\nUpdate locatioin\n");
	[locationManager startUpdatingLocation];
}

- (void)locationManager: (CLLocationManager *)manager didUpdateToLocation: (CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[manager stopUpdatingLocation];
	self.latitude = newLocation.coordinate.latitude;
	self.longitude = newLocation.coordinate.longitude;
	XQDebug(@"\n Latitude = %@\n Longitude = %@",[NSString stringWithFormat:@"%.7f",newLocation.coordinate.latitude],[NSString stringWithFormat:@"%.7f",newLocation.coordinate.longitude]);	
	if (delegate) {
			[delegate locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
	}
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
	XQDebug(@"\nerror\n");
}

#pragma mark ---


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	
    [self loadUserInfo];
//NSString *params=[[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"contTag"];
	
//XQDebug(@"\n%@\n", [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]);
//	
//	
//	
//	UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Notification" message:[NSString stringWithFormat:@"Content of option:%@", [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"View", nil];
//	[alertView show];
//	[alertView release];
	
	
//	if ([params length] > 0 ) {//app launch when VIEW button of push notification clicked
//		XQDebug(@"\nThe view button have clicked<<<<<<<<<<<<================\n");
//	}
    // Add the view controller's view to the window and display.
    [window makeKeyAndVisible];


	AppMainNavigationController *appMainNavController = [[AppMainNavigationController alloc] init];
	appMainNavController.hidesBottomBarWhenPushed = YES;
	[window addSubview:appMainNavController.view];
	
	[appMainNavController.view setBackgroundColor:[UIColor blackColor]];
	[appMainNavController.view clampFlexibleMiddle];
	appMainNavController.navigationBar.tintColor = [UIColor blackColor];
	self.mainNavController = appMainNavController;

	LoginViewController *loginController = [[LoginViewController alloc] init];
	[appMainNavController pushViewController:loginController animated:NO];
	[appMainNavController release];
    self.loginController = loginController;
    [loginController release];
    
	[SheetPickerView anchorPickerTo:window];
	//NSBitmapImageRep
	
	//Register for notifications
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	// Reset badge number to 0
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.distanceFilter = kCLDistanceFilterNone;
	self.locationManager.delegate = self; // Tells the location manager to send updates to this object
	[locationManager startUpdatingLocation];
	//NSTimer *timer = [[NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES] retain];
	
	if ([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"])
	{
		[mainNavController setNavigationBarHidden:NO animated:NO];
		ViewLikedCommentedItems *viewNotification = [[ViewLikedCommentedItems alloc] init];
		[mainNavController pushViewController:viewNotification animated:YES];
		[viewNotification release];	
	}
	didEnterToBackground = NO;
	
	facebook = [[Facebook alloc] initWithAppId:SHKFacebookKey];
    
    [self setApi:[APIController api]];
	[self.api setDelegate:self];
	[self.api listQuestion:100 page:1];
    
	return YES;
}


-(void)didFinishParsingQuestions:(NSMutableArray*)parsedData
{
	[mainNavController setQuestions:parsedData];
	XQDebug(@"\n================-------------Question count: %d---------------\n", [mainNavController.questions count]);
    [self.loginController viewLoading];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"\nRequest is ok: %@\n", [request responseString]);
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"\nRequest failed: %@\n", [request responseString]);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	XQDebug(@"\n- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {\n");
    return [facebook handleOpenURL:url]; 
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)_deviceToken {

    // Get a hex string from the device token with no spaces or < >
    self.deviceToken = [[[[_deviceToken description]
						  stringByReplacingOccurrencesOfString: @"<" withString: @""] 
						 stringByReplacingOccurrencesOfString: @">" withString: @""] 
						stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	XQDebug(@"Device Token: %@", self.deviceToken);
	
	if ([application enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
		XQDebug(@"Notifications are disabled for this application. Not registering with Urban Airship");
		return;
	}
	
	mainNavController.deviceToken = self.deviceToken;
	    
    //self.deviceAlias = [userDefaults stringForKey: @"_UADeviceAliasKey"];
	
    //[[APIController api] registerTheDeviceInfo:self.deviceToken deviceAlias:self.mainNavController.userID];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
	
    XQDebug(@"Failed to register with error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
	
	XQDebug(@"\nContent of notification: %@\n", userInfo);
	NSString *message;
	int itemID=0;
	if ([[userInfo allKeys] containsObject:@"tags"]) {
		XQDebug(@"\n---->%@\n", [userInfo valueForKey:@"tags"]);
	}
	
	if ([[userInfo allKeys] containsObject:@"aps"]) { 
		
		if([[[userInfo objectForKey:@"aps"] allKeys] containsObject:@"alert"]) {
			
			NSDictionary *alertDict = [userInfo objectForKey:@"aps"];
			
			if ([[alertDict objectForKey:@"alert"] isKindOfClass:[NSString class]]) {
				// The alert is a single string message so we can display it
				message = [alertDict valueForKey:@"alert"];
				
			} else {
				// The alert is a a dictionary with more details, let's just get the message without localization
				// This should be customized to fit your message details or usage scenario
				message = [[alertDict valueForKey:@"alert"] valueForKey:@"body"];
			}
			
		} else {
			// There was no Alert content - there may be badge, sound or other info
			message = @"No Alert content";
		}
		
	} else {
		// There was no Apple Push content - there may be custom JSON	
		message = @"No APS content";
	}

	if ([mainNavController.visibleViewController isKindOfClass:[ViewLikedCommentedItems class]]) {
		return;
	}
	
	
	if (!didEnterToBackground) {
		UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Remote Notification" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"View", nil];
		[alertView show];
		[alertView release];
		didEnterToBackground = NO;
		return;
	}
	
	[mainNavController setNavigationBarHidden:NO animated:NO];
	ViewLikedCommentedItems *viewNotification = [[ViewLikedCommentedItems alloc] init];
	[mainNavController pushViewController:viewNotification animated:YES];
	[viewNotification release];	
	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		
		[mainNavController setNavigationBarHidden:NO animated:NO];
		ViewLikedCommentedItems *viewNotification = [[ViewLikedCommentedItems alloc] init];
		[mainNavController pushViewController:viewNotification animated:YES];
		[viewNotification release];
		return;
	}

	if(alertView.tag == 999)
	{
		[self.window setUserInteractionEnabled:YES];
		[[SHKActivityIndicator currentIndicator] hide];
		[[SHKActivityIndicator currentIndicator] removeFromSuperview];
		
		[self popViewsToSelectImage];
	}
}

-(void)popToMainMenu2
{
    self.fbuserinfo = nil;
    self.mainMenu.loginToolBar.hidden = NO;
    [self.mainMenu.tableView reloadData];
    int i = [self.mainNavController.viewControllers count];
    for (int k=0; k < i-3; k++) {
        [self.mainNavController popViewControllerAnimated:NO];
    }
    [self.mainNavController popViewControllerAnimated:YES];
}

-(void)popToMainMenu
{
    self.fbuserinfo = [[[FacebookInfo alloc] init] autorelease];
    self.mainMenu.loginToolBar.hidden = YES;
    [self.mainMenu.tableView reloadData];
    int i = [self.mainNavController.viewControllers count];
    for (int k=0; k < i-3; k++) {
        [self.mainNavController popViewControllerAnimated:NO];
    }
    [self.mainNavController popViewControllerAnimated:YES];
}

-(void)popViewsToSelectImage
{	
	[self.mainNavController popViewControllerAnimated:NO];
	[self.mainNavController popViewControllerAnimated:NO];
	[self.mainNavController popViewControllerAnimated:YES];
}

-(void)popViewsToLogin
{
	[self.mainNavController popViewControllerAnimated:NO];
	[self.mainNavController popViewControllerAnimated:YES];
}

-(void)uploadPhotoToServerInBackground:(UIImage*)thumnail originImage:(UIImage*)origin question:(NSString*)question additionalNote:(NSString*)additionalNote
{	
	[self.window setUserInteractionEnabled:NO];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *q = [[question retain] autorelease];
	NSString *n = [[additionalNote retain] autorelease];

	self.api = [APIController api];
	self.api.userID = mainNavController.userID;
	[self setApi:api];
	[api release];
	self.api.delegate = self;

	[self.api createItem2bis:thumnail originImage:[origin limitedToWidth:[NSNumber numberWithFloat:1024] andHeight:[NSNumber numberWithFloat:760]] longitude:self.longitude latitude:self.latitude question:q additionalNote:n];	

	[pool drain];
}

//this is a route function to all the view controler
-(void)changeViewController:(UIViewController*)controller name:(NSString*) ctrler
{

}

-(void)didFinishParsing:(NSMutableArray *)parsedData
{
	if (parsedData) {
		XQDebug(@"\nrespone data is: %d\n", [parsedData count]);
		Goody *gd = (Goody*)[parsedData objectAtIndex:0];
		SharePhotoPageController *sharer =  (SharePhotoPageController*)[mainNavController visibleViewController];
		sharer.url = gd.photo;
		sharer.give_opinion_url = gd.give_opinion_url;
		[self.window setUserInteractionEnabled:YES];
		[[SHKActivityIndicator currentIndicator] hide];
		[[SHKActivityIndicator currentIndicator] removeFromSuperview];
		
		UISilentView *alertView = [[[UISilentView alloc] initWithTitle:@"Upload" message:gd.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		
		alertView.tag = 999;
		[alertView show];
	}else {
		UISilentView *alertView = [[[UISilentView alloc] initWithTitle:@"Oops!" message:@"We can't connect to the internet right now. Check your network or try again in a minute!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alertView show];
		alertView.tag = 999;
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {

    XQDebug(@"\n- (void)applicationWillResignActive:(UIApplication *)application {\n");
    [self saveUserInfo:nil];
    XQDebug(@"\nUser info: %@\n", self.user);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	XQDebug(@"\n- (void)applicationDidEnterBackground:(UIApplication *)application {\n");
	
	didEnterToBackground = YES;
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    XQDebug(@"\n- (void)applicationWillEnterForeground:(UIApplication *)application {\n");
    [self loadUserInfo];
    
    XQDebug(@"\nUser info: %@\n", self.user);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	
	didEnterToBackground = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {

	XQDebug(@"\n------------------------->>>>>>>>>>>>>>>>>>>>>>- (void)applicationWillTerminate:(UIApplication *)application {\n");
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	NSString *filesContent = [[[NSString alloc] initWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"setting.txt"]] autorelease];
	if (filesContent) {
		BOOL on = [[[filesContent componentsSeparatedByString:@";"] objectAtIndex:0] intValue]==1?YES:NO;
		if (!on) {
			
			//[mainNavController.session logout];
		}else {
			XQDebug(@"\nAutologin\n");
		}
	}
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	XQDebug(@"\n- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {\n");
}


#pragma mark DBRequestDelegate

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{

	UISilentView *alertView = [[[UISilentView alloc] initWithTitle:@"Oops!" message:@"We can't connect to the internet right now. Check your network or try again in a minute!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alertView show];
	
	[self.window setUserInteractionEnabled:YES];
	[[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
	uploading = NO;
	
    XQDebug(@"\n---->>>>Commit photo is not ok: %@\n", error);
    
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
	[self.window setUserInteractionEnabled:YES];
	[[SHKActivityIndicator currentIndicator] displayCompleted:@"Shared!"];
	uploading = NO;
	XQDebug(@"\n---->>>Commit photo is ok: %@\n", (NSDictionary*)result);
}

#pragma mark ----

- (void)uploadPhoto:(NSString*)img comment:(NSString*)comment description:(NSString*)description {
	
	if (!uploading) {
		
		[self.window setUserInteractionEnabled:NO];
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Sharing...")];
		[[SHKActivityIndicator currentIndicator] setTop:185];//[[SHKActivityIndicator currentIndicator] setTop:130];
		
		uploading = YES;
        
		SBJSON *jsonWriter = [[SBJSON new] autorelease];
		
		NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
															   @"Stylelogue App",@"text",@"http://stylelogue.it/",@"href", nil], nil];
		
		
		NSString *imageSource = img, *stylelogueWebsite = description;
		
		NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
		XQDebug(@"\nimageSource: = %@\n", imageSource);
		NSDictionary* media = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"image", @"type", imageSource, @"src",stylelogueWebsite, @"href", nil],nil];
		
		NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSString stringWithFormat:@"%@'s photo", self.user.name], @"name",
									@"Curated by Stylelogue, to inspire and be inspired of the latest fashion trends, styles and loots.", @"description",
									@"www.stylelogue.it", @"caption",
									stylelogueWebsite, @"href", 
									media,@"media",nil];
		NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
		XQDebug(@"\nactionLinksStr==>  %@\n", actionLinksStr);
		XQDebug(@"\nattachmentStr==>  %@\n", attachmentStr);
		NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   comment,  @"message",
									   actionLinksStr, @"action_links",
									   attachmentStr, @"attachment",
									   nil];
        
        XQDebug(@"\n=======>>>>>>>paras: %@\n", params);
		[self.facebook requestWithMethodName:@"stream.publish" andParams:params andHttpMethod:@"POST" andDelegate:self];
	}
}

- (void)dialogDidComplete:(FBDialog *)dialog {
	XQDebug(@"publish successfully");
}

//{"name":"a long run","media": [{"type": "image", "src": "http://media.tinmoi.vn/2010/01/14/_228.jpg", "href": "http://media.tinmoi.vn/2010/01/14/_228.jpg"}],"href":"http://itsti.me/","caption":"The Facebook Running app","description":"it is fun"}

-(void)saveUserInfo:(UserData*)info
{
    if (info) {
        
        self.user = info;
        //save to file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
        
        NSString *file = [documentsDirectory stringByAppendingPathComponent:@"login.txt"];
        [SaveArrayCustomObject saveObjectToFile:self.user file: file];
    }else
    {
        //save to file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
        
        NSString *file = [documentsDirectory stringByAppendingPathComponent:@"login.txt"];
        [SaveArrayCustomObject saveObjectToFile:self.user file: file];
    }
}

-(void)loadUserInfo
{
    //save to file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory

    NSString *file = [documentsDirectory stringByAppendingPathComponent:@"login.txt"];
    self.user = [SaveArrayCustomObject loadObjectWithFile: file];
    XQDebug(@"\nUser infor: %@\n", self.user);
}

- (void)dealloc {

    self.loginController = nil;
    self.mainMenu = nil;
	self.locationManager = nil;
    self.viewController  = nil;
    self.user = nil;
    self.window = nil;
	self.mainNavController = nil;
	self.api = nil;
	self.deviceToken = nil;
	self.deviceAlias = nil;
	[facebook release];
	self.fbuserinfo = nil;
    [super dealloc];
}

@end
