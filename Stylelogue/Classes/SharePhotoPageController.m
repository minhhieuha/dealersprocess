    //
//  SharePhotoPageController.m
//  Stylelogue
//


//

#import "SharePhotoPageController.h"


@implementation SharePhotoPageController
@synthesize selectedImage;
@synthesize thumnailImage;
@synthesize backgoundImage;
@synthesize times;
@synthesize tableView;
@synthesize textToShare;
@synthesize url;
@synthesize give_opinion_url;
@synthesize photo;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init{
    if ((self = [super init])) {
        // Custom initialization
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Share"];
		
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


- (id)initWithImage:(UIImage *)image thumbail:(UIImage*)thumnail times:(BOOL) times itemID:(int)itemID
{	

	self = [super init];
	self.selectedImage = image;
	self.thumnailImage = thumnail;
	self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Share"];
	self.times = times;
	
	UIButton *button = [UIButton numericPadButton:@"images/button.back.png"];
	[button setTitle:@"back" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	
	[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.leftBarButtonItem = favorite;
	[favorite release];
	
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];
	
	UIImageView *backgoundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[self setBackgoundImage:backgoundImage];
	[backgoundImage release];
	self.backgoundImage.image = self.selectedImage;
	[self.backgoundImage setAlpha:0.2];
	[self.view addSubview:self.backgoundImage];
	
	UITableView *tableView = [[UITableView alloc] init];
	[self setTableView:tableView];
	[tableView release];
	[self.view addSubview:self.tableView];
	self.tableView.backgroundColor = [UIColor clearColor];
	[self.tableView setFrame:self.view.bounds];
	[self.tableView clampFlexibleMiddle];
	[self.tableView setTop:self.tableView.top-10];
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	v.backgroundColor = [UIColor clearColor];
	[self.tableView setTableHeaderView:v];
	[self.tableView setTableFooterView:v];
	[v release];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.tableView.scrollEnabled = NO;
	
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	self.tableView.separatorColor = RGBACOLOR(0x22, 0x22, 0x22, 1);
	if (times) {
		[self.view addSubview:[SHKActivityIndicator currentIndicator]];
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Uploading...")];
		[[SHKActivityIndicator currentIndicator] setTop:130];
	}
	
	//pag control
	pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(320/2-50, 380, 100, 20)] autorelease];
	[self.view addSubview:pageControl];
	pageControl.numberOfPages = 3;
	pageControl.currentPage = 2;
	[pageControl setUserInteractionEnabled:NO];
}

- (void)removePageControl
{
	if (pageControl) {
		[pageControl removeFromSuperview];
	}
}

-(void)backFunction
{
	if (times) {
		XQDebug(@"\nPop Pop.....\n");
		StylelogueAppDelegate* del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
		[del popViewsToSelectImage];
	}else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark Delegate and Data Source for UITableView

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UILabel *topLabel;
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		TableCellHilightedView *selectedView = [[TableCellHilightedView alloc] initWithFrame:cell.frame];
		cell.selectedBackgroundView = selectedView;
		selectedView.backgroundColor = [UIColor clearColor];
		[selectedView release];
		
		TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:cell.frame];
		cell.backgroundView = backGroundView;
		backGroundView.backgroundColor = [UIColor clearColor];
		[backGroundView release];
		topLabel = [[[UILabel alloc] initWithFrame: CGRectMake( cell.frame.origin.x+20, cell.frame.origin.y + 10, tableView.bounds.size.width,40)] autorelease];

		[cell.contentView addSubview:topLabel];
		
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.tag = 111;
		topLabel.textColor = [UIColor whiteColor];
		
		[topLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
		[topLabel setTextColor:MAINCOLOR];

		
		switch ([indexPath row]) {
			case 0:
				topLabel.text = @"Share it on Facebook";
				break;
			case 1:
				topLabel.text = @"Share it on Twitter";
				break;
			case 2:
				topLabel.text = @"Email to my Friends";
				break;
		}
	}
	
	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}


- (void)fbDidLogin
{
	StylelogueAppDelegate *de = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    XQDebug(@"\n................self.give_opinion_url=%@\n", self.give_opinion_url);
    XQDebug(@"\n................self.url=%@\n", self.url);
	[de uploadPhoto:self.url comment:self.textToShare description:self.give_opinion_url];
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

- (void)emailToMyFriend
{
	SHKItem *item = [SHKItem image:[self.selectedImage  imageByScalingAndCroppingForSize: CGSizeMake(115, (115/self.selectedImage.size.width)*self.selectedImage.size.height) ] title:[NSString stringWithFormat:@"[Stylelogue] %@", self.textToShare]];
	item.text =[NSString stringWithFormat: @"<a href=\"%@\">[see full image]</a><br><br>-----------<br>Style incubator that breeds only the finest fashion virtuosos.", self.give_opinion_url];
	[SHKMail shareItem:item];
}

- (void)shareOnFacebook
{	
    
    XQDebug(@"\nBegin to login\n");
	NSArray* permissions =  [[NSArray arrayWithObjects: @"offline_access", @"read_stream", @"publish_stream", @"user_about_me", @"email",nil] retain];
	StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    XQDebug(@"\nfacebook accessloken: %@\n", del.facebook.accessToken);
	[del.facebook authorize:permissions delegate:self];
	[permissions release];
    
//	StylelogueAppDelegate *de = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
//    XQDebug(@"\nself.give_opinion_url=%@\n", self.give_opinion_url);
//	[de uploadPhoto:self.url comment:self.textToShare description:self.give_opinion_url];
}

- (void)shareOnTwitter
{
	SHKItem *item = [SHKItem image:selectedImage title:[NSString stringWithFormat:@"%@.\n%@", self.textToShare,self.give_opinion_url]];
	[SHKTwitter shareItem:item];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([indexPath row]) {
		case 0:
			[self shareOnFacebook];
			break;
		case 1:
			[self shareOnTwitter];
			break;
		case 2:
			[self emailToMyFriend];
			break;
		default:
			break;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	self.view.backgroundColor = [UIColor blackColor];
}


#pragma mark Finish parsing
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self backFunction];
}

-(void)didFinishParsing:(NSMutableArray*)parsedData
{
	UISilentView *alertView = [[[UISilentView alloc] initWithTitle:@"Oops!" message:@"We can't connect to the internet right now. Check your network or try again in a minute!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alertView show];
}

- (void)dealloc {
	XQDebug(@"\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Share Photo Page Controller dealloc\n");
	self.selectedImage = nil;
	self.thumnailImage = nil;
	self.backgoundImage = nil;
	self.tableView = nil;
	self.textToShare = nil;
	self.url = nil;
	self.give_opinion_url = nil;
	self.photo = nil;
    [super dealloc];
}

@end
