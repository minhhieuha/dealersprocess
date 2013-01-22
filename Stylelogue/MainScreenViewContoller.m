
#import "MainScreenViewContoller.h"
#import "UIViewGenerator.h"
#import "UIButtonExtension.h"
#import "TakePhotoLandingController.h"

#define LineStyle UITableViewCellSeparatorStyleSingleLine

@implementation MainScreenViewContoller

@synthesize tableView, loginToolBar;

- (id)init
{
	if (self = [super init]) {

		[self initBarButton];
		
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stylelogue.title.png"]] autorelease];//[FontLabel titleLabelNamed2:@"STYLELOGUE"];
		self.navigationItem.titleView.size = CGSizeMake(173, 22);
		[self.navigationItem setHidesBackButton:YES animated:YES];
		//button.logout.new.png
	}
	return self;
}

- (void)checkLogoutFunction
{
	UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to logout now?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Logout", nil];
	alertView.tag = 999;
	[alertView show];
	[alertView release];
}

-(void)initBarButton
{
    UIButton *button = [UIButton numericPadButton:@"images/button.hot.png"];
    [button setTitle:@"settings" forState:UIControlStateNormal];
    [button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
    button.titleLabel.textColor = MAINCOLOR;
    [button.titleLabel  setTextAlignment:UITextAlignmentCenter];
    
    [button addTarget:self action:@selector(settingFunction) forControlEvents:UIControlEventTouchUpInside];
	
    UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (del.fbuserinfo) {
        self.navigationItem.rightBarButtonItem = favorite;
    }else
        
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    [favorite release];
    
    button = [UIButton numericPadButton:@"images/button.back.png"];
    [button setTitle:@"logout" forState:UIControlStateNormal];
    [button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
    button.titleLabel.textColor = MAINCOLOR;
    [button.titleLabel  setTextAlignment:UITextAlignmentCenter];
    
    [button addTarget:self action:@selector(checkLogoutFunction) forControlEvents:UIControlEventTouchUpInside];
    
    favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    if (del.fbuserinfo) {
        self.navigationItem.leftBarButtonItem = favorite;
    }else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    [favorite release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		[self logoutFunction];
	}
}

-(void)logoutFunction
{
	StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    del.user.islogin = NO;
    [del saveUserInfo:nil];
    del.fbuserinfo = nil;
    [self initBarButton];
    self.loginToolBar.hidden = NO;
    [self.tableView reloadData];

    XQDebug(@"\n.........Logout Function.........\n");
}

-(void)settingFunction
{
	SettingsViewController *setting = [[SettingsViewController alloc] init];
	//setting.fbsession = self.fbsection;
	[self.navigationController pushViewController:setting animated:YES];
	[setting release];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	[super loadView];
	self.hidesBottomBarWhenPushed = YES;
	tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	[tableView setTop:tableView.top-10];

	tableView.separatorStyle = LineStyle;
	tableView.separatorColor = [UIColor colorWithRed:0xff green:0xff blue:0xff alpha:0.1];

	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	v.backgroundColor = [UIColor blackColor];
	[tableView setTableHeaderView:v];
	[tableView setTableFooterView:v];
	[v release];
	
	[self.view addSubview:tableView];
	[tableView setDataSource:self];
	[tableView setDelegate:self];
	[tableView setBackgroundColor:[UIColor blackColor]];
	tableView.scrollEnabled = NO;
	self.view.backgroundColor = [UIColor clearColor];
	[tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    
    UIView *loginToolbar = [[GradientView alloc] initWithFrame:CGRectMake(0, 357 , 320, 60)];
	[loginToolbar setBackgroundColor:[UIColor clearColor]];
	[loginToolbar setNeedsDisplay];
	[self.view addSubview:loginToolbar];
    
	UIButton *loginQuickOpinion = [UIButton numericPadButton:@"images/login.button.png"];
	[loginQuickOpinion addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
	[loginQuickOpinion setLeft:210  - 55 - loginQuickOpinion.width];
	[loginQuickOpinion setTop:(loginToolbar.height - loginQuickOpinion.height)/2];
	[loginToolbar addSubview:loginQuickOpinion];
    [loginQuickOpinion setTitle:@"Sign up" forState:UIControlStateNormal];
	UIButton *loginLooksbookButton = [UIButton numericPadButton: @"images/login.button.png"];
	[loginLooksbookButton addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
	
	[loginLooksbookButton setLeft:110 + 55];
	
	[loginLooksbookButton setTop:(loginToolbar.height - loginLooksbookButton.height)/2];
	[loginToolbar addSubview:loginLooksbookButton];
	[loginToolbar release];
    [loginLooksbookButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginQuickOpinion.titleLabel setFont:[UIFont fontWithName:FONTREGULAR size:LOGINSIZE]];
    [loginLooksbookButton.titleLabel setFont:[UIFont fontWithName:FONTREGULAR size:LOGINSIZE]];
    [loginQuickOpinion.titleLabel setTextColor: MAINCOLOR];
    [loginLooksbookButton.titleLabel setTextColor: MAINCOLOR];
    self.loginToolBar = loginToolbar;
    //check to show or not show login toolbar
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (del.fbuserinfo) {
        self.loginToolBar.hidden = YES;
    }else
    {
        self.loginToolBar.hidden = NO;
    }
}

-(void) signUp:(id)sender
{
    XQDebug(@"\n-(void) signUp:(id)sender\n");
    SignUpController *controller = [[SignUpController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void) signIn:(id)sender
{
    XQDebug(@"\n-(void) signIn:(id)sender\n");
    XQDebug(@"\n-(void) signUp:(id)sender\n");
    LoginController *controller = [[LoginController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)didFinishParsing:(NSMutableArray *)parsedData
{
	AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
	[mainController setQuestions:parsedData];
	XQDebug(@"\n-------------Question count: %d---------------\n", [mainController.questions count]);
}

-(void)changeToQuickOpinion
{
	StylelogueAppDelegate *myDelegate = (StylelogueAppDelegate *)[[UIApplication sharedApplication] delegate];
	[myDelegate changeViewController:self name:@"GetQuickOpinionsController"];
}

-(void)changeToGiveOpinion
{
	StylelogueAppDelegate *myDelegate = (StylelogueAppDelegate *)[[UIApplication sharedApplication] delegate];
	[myDelegate changeViewController:self name:@"RootViewController"];
}

-(void)changeToGiveOpinion2
{
	GiveOpinionControllerRecent *recent = [[GiveOpinionControllerRecent alloc] init];
	[self.navigationController pushViewController:recent animated:YES];
	[recent release];
}

-(void)changeToMyLooksBook
{
	MyLooksbookController *looksbookController = [[MyLooksbookController alloc] init];
	[self.navigationController pushViewController:looksbookController animated:YES];
	[looksbookController release];
}

-(void)changeToGoodies
{
	GoodyController *goodyController  = [[GoodyController alloc] init];
	[self.navigationController pushViewController:goodyController animated:YES];
	[goodyController release];
}

- (void)enterQuickOpinionLanding
{
	TakePhotoLandingController *quickOpinionLandingController = [[TakePhotoLandingController alloc] init];
	[self.navigationController pushViewController:quickOpinionLandingController animated:YES];
	[quickOpinionLandingController release];
}


-(void) changeToNotifications
{
	ViewLikedCommentedItems *viewNotification = [[ViewLikedCommentedItems alloc] init];
	[self.navigationController pushViewController:viewNotification animated:YES];
	[viewNotification release];	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (del.fbuserinfo) {
        
        switch ([indexPath row]) {

            case 0:
                [self enterQuickOpinionLanding];
                break;
            case 1:
                [self changeToGiveOpinion2];
                break;
            case 2:
                [self changeToMyLooksBook];
                break;
            case 3:
                [self changeToGoodies];
                break;
            case 4:
                [self changeToNotifications];
                break;

            default:
                break;
        }
    }else
    {
        switch ([indexPath row]) {

            case 0:
                [self changeToGiveOpinion2];
                break;
            case 1:
                [self changeToGoodies];
                break;
                
            default:
                break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (del.fbuserinfo) {
        return 5;
    }else
    {
     	return 2;   
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (del.fbuserinfo) {
        UILabel *topLabel;
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        TableCellHilightedView *selectedView = [[TableCellHilightedView alloc] initWithFrame:CGRectMake(-111, 0, cell.frame.size.width, cell.frame.size.height)];
        cell.selectedBackgroundView = selectedView;
        [selectedView release];
        
        TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:CGRectMake(-111, 0, cell.frame.size.width, cell.frame.size.height)];
        cell.backgroundView = backGroundView;
        //backGroundView.backgroundColor = [UIColor whiteColor];
        [backGroundView release];
        
        topLabel = [[[UILabel alloc] initWithFrame: CGRectMake(cell.frame.origin.x+55, cell.frame.origin.y + 14, tableView.bounds.size.width,40)] autorelease];
        [topLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
        [topLabel setTextColor:MAINCOLOR];
        [cell.contentView addSubview:topLabel];
        
        topLabel.backgroundColor = [UIColor clearColor];
        
        switch ([indexPath row]) {
            case 0:
                topLabel.text = @"Upload Style";
                cell.image = [UIImage imageNamed:@"images/icon.get.quick.opinion.png"];
                break;
            case 1:
                topLabel.text = @"Style Feed";
                cell.image = [UIImage imageNamed:@"images/icon.give.opinion.png"];
                break;
            case 2:
                topLabel.text = @"My Lookbook";
                cell.image = [UIImage imageNamed:@"images/icon.my.looksbook.png"];
                break;
            case 3:
                topLabel.text = @"Fashion Loots";
                cell.image = [UIImage imageNamed:@"images/icon.goodies.png"];
                break;
            case 4:
                topLabel.text = @"Notifications";
                cell.image = [UIImage imageNamed:@"images/icon.notification.png"];
                break;
        }
        
        
        cell.backgroundColor = [UIColor blackColor];
        
        return cell;
        
    }else
    {
        
        UILabel *topLabel;
        static NSString *CellIdentifier = @"Cell1";
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
        
        TableCellHilightedView *selectedView = [[TableCellHilightedView alloc] initWithFrame:CGRectMake(-111, 0, cell.frame.size.width, cell.frame.size.height)];
        cell.selectedBackgroundView = selectedView;
        [selectedView release];
        
        TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:CGRectMake(-111, 0, cell.frame.size.width, cell.frame.size.height)];
        cell.backgroundView = backGroundView;
        //backGroundView.backgroundColor = [UIColor whiteColor];
        [backGroundView release];
        
        topLabel = [[[UILabel alloc] initWithFrame: CGRectMake(cell.frame.origin.x+55, cell.frame.origin.y + 14, tableView.bounds.size.width,40)] autorelease];
        [topLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
        [topLabel setTextColor:MAINCOLOR];
        [cell.contentView addSubview:topLabel];
        
        topLabel.backgroundColor = [UIColor clearColor];
        
        switch ([indexPath row]) {
            case 0:
                topLabel.text = @"Style Feed";
                cell.image = [UIImage imageNamed:@"images/icon.give.opinion.png"];
                break;
            case 1:
                topLabel.text = @"Fashion Loots";
                cell.image = [UIImage imageNamed:@"images/icon.goodies.png"];
                break;
        } 
        
        cell.backgroundColor = [UIColor blackColor];
        
        return cell;
    }
	
}

-(void)fbDidLogin
{
	XQDebug(@"\nHello settings button\n");
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
		return 70;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	self.view.backgroundColor = [UIColor blackColor];
    [self initBarButton];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	
	self.tableView  = nil;
    self.loginToolBar = nil;
	[super dealloc];
}

@end
