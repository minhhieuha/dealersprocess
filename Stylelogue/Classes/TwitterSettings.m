#import "TwitterSettings.h"

@implementation TwitterSettings

@synthesize userName;
@synthesize passWord;
@synthesize tableView;
@synthesize autoLogin;
@synthesize _userName;
@synthesize _password;
@synthesize _authen;
@synthesize _autoLogin;

- (id)init
{
	if (self = [super init]) {
		
		self.title = @"Twitter";
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Twitter"];
		
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
		

		[button addTarget:self action:@selector(haveSetConfigInfo) forControlEvents:UIControlEventTouchUpInside];
		favorite = [[UIBarButtonItem alloc] initWithCustomView:button];

		self.navigationItem.rightBarButtonItem = favorite;
		[favorite release];
	}
	return self;
}

-(void)haveSetConfigInfo
{
	
	if ([self.userName.text length] == 0 || [self.passWord.text length] == 0) {
		UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Confirmation" message:@"Please input the username and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	NSString *settingConfig = [NSString stringWithFormat:@"%@;%@;%d;%d;end", self.userName.text, self.passWord.text, 1, self.autoLogin.on];
	XQDebug(@"\nConfig infor: %@\n",settingConfig);
	NSError *error;
	BOOL succeed = [settingConfig writeToFile:[documentsDirectory stringByAppendingPathComponent:@"setting2.txt"]
								   atomically:YES encoding:NSUTF8StringEncoding error:&error];
	if (!succeed){
		XQDebug(@"\nError to write files\n");
	}
	
	AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
	mainController.goFrom = 2;
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)backFunction
{
	AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
	mainController.goFrom = 1;
	[self.navigationController  popViewControllerAnimated:YES];
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
	
	NSString *filesContent = [[[NSString alloc] initWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"setting2.txt"]] autorelease];
	if (filesContent) {
		self._userName = [[filesContent componentsSeparatedByString:@";"] objectAtIndex:0];
		self._password = [[filesContent componentsSeparatedByString:@";"] objectAtIndex:1];
		self._authen = [[[filesContent componentsSeparatedByString:@";"] objectAtIndex:2] intValue]==1?YES:NO;
		self._autoLogin = [[[filesContent componentsSeparatedByString:@";"] objectAtIndex:3] intValue]==1?YES:NO;
	}else {
		self._userName = @"";
		self._password = @"";
		self._authen = NO;
		self._autoLogin = NO;	
	}
}



#pragma mark Text View Delegate sesstion

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
	XQDebug(@"\ntext field<<<<<<<<-------------\n");
    if ([string isEqualToString:@"\n"]) {

        [textField resignFirstResponder];
		return NO;
	}
	return YES;
}

#pragma mark ---

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
	[self.userName resignFirstResponder];
	[self.passWord resignFirstResponder];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UILabel *topLabel;
	
	UITextField *s;
	UIView *v;
	UISwitch *sw;
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		topLabel = [[[UILabel alloc] initWithFrame: CGRectMake( cell.frame.origin.x + 20, cell.frame.origin.y + 7, tableView.bounds.size.width - 5,40)] autorelease];
		
		
		[cell.contentView addSubview:topLabel];
		
		topLabel.backgroundColor = [UIColor clearColor];
		
		[topLabel setFont:[UIFont fontWithName:FONT size:15]];
		[topLabel setTextColor:MAINCOLOR];
		topLabel.backgroundColor = [UIColor clearColor];
		
		//topLabel.highlightedTextColor = [UIColor blackColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		switch ([indexPath row]) {
			case 0:
				
				v = [UIView viewWithStretchableBackgroundImage:@"images/textfield.background.png" widthCap:11 andHeightCap:11];
				[v setFrame:CGRectMake(0, 0, 198, 30)];
				
				s = [[UITextField alloc] initWithFrame:CGRectInset(v.bounds, 4, 4)];
				[s setPlaceholder:@"username"];
				//s.text = self._userName;
				
				[s setDelegate:self];
				[self setUserName:s];
				[v addSubview:s];
				[s release];
				cell.accessoryView = v;
				topLabel.text = @"User ID:";
				break;
			case 1:
				
				v = [UIView viewWithStretchableBackgroundImage:@"images/textfield.background.png" widthCap:11 andHeightCap:11];
				[v setFrame:CGRectMake(0, 0, 198, 30)];
				
				s = [[UITextField alloc] initWithFrame:CGRectInset(v.bounds, 4, 4)];
				[s setPlaceholder:@"password"];
				//s.text = self._password;
				[s setSecureTextEntry:YES];
				[self setPassWord:s];
				[s setDelegate:self];
				[v addSubview:s];
				[s release];
				cell.accessoryView = v;
				topLabel.text = @"Password:";
				break;
			case 2:
				
				topLabel.text = @"We use XAuth, and never keep your username and password ourselves.";
				[topLabel setLineBreakMode:UILineBreakModeWordWrap];
				[topLabel setNumberOfLines:0];
				topLabel.textColor = DATECOLOR;
				[topLabel indentLeftBy:20];
				[topLabel setFont:[UIFont fontWithName:FONT size:15]];
				break;
			case 3:
				
				sw = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
				sw.on = self._autoLogin;
				cell.accessoryView = sw;
				[self setAutoLogin:sw];
				[sw release];
				topLabel.text = @"Follow@styleitnow";
				break;
		}
	}
	return cell;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	
	self._userName = nil;
	self._password = nil;
	self.autoLogin = nil;
	self.tableView = nil;
	self.userName = nil;
	self.passWord = nil;
    [super dealloc];
}


@end
