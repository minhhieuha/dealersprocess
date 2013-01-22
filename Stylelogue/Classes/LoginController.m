//
//  GiveOpinionControllerRecent.m
//  Stylelogue
//
//  Created by Nguyen Xuan Quang on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"

#define kCustomRowHeight    60.0
#define kCustomRowCount     7
#define LineStyle UITableViewCellSeparatorStyleSingleLine
#define maxval(a,b) (a>b?a:b)
#define minval(a,b) (a<b?a:b)

@implementation LoginController

@synthesize tableView;
@synthesize api, email, password , image, newAPI;

#pragma mark Init and Load View

- (id)init {
	
    if ((self = [super init])) {
        // Custom initialization
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Login"];
		//[self.navigationItem setHidesBackButton:YES animated:YES];
		UIButton *button = [UIButton numericPadButton:@"images/button.back.png"];
		[button setTitle:@"back" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		
		[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		self.navigationItem.leftBarButtonItem = favorite;
		[favorite release];
		
		button = [UIButton numericPadButton:@"images/button.done.png"];
		[button setTitle:@"done" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		
		[button addTarget:self action:@selector(beginToCreateUser) forControlEvents:UIControlEventTouchUpInside];
		favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		self.navigationItem.rightBarButtonItem = favorite;
		[favorite release];
    }
    return self;
}

-(void)beginToCreateUser
{
     if (![self checkMissingFields]) {
        [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
        [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Login...")];
        [[SHKActivityIndicator currentIndicator] setTop:185];
        XQDebug(@"\nCreate User................\n");
        self.newAPI = [[[NewAPI alloc] init] autorelease];
        self.newAPI.delegate = self;
        StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
        [self.newAPI slLoginNormalUser:self.email.text andPassword: self.password.text andDeviceToken: del.deviceToken];
     }
}

-(void)backFunction
{
	[self.navigationController popViewControllerAnimated:YES];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];
    
	UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	[self setTableView:tableView];
	[tableView release];
    
	self.tableView.backgroundColor = [UIColor blackColor];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.separatorColor = [UIColor colorWithRed:0xff green:0xff blue:0xff alpha:0.1];
	[self.view addSubview:self.tableView];
    
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    footer.backgroundColor = [UIColor clearColor];
    [footer setFont:[UIFont fontWithName:FONT size:16]];
    footer.numberOfLines = 0;
    [footer setTextColor:DATECOLOR];
    footer.textAlignment = UITextAlignmentCenter;
    [footer setLineBreakMode:UILineBreakModeWordWrap];
    footer.text = @"You can also login to Stylelogue by connecting with facebook.";
    //tableView.tableFooterView = footer;
    //footer.hidden = YES;
    
    UIButton *bt = [UIButton numericPadButton:@"icon.facebook.png"];
    [bt addTarget:self action:@selector(connectToFacebook) forControlEvents:UIControlEventTouchUpInside];
    //bt.hidden = YES;
    [self.tableView addSubview:bt];
    bt.hidden = YES;
    bt.left = tableView.width/2 - bt.width/2;
    
    bt.top = tableView.height - 200;
    
    [footer release];
	self.api = [APIController api];
///[self.api setDelegate:self];
    
    self.email = [[[UITextField alloc] initWithFrame:CGRectMake( 0, 0 , 200, 100)] autorelease];
    self.email.autocorrectionType = UITextAutocorrectionTypeNo;
    //[self.email becomeFirstResponder];
    self.password = [[[UITextField alloc] initWithFrame:CGRectMake( 0, 0 , 200, 100)] autorelease];
}

#pragma mark DBRequestDelegate

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	[[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
	[[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
	NSDictionary *dic = (NSDictionary*)result;
	XQDebug(@"\nResutl: %@\n", dic);
	
	FacebookInfo *info = [[FacebookInfo alloc] init];
	info.name = [dic objectForKey:@"name"];
	info.uid = [dic objectForKey:@"id"];
	info.location = [((NSDictionary*)[dic objectForKey:@"location"]) objectForKey:@"name"];
    
    XQDebug(@"\nSend facebook info to server\n");
    
    self.newAPI = [[[NewAPI alloc] init] autorelease];
    self.newAPI.delegate = self;
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.newAPI slcreateUser: info.uid andName:info.name andCity:info.location andDeviceToken: del.deviceToken andUpdateFromStylelogue: YES];
    [info release];
}
#pragma mark ----
-(void)checkToFacebookIsDone:(NSDictionary*)dic
{
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
	
	[[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
	
    XQDebug(@"\nDic Info: %@\n", dic);
    
    //check with_existing_account
    XQDebug(@"\nwith_existing_account=%@\n", [dic objectForKey:@"with_existing_account"]);
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    del.user = [[[UserData alloc] init] autorelease];
    del.user.avatar_url = [dic objectForKey:@"avatar_url"];
    del.user.authentication_token = [dic objectForKey:@"authentication_token"];
    del.user.email = [dic objectForKey:@"email"];
    del.user.name = [dic objectForKey:@"name"];
    del.user.user_id = [[dic objectForKey:@"user_id"] intValue];
    [del saveUserInfo:nil];
    
    AppMainNavigationController *mainController = (AppMainNavigationController *)self.navigationController;
	mainController.userID = del.user.authentication_token;
    
    XQDebug(@"del.user: %@", del.user);
    
    NSString *existing = [dic objectForKey:@"with_existing_account"];
    if ([existing isEqualToString:@"false"]) {
        //go to create account
        CompleteRegistration *controler = [[CompleteRegistration alloc] init];
        [self.navigationController pushViewController:controler animated:YES];
        [controler release];
    }else
    {
        //go to main menu
        [del popToMainMenu];
    }
}

- (void)fbDidLogin
{
    XQDebug(@"\nDid Login.......to Facebook\n");
	[[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
	[self.view addSubview:[SHKActivityIndicator currentIndicator]];
	[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Checking...")];
	[[SHKActivityIndicator currentIndicator] setTop:100];
	
	StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
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

-(void) connectToFacebook
{
    XQDebug(@"\nBegin to login\n");
	NSArray* permissions =  [[NSArray arrayWithObjects: @"offline_access", @"read_stream", @"publish_stream", @"user_about_me", @"email",nil] retain];
	StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
	[del.facebook authorize:permissions delegate:self];
	[permissions release];	
}


-(BOOL)checkMissingFields
{
    if (!self.email.text) {
        
        UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Error" message:@"Please input your email" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        return YES;
    }else if(!self.password.text)
    {
        UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Error" message:@"Please input your password" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        return YES;
    }
    return NO;
}

#pragma NewdidFinishParing

-(void)newUserHaveExisted:(NSString * )mess
{
    [[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
    
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
    UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Error" message:mess delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
	[alertView show];
	[alertView release];
}

-(void)newDidLogin:(UserData *)info
{    
    
    [[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
    
    AppMainNavigationController *mainController = (AppMainNavigationController *)self.navigationController;
	mainController.userID = info.authentication_token;
    
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    info.password = self.password.text;
    [del saveUserInfo:info];
    [del popToMainMenu];
}

#pragma mark Table view creation (UITableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 1;
    }
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 3) {
        return 60;
    }
	return 43;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XQDebug(@"\nindex: %d, section: %d\n", indexPath.row, indexPath.section);
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        ForgotPasswordController *controller = [[ForgotPasswordController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }else if(indexPath.section == 2 && indexPath.row == 0)
    {
        [self connectToFacebook];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        footer.backgroundColor = [UIColor clearColor];
        [footer setFont:[UIFont fontWithName:FONT size:16]];
        footer.numberOfLines = 0;
        [footer setTextColor:DATECOLOR];
        footer.textAlignment = UITextAlignmentCenter;
        [footer setLineBreakMode:UILineBreakModeWordWrap];
        footer.text = @"You can also login to Stylelogue by connecting with facebook.";
        return [footer autorelease];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *CellIdentifier = @"Cell0";
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.textLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
        [cell.textLabel setTextColor:MAINCOLOR];
        UITextField *textField = nil;
        UIButton *img = nil;
        int h = 60;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Email";
                self.email.left = 110;
                self.email.top = h/2 - (h/2)/2 - 4;
                self.email.textColor = [UIColor whiteColor];
                [self.email setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
                [self.email setTextColor:MAINCOLOR];
                [cell addSubview:self.email];
                break;
            case 1:
                cell.textLabel.text = @"Password";
                
                self.password.left = 110;
                self.password.top = h/2 - (h/2)/2 - 5;
                self.password.textColor = [UIColor whiteColor];
                [self.password setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
                [self.password setTextColor:MAINCOLOR];
                [cell addSubview:self.password];
                self.password.secureTextEntry = YES;
                break;
            default:
                break;
        }
        return cell;   
    }else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images/arrow.png"]];
        cell.accessoryView = img;
        [img release];
        
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        
        [cell.textLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
        [cell.textLabel setTextColor:MAINCOLOR];
        cell.textLabel.text = @"Forgot your password?";
        return cell;
    }else if(indexPath.section == 2)
    {
        
        
        
        
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images/arrow.png"]];
        cell.accessoryView = img;
        [img release];
        
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        
        [cell.textLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
        [cell.textLabel setTextColor:MAINCOLOR];
        cell.textLabel.text = @"Connect with Facebook";
        return cell;
    }
}

-(void) selectPhoto
{
    XQDebug(@"\nBegin to select photo for this user\n");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

-(void)cancelDownloading
{
    
}

#pragma mark Table cell image support

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

- (void)dealloc {
    
    self.newAPI = nil;
	self.api = nil;
	self.tableView = nil;
    self.email = nil;
    self.password = nil;
    self.image = nil;
    [super dealloc];
}
@end


