//
//  LinkAccountController.m
//  Stylelogue
//
//  Created by Quang Nguyen on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LinkAccountController.h"


@implementation LinkAccountController

@synthesize  password, user, newAPI;

- (id)initWithUserData:(UserData*)user
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.user = user;
        self.title = @"Login";
        UIButton *button = [UIButton numericPadButton:@"images/button.back.png"];
		[button setTitle:@"back" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		
		[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		self.navigationItem.leftBarButtonItem = favorite;
		[favorite release];
		
    }
    return self;
}

-(void)backFunction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [newAPI release];
    [user release];
    [password release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

-(void)removeKeyboard
{
    [self.password resignFirstResponder];
}

- (void)loadView
{
    [super loadView];
    
    UIButton *background = [UIButton buttonWithType:UIButtonTypeCustom];
    background.frame = self.view.bounds;
    [self.view addSubview:background];
    [background addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    label.backgroundColor = [UIColor clearColor];
    
    [label indentLeftBy:10];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    
    label.text = @"You already have a Stylelogue Account.";
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size: 18];
    label.textColor = [UIColor whiteColor];
    
    [self.view addSubview:label ];
    [label release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 320, 100)];
    label.backgroundColor = [UIColor clearColor];
    [label indentLeftBy:10];
    label.numberOfLines = 0;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.text = @"There is another account registered with this email address already in the system.";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size: 16];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    [label release];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"images/picture.png"]];
    [self.view addSubview:img];
    img.left = 40;
    img.top = 100;
    [img release];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(200, 480-300, 320, 100)];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.user.name;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size: 16];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    [label release];
    
    int f = 36;
    label.top = 100 - f;
    label.left = img.left + img.width + 5;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(200, 480-250, 320, 100)];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.user.email;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size: 16];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    [label release];
    
    label.top = 122 - f;
    label.left = img.left + img.width + 5;
    
    UIButton *bt;
    bt = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    bt.frame = CGRectMake(0, 480-200, 300, 50) ;
    [self.view addSubview:bt];
    bt.left = 320/2 - bt.width/2;
    bt.top = img.top + img.height + 5;
    bt.userInteractionEnabled = NO;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Password";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size: 16];
    label.textColor = [UIColor blackColor];
    [label indentLeftBy: 29];
    [bt addSubview:label];
    [label release];
    
    UITextField *pass = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 185, 25)] autorelease];
    [self.view addSubview:pass];
    self.password = pass;
    pass.delegate = self;
    pass.top = bt.top + bt.height/2 - pass.height/2;
    pass.secureTextEntry = YES;
    //pass.backgroundColor = [UIColor blackColor];
    pass.left = img.left + img.width + 25;
    
    bt = [UIButton buttonWithType: UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 480-150, 200, 50);
    [bt setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    [self.view addSubview:bt];
    bt.left = 320 - bt.width - 3;
    bt.top = pass.top + 30;
    [bt addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
    
    bt = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    bt.frame = CGRectMake(0, pass.top + 80, 300, 50);
    [bt setTitle:@"Link Accounts" forState:UIControlStateNormal];
    [self.view addSubview:bt];
    bt.left = 320/2 - bt.width/2;
    [bt addTarget:self action:@selector(linkAccount) forControlEvents:UIControlEventTouchUpInside];
    
    bt = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    bt.frame = CGRectMake(0, pass.top + 80 + 50 + 10, 300, 50) ;
    [bt setTitle:@"Not Now, Thanks" forState:UIControlStateNormal];
    [self.view addSubview:bt];
    bt.left = 320/2 - bt.width/2;
    [bt addTarget:self action:@selector(notNow) forControlEvents:UIControlEventTouchUpInside];    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)notNow
{
    XQDebug(@"\nnotnow\n");
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    [del popToMainMenu];
}

-(void)forgotPassword
{
    XQDebug(@"\nforgotPassword\n");
    ForgotPasswordController *controller = [[ForgotPasswordController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)newUserFailed:(NSString *)mess
{
    XQDebug(@"\nDisplay message here\n");
    
    [[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
    
    UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Error" message: mess delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

-(void)newDidLogin:(UserData *)info andMessage:(NSString *)mess
{   
    [[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
    
    AppMainNavigationController *mainController = (AppMainNavigationController *)self.navigationController;
	mainController.userID = info.authentication_token;
    
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    info.password = self.password.text;
    [del saveUserInfo:info];
    
    UISilentView *alertView = [[[UISilentView alloc] initWithTitle:@"Success!" message:mess delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
    [alertView show];
    return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    [del popToMainMenu];
}

-(void)linkAccount
{
    XQDebug(@"\nDid Login.......to Facebook\n");
	[[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
	[self.view addSubview:[SHKActivityIndicator currentIndicator]];
	[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Linking...")];
    [[SHKActivityIndicator currentIndicator] setTop:130];
    
    StylelogueAppDelegate *del = (StylelogueAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.newAPI = [[[NewAPI alloc] init] autorelease];
    self.newAPI.delegate = self;
    [self.newAPI slLinkAccount:self.password.text andFBAuthen:del.user.authentication_token andNormalAuthen:self.user.authentication_token];
    XQDebug(@"\nlinkAccount\n");
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
