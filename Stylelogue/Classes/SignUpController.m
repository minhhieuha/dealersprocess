//
//  GiveOpinionControllerRecent.m
//  Stylelogue
//
//  Created by Nguyen Xuan Quang on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignUpController.h"
#define kCustomRowHeight    60.0
#define kCustomRowCount     7
#define LineStyle UITableViewCellSeparatorStyleSingleLine
#define maxval(a,b) (a>b?a:b)
#define minval(a,b) (a<b?a:b)

@implementation SignUpController

@synthesize tableView;
@synthesize api, email, username, password, picture, image, sw, newAPI;

#pragma mark Init and Load View

- (id)init {
	
    if ((self = [super init])) {
        // Custom initialization
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Sign Up"];
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
        [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Registering...")];
        [[SHKActivityIndicator currentIndicator] setTop:185];
        XQDebug(@"\nCreate User................\n");
        self.newAPI = [[[NewAPI alloc] init] autorelease];
        self.newAPI.delegate = self;
        StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
        [self.newAPI slCreateNormalUser:self.email.text andName:self.username.text andPassword:self.password.text andAvatar: self.image andDeviceToken:del.deviceToken andUpdateFromStylelogue: self.sw.on];   
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
    
    
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    footer.backgroundColor = [UIColor clearColor];
    [footer setFont:[UIFont fontWithName:FONT size:16]];
    footer.numberOfLines = 0;
    [footer setTextColor:DATECOLOR];
    
    footer.textAlignment = UITextAlignmentCenter;
    [footer setLineBreakMode:UILineBreakModeWordWrap];
    footer.text = @"Once your account is created, you can\nupload styles, gain access to your\nlookbook and start interacting with style\nseekers from around the world.";
    tableView.tableFooterView = footer;
    [footer release];
	self.api = [APIController api];
//  [self.api setDelegate:self];
    
    self.email = [[[UITextField alloc] initWithFrame:CGRectMake( 0, 0 , 200, 100)] autorelease];
    self.email.autocorrectionType = UITextAutocorrectionTypeNo;
    self.username = [[[UITextField alloc] initWithFrame:CGRectMake( 0, 0 , 200, 100)] autorelease];
    self.password = [[[UITextField alloc] initWithFrame:CGRectMake( 0, 0 , 200, 100)] autorelease];
    UIButton *img = [UIButton numericPadButton:@"images/picture.png"];
    [img addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
    self.picture = img;
    self.sw = [[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
    [self.email becomeFirstResponder];
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
    }else if(!self.username.text)
    {
        UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Error" message:@"Please input your name" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        return YES;
    }
    return NO;
}


#pragma mark Parsing finish delegate

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
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 3) {
        return 60;
    }
	return 43;
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

        int h = 60;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Email";
            
                self.email.left = 110;
                self.email.top = h/2 - (h/2)/2 - 4;
                self.email.placeholder = @"email@example.com";
                self.email.textColor = [UIColor whiteColor];
                [self.email setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
                [self.email setTextColor:MAINCOLOR];
                [cell addSubview:self.email];
                break;
            case 1:
                cell.textLabel.text = @"Name";
                self.username.left = 110;
                self.username.top = h/2 - (h/2)/2 - 5;
                self.username.textColor = [UIColor whiteColor];
                [self.username setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
                [self.username setTextColor:MAINCOLOR];
                [cell addSubview:self.username];
                break;
            case 2:
                cell.textLabel.text = @"Password";
                self.password.left = 110;
                self.password.top = h/2 - (h/2)/2 - 5;
                self.password.textColor = [UIColor whiteColor];
                [self.password setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
                [self.password setTextColor:MAINCOLOR];
                [cell addSubview:self.password];
                self.password.secureTextEntry = YES;
                break;
            case 3:
                cell.textLabel.text = @"Picture";
                self.picture.left = 110;
                [self.picture addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
                self.picture.top = 60/2 - self.picture.height/2;
                [cell addSubview:self.picture];
                break;
                
            default:
                break;
        }
        return cell;   
    }else
    {
        
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        [cell.textLabel setFont:[UIFont fontWithName:FONT size:14]];
        [cell.textLabel setTextColor:MAINCOLOR];
        cell.textLabel.text = @"Get Updates From Stylelogue";
        [cell addSubview:self.sw];
        self.sw.left = 320 - 110;
        self.sw.top = 43/2 - self.sw.height/2;
        return cell;
        
    }
}

-(void) selectPhoto
{
    XQDebug(@"\nBegin to select photo for this user\n");
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Existing Photo", @"New Photo", nil] autorelease];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    XQDebug(@"\nindex: %d\n", buttonIndex);
    if (buttonIndex == 1) {
        
        [self takePhoto:nil];
        
    }else if (buttonIndex == 0)
    {
        [self photoFromLibrary:nil];
    }
}

#pragma UIImagePickercontroller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    XQDebug(@"\nImage size: %@\n", NSStringFromCGSize(image.size));   
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
	
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];	
    
    self.image = [image imageByScalingAndCroppingForSize:CGSizeMake(71, 71)];
    [self.picture setImage:self.image forState:UIControlStateNormal];
    [picker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];	
    
    [picker release];
}

#pragma mark - View lifecycle

-(void)photoFromLibrary:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
       UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self presentModalViewController:picker animated:NO];   
        picker.view.backgroundColor = [UIColor blackColor];        
    }
}

-(void)takePhoto:(id)sender
{    
    XQDebug(@"\n>>>>>>>>>>>>>>Hello world\n");
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self presentModalViewController:picker animated:NO];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.email resignFirstResponder];
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
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

- (void)dealloc {
    
	self.api = nil;
    self.newAPI = nil;
	self.tableView = nil;
    self.email = nil;
    self.username = nil;
    self.password = nil;
    self.picture = nil;
    self.sw = nil;
    self.image = nil;
    [super dealloc];
}
@end


