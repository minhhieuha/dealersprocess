
#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize tableView;
//@synthesize fbsession;
@synthesize autoLogin;
@synthesize on;
@synthesize changeText;



-(void)aboutFunction:(id)sender
{
	XQDebug(@"\n-(void)aboutFunction:(id)sender\n");
	AboutController *about  = [[AboutController alloc] init];
	[self.navigationController pushViewController:about animated:YES];
	[about release];
}

- (id)init
{
	if (self = [super init]) {
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Settings"];
		
		UIButton *button = [UIButton numericPadButton:@"images/button.back.png"];
		[button setTitle:@"back" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		
		[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		self.navigationItem.leftBarButtonItem = favorite;
		[favorite release];
		
		
		button = [UIButton numericPadButton:@"images/button.hot.png"];
		[button setTitle:@"about" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		
		[button addTarget:self action:@selector(aboutFunction:) forControlEvents:UIControlEventTouchUpInside];
		favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		self.navigationItem.rightBarButtonItem = favorite;
		[favorite release];
	}
	return self;
}


-(void)backFunction
{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	NSString *settingConfig = [NSString stringWithFormat:@"%d;end", self.autoLogin.on?1:0];
	NSError *error;
	BOOL succeed = [settingConfig writeToFile:[documentsDirectory stringByAppendingPathComponent:@"setting.txt"]
												   atomically:YES encoding:NSUTF8StringEncoding error:&error];
	if (!succeed){
		XQDebug(@"\nError to write files\n");
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}



- (void)loadView {
	
	[super loadView];	
	self.view.backgroundColor = [UIColor blackColor];
	
	//begin to init the table view to show alll control to allow user to change all configs
	UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	[self setTableView:tableView];
	[tableView release];
	
	[self.view addSubview:self.tableView];
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	v.backgroundColor = [UIColor blackColor];
	[self.tableView setTableFooterView:v];
	[v release];
	
	self.tableView.backgroundColor = [UIColor clearColor];
	[self.tableView clampFlexibleMiddle];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.tableView.scrollEnabled = NO;
	
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	self.tableView.separatorColor = RGBACOLOR(0x22, 0x22, 0x22, 1);
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	NSString *filesContent = [[[NSString alloc] initWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"setting.txt"]] autorelease];
	if (filesContent) {
		self.on = [[[filesContent componentsSeparatedByString:@";"] objectAtIndex:0] intValue]==1?YES:NO;
	}else {
		self.on = NO;
	}
	
	AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
	mainController.goFrom = 0;

}


#pragma mark Delegate and Data Source for UITableView

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath row] == 3) {
		if ([self.changeText.text isEqualToString:@"unlink"]) {
			
			UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Confirmation" message:@"Unlink your Twitter account?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Unlink", nil];
			alertView.tag = 999;
			[alertView show];
			[alertView release];
		}else {
			
			XQDebug(@"\nHello World\n");
			TwitterSettings *twitterController;
			switch ([indexPath row]) {
					
				case 3:
					twitterController = [[TwitterSettings alloc] init];
					[self.navigationController pushViewController:twitterController animated:YES];
					[twitterController release];
					break;
			}
		}
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	XQDebug(@"\nHEllo\n");
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UILabel *topLabel;
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
		
	topLabel = [[[UILabel alloc] initWithFrame: CGRectMake( cell.frame.origin.x + 20, cell.frame.origin.y + 7, tableView.bounds.size.width,40)] autorelease];
	[topLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
	[topLabel setTextColor:MAINCOLOR];
	topLabel.backgroundColor = [UIColor clearColor];
	
	if ([indexPath row] == 3) {
		
		TableCellHilightedView *selectedView = [[TableCellHilightedView alloc] initWithFrame:CGRectMake(-555, 0, cell.frame.size.width, cell.frame.size.height)];
		cell.selectedBackgroundView = selectedView;
		[selectedView release];
		
		TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:CGRectMake(-555, 0, cell.frame.size.width, cell.frame.size.height)];
		cell.backgroundView = backGroundView;
		[backGroundView release];
		
		topLabel.text = @"Twitter";
		[cell.contentView addSubview:topLabel];
		
		topLabel = [[[UILabel alloc] initWithFrame: CGRectMake( 235, cell.frame.origin.y + 7, tableView.bounds.size.width,40)] autorelease];

		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = DATECOLOR;
		[topLabel setFont:[UIFont fontWithName:FONT size:15]];
		topLabel.tag == 999;
		topLabel.text = @"configure";			
		[self setChangeText:topLabel];
		[cell.contentView addSubview:topLabel];
		
	}else {
		
		UIButton *button;
		UISwitch *s;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		switch ([indexPath row]) {
			case 0:
				
				s = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
				[self setAutoLogin:s];
				[s release];
				self.autoLogin.on = self.on;
				cell.accessoryView = self.autoLogin;
				topLabel.text = @"Auto-login";
				break;
			case 1:
				
				button = [UIButton numericPadButton:@"images/button.logout.png"];
				[button setTitle:@"logout" forState:UIControlStateNormal];
				[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
				button.titleLabel.textColor = MAINCOLOR;
				[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
				
				[button addTarget:self action:@selector(logoutFacebook) forControlEvents:UIControlEventTouchUpInside];
				cell.accessoryView = button;
				topLabel.text = @"Logout";
				break;
			case 2:
				
				topLabel.text = @"Edit sharing settings";
				topLabel.textColor = DATECOLOR;
				[topLabel setFont:[UIFont fontWithName:FONT size:15]];
				break;
		}
		
		[cell.contentView addSubview:topLabel];
	}
	return cell;
}

- (void)logoutFacebook
{
	UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to sign out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	[alertView show];
	[alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		if (alertView.tag == 999) {
			[SHKTwitter logout];
			[self.changeText setLeft:self.changeText.left - 20];
			self.changeText.text = @"configure";
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];	
		}else {
			[self logoutFacebookConfirmed];
		}
	}else {
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];	
	}

}

- (void)logoutFacebookConfirmed
{
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    [del popToMainMenu2];
}

- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
	if (mainController.goFrom == 2) {
		
		[self.changeText setLeft:self.changeText.left + 20];
		changeText.text = @"unlink";
	}
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];	
}

- (void)viewDidUnload {
	
    [super viewDidUnload];
}

- (void)dealloc {
	
	self.changeText = nil;
	self.tableView = nil;
	//self.fbsession = nil;
	self.autoLogin = nil;
    [super dealloc];
}


@end
