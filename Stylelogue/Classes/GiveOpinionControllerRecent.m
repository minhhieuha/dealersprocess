    //
//  GiveOpinionControllerRecent.m
//  Stylelogue
//
//  Created by Nguyen Xuan Quang on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GiveOpinionControllerRecent.h"

#define kCustomRowHeight    60.0
#define kCustomRowCount     7
#define LineStyle UITableViewCellSeparatorStyleSingleLine
#define maxval(a,b) (a>b?a:b)
#define minval(a,b) (a<b?a:b)

@implementation GiveOpinionControllerRecent

@synthesize tableView;
@synthesize imageDownloadsInProgress;
@synthesize entries;
@synthesize api;
@synthesize _refreshHeaderView;
@synthesize currentPage;
@synthesize  loginToolbar;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

#pragma mark Init and Load View

-(id)init {
	
    if ((self = [super init])) {
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Recent"];
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
		[button setTitle:@"hot" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		
		[button addTarget:self action:@selector(hotFunction) forControlEvents:UIControlEventTouchUpInside];
		favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		self.navigationItem.rightBarButtonItem = favorite;
		[favorite release];
    }
    return self;
}

-(void)hotFunction
{
	GiveOpinionControllerHot *hotController = [[GiveOpinionControllerHot alloc] init];
	[self.navigationController pushViewController:hotController animated:YES];
	[hotController release];
}

-(void)backFunction
{
	[self.api cancelDownLoad];
	[self cancelDownloading];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	if (self.entries) {
		NSArray *save = self.entries;
		XQDebug(@"\nWrite cach\n");
		[save writeToFile:[documentsDirectory stringByAppendingPathComponent:@"recent.rec"] atomically:YES];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];

	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y,self.view.bounds.size.width, self.view.bounds.size.height - 92) style:UITableViewStylePlain];
	[self setTableView:tableView];
	[tableView release];
    self.tableView.rowHeight = kCustomRowHeight;
	self.tableView.backgroundColor = [UIColor blackColor];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.separatorColor = [UIColor colorWithRed:0xff green:0xff blue:0xff alpha:0.1];
	[self.view addSubview:self.tableView];
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	v.backgroundColor = [UIColor clearColor];
	[self.tableView setTableFooterView:v];
	[v release];
	
	AppMainNavigationController *mainController = (AppMainNavigationController *)self.navigationController;
	self.api = [APIController api];
	self.api.userID = mainController.userID;
	[self.api setDelegate:self];
	currentPage = 1;
	[self.api listRecentItemOfCurrentUser:20 pageNum:currentPage];
	
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		[self set_refreshHeaderView:view];
		[view release];
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	
	
	UIView *toolbar = [[GradientView alloc] initWithFrame:CGRectMake(0, 357 , 320, 60)];
	[toolbar setBackgroundColor:[UIColor clearColor]];
	[toolbar setNeedsDisplay];
	[self.view addSubview:toolbar];

	UIButton *quickOpinion = [UIButton numericPadButton:@"images/icon.get.quick.opinion.png"];
	[quickOpinion addTarget:self action:@selector(goToQuickOpinion:) forControlEvents:UIControlEventTouchUpInside];
	[quickOpinion setLeft:160  - 55 - quickOpinion.width];
	[quickOpinion setTop:(toolbar.height - quickOpinion.height)/2 - 10];
	[toolbar addSubview:quickOpinion];
	
	
	UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
	[addLabel setText:@"Upload Style"];
	[addLabel setFont:[UIFont fontWithName:FONTREGULAR size:TOOLBARSIZE]];
	
	[addLabel setTop:quickOpinion.height - 23];
	[addLabel setTextColor:MAINCOLOR];
	[addLabel setBackgroundColor:[UIColor clearColor]];
	[addLabel setLeft:quickOpinion.left - 10];
	[toolbar addSubview:addLabel];
	[addLabel release];

	UIButton *looksbookButton = [UIButton numericPadButton: @"images/icon.my.looksbook.png"];
	[looksbookButton addTarget:self action:@selector(gotoLooksbook:) forControlEvents:UIControlEventTouchUpInside];
	
	[looksbookButton setLeft:160 + 55];
	
	[looksbookButton setTop:(toolbar.height - looksbookButton.height)/2 - 10];
	[toolbar addSubview:looksbookButton];
	
	UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
	[likeLabel setText:@"My Lookbook"];
	[likeLabel setFont:[UIFont fontWithName:FONTREGULAR size:TOOLBARSIZE]];
	[likeLabel setTop:looksbookButton.height - 23];
	[likeLabel setTextColor:MAINCOLOR];
	[likeLabel setBackgroundColor:[UIColor clearColor]];
	[likeLabel setLeft:looksbookButton.left - 18];
	[toolbar addSubview:likeLabel];
	[likeLabel release];
	[toolbar release];

	[self.view addSubview:[SHKActivityIndicator currentIndicator]];
	[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Loading...")];
	[[SHKActivityIndicator currentIndicator] setTop:LOADDING_POSITION - 10];

	_reloading = YES;

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
    
    self.loginToolbar = loginToolbar;
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (del.fbuserinfo) {
        self.loginToolbar.hidden = YES;
    }else
    {
        self.loginToolbar.hidden = NO;
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

#pragma mark -

-(void)goToQuickOpinion:(id)sender
{
	TakePhotoLandingController *quickOpinionLandingController = [[TakePhotoLandingController alloc] init];
	[self.navigationController pushViewController:quickOpinionLandingController animated:YES];
	[quickOpinionLandingController release];
}

-(void)gotoLooksbook:(id)sender
{
	MyLooksbookController *looksbookController = [[MyLooksbookController alloc] init];
	[self.navigationController pushViewController:looksbookController animated:YES];
	[looksbookController release];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	
}

#pragma mark -

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{

	if (_reloading) {
		return;
	}
	[self cancelDownloading];
	//[self performSelectorOnMainThread:@selector(cancelDownloading) withObject:nil waitUntilDone:YES];
	_reloading = YES;
	[self.api setDelegate:self];
	currentPage = 1;
	[self.api listRecentItemOfCurrentUser:20 pageNum:currentPage];
	
}

- (void)doneLoadingTableViewData{
	
	XQDebug(@"\n>>>>>>>>>>>>>>>>>- (void)doneLoadingTableViewData{\n");
	//  model should call this when its done loading
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -

#pragma mark Parsing finish delegate
-(void)didFinishParsing:(NSMutableArray*)parsedData
{
	_reloading = NO;
	[[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
	
	if ([parsedData count] < 20) {
		displayMoreStyles = NO;
	}else {
		displayMoreStyles = YES;
	}
    
	XQDebug(@"\nCancel delegate for the API\n");
	self.api.delegate = nil;
	if (self.entries && currentPage > 1) {
		
		if ([parsedData count] >= 1) {
			
			Item* iRecord = [parsedData objectAtIndex:0];
			if(!([parsedData count] > 1 || ([parsedData count] == 1 && ![iRecord.question.content isEqualToString:@""]))) 
			{
				((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]).stateLabel.text=@"No More Styles...";
				((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]).stateLabel.textColor = MAINCOLOR;
				
				UIActivityIndicatorView *ind = (UIActivityIndicatorView *)[((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]) viewWithTag:111];
				[ind stopAnimating];
				[ind removeFromSuperview];
				return;
			}
		}

		
		int c = [self.entries count];
		NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex:c];
		for (int i=1; i<[parsedData count]; i++) {
			[indexes addIndex:c+i];
		}
		
		[self.entries insertObjects:[NSArray arrayWithArray:parsedData] atIndexes:indexes];
		//[self loadImagesForOnscreenRows];
	}else {
		NSMutableDictionary *imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
		[self setImageDownloadsInProgress:imageDownloadsInProgress];
		[imageDownloadsInProgress release];
		[self setEntries:parsedData];
	
		XQDebug(@"\n=====>Hello world\n");
	}
	
	if ([parsedData count] < 20) {
		displayMoreStyles = NO;
	}
	
	[self.tableView reloadData];
	
	if ([self.entries count] >= 1) {
		
		Item* iRecord = [self.entries objectAtIndex:0];
		if([self.entries count] > 1 || ([self.entries count] == 1 && ![iRecord.question.content isEqualToString:@""])) 
		{
			self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		}else {
			self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		}

	}
}

#pragma mark Table view creation (UITableViewDataSource)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (entries) {
		
		int count = [entries count];//
		if (count == 0)
		{
			return kCustomRowCount;
		}
		
		if ([entries count] >= 1) {
			
			Item* iRecord = [entries objectAtIndex:0];
			if(!([entries count] > 1 || ([entries count] == 1 && ![iRecord.question.content isEqualToString:@""]))) 
			{
				XQDebug(@"\n>>>>>>>>>			if(!([entries count] > 1 || ([entries count] == 1 && ![iRecord.question.content isEqualToString:@""]))) \n");
				return 1;
			}
		}
		
		
		return (count+1);//add more row to add More style button
	}else {
		return 1;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (_reloading) {
		return;
	}
	
	if ([self.entries count] == indexPath.row) {
		if (![((CustomCell*)[self.tableView cellForRowAtIndexPath:indexPath]).stateLabel.text isEqualToString:@"No More Styles..."]) {
			
			if ([((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]) viewWithTag:111]) {
				return;
			}
			
			UIImageView *img = ((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]).img;
			
			UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((img.width - LOADDINGSIZE)/2.0, (img.height - LOADDINGSIZE)/2.0, LOADDINGSIZE, LOADDINGSIZE)];
			[img addSubview:v];
			v.tag = 111;
			[v startAnimating];
			[v release];
			
			[self.api setDelegate:self];
			[self.api listRecentItemOfCurrentUser:20 pageNum:++currentPage];
		}
	}else {
		
		ViewDetailController *viewDetail = [[ViewDetailController alloc] initWithEntries:self.entries selectedIndex:[indexPath row] lockScroll:NO];
		viewDetail.navigationItem.titleView = [FontLabel titleLabelNamed:@"Recent"];
		
		AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
		mainController.goFrom = 1;
		[self.navigationController pushViewController:viewDetail animated:YES];
		[viewDetail release];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentify = @"Cell";

	
    int nodeCount = [self.entries count];
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
		CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentify];
		if (cell == nil) {
			
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
			
			for (id currentObject in topLevelObjects){
				if ([currentObject isKindOfClass:[UITableViewCell class]]){
					cell =  (CustomCell*) currentObject;
					cell.lineColor.backgroundColor = [UIColor clearColor];
					break;
				}
			}
		}
		
		cell.capitalLabel.text = @"";
		
		cell.rate.text = @"";
		cell.stateLabel.text=@"Loading...";

		cell.stateLabel.top = MORE_POSITION;

		cell.capitalLabel.hidden = NO;
		cell.lineColor.hidden = YES;
		cell.img.hidden = NO;
		cell.userInteractionEnabled = NO;
		[cell setHidden:YES];

		return cell;
    }

	
	CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentify];
	if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (CustomCell*) currentObject;
				break;
			}
		}
	}
	
	
	cell.capitalLabel.textColor = MAINCOLOR;
	[cell.capitalLabel setFont:[UIFont fontWithName:FONT size:CAPITALSIZE]];
	
	cell.stateLabel.textColor = STATECOLOR;
	[cell.stateLabel setFont:[UIFont fontWithName:FONT size:STATESIZE]];
	
	cell.rate.textColor = RATECOLOR;
	[cell.rate setFont:[UIFont fontWithName:FONT size:RATESIZE]];
	
    if (nodeCount > 0)
	{
		
		if (indexPath.row == nodeCount) {
			
			cell.capitalLabel.text = @"";
			
			cell.rate.text = @"";
			cell.stateLabel.text=@"More Styles...";
			cell.stateLabel.textColor = MAINCOLOR;
			cell.stateLabel.top = MORE_POSITION;
			cell.capitalLabel.hidden = NO;
			cell.lineColor.hidden = YES;
			cell.img.hidden = NO;
			//cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
			UIView *selectedView = [UIView viewWithBackgroundColor:RGBACOLOR(0x06,0x06,0x06,0)];
			[selectedView setFrame:cell.frame];
			cell.selectedBackgroundView = selectedView;
			
//			UIImage *arrowImage = [UIImage imageNamed: @"images/arrow.png"];
//			UIImage *arrowHighlightedImage = [UIImage imageNamed:@"images/arrow.new.png"];
//			UIButton *button = [[UIButton alloc] init];
//			[button setUserInteractionEnabled:NO];
//			[button setFrame:CGRectMake(cell.frame.size.width-5-arrowImage.size.width, (cell.frame.size.height-arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
//			[button setImage:arrowImage forState:UIControlStateNormal];
//			[button setImage:arrowHighlightedImage forState:UIControlStateHighlighted];
			
			
			if (displayMoreStyles) {
				cell.hidden = NO;
			}else {
				cell.hidden = YES;
			}
			
			return cell;
		}else
		{
			
			TableCellHilightedView *selectedView = [[TableCellHilightedView alloc] initWithFrame:CGRectMake(-666, 0, cell.frame.size.width, cell.frame.size.height)];
			cell.selectedBackgroundView = selectedView;
			[selectedView release];
			
			TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:CGRectMake(-666, 0, cell.frame.size.width, cell.frame.size.height)];
			cell.backgroundView = backGroundView;
			[backGroundView release];
			

			Item *iRecord = [[self.entries objectAtIndex:indexPath.row] retain];
			cell.capitalLabel.text = iRecord.question.content;
			cell.stateLabel.text = iRecord.question.additional_note;
			cell.rate.text = [NSString stringWithFormat:@"%d Likes", abs(iRecord.number_of_likes)];

			
			if ([iRecord.question.content isEqualToString:@""]) {
				cell.userInteractionEnabled = NO;
				cell.stateLabel.textColor = MAINCOLOR;
				cell.selectedBackgroundView = nil;
				cell.backgroundView = nil;
				cell.capitalLabel.hidden = YES;
				cell.stateLabel.hidden = NO;
                
                cell.stateLabel.left = 320-cell.stateLabel.width - (320-cell.stateLabel.width)/2;
				[cell.stateLabel setTextAlignment:UITextAlignmentCenter];
                
				cell.rate.hidden = YES;
				cell.lineColor.hidden = YES;
				cell.img.hidden = YES;
				[iRecord release];
				return cell;	
			}
			
			cell.capitalLabel.lineBreakMode = UILineBreakModeTailTruncation;
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			
			int width = 170.0/50;
			CGFloat lineColorWidth = minval(170, width*(iRecord.number_of_likes+(iRecord.number_of_likes > 0?1:0)));
			[cell.lineColor setWidth:lineColorWidth];
			[cell.rate setLeft:[cell.lineColor left]+lineColorWidth+(lineColorWidth==0?0:5)];
			[cell.lineColor setHeight:5];
			
			BOOL emptyAdditionalLine = !iRecord.question.additional_note || [iRecord.question.additional_note length] == 0;
			[cell.lineColor setTop: [cell.lineColor top] + 6 + (emptyAdditionalLine ? -15 : 0)];
			[cell.lineColor setBackgroundColor:[UIColor clearColor]];
			[cell.rate setTop:[cell.rate top] + (emptyAdditionalLine ? -15 : 0)];
			
			cell.accessoryView = nil;

			if (!iRecord.icon)
			{	
				iRecord.index = [indexPath row];
				if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
					[self startIconDownload:iRecord forIndexPath:indexPath];
				}
				cell.img.image = [UIImage imageNamed:@"Placeholder.png"];                
				
				UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((cell.img.width - LOADDINGSIZE)/2.0, (cell.img.height - LOADDINGSIZE)/2.0, LOADDINGSIZE, LOADDINGSIZE)];
				[cell.img addSubview:v];
				v.tag = 1;
				[v startAnimating];
				[v release];
			}
			else
			{
				cell.img.image = iRecord.icon;
			}
			
			[iRecord release];
		}
    }
    return cell;
}

-(void)cancelDownloading
{
//	if (self.imageDownloadsInProgress) {
//		
//		[self.imageDownloadsInProgress removeAllObjects];
//	}
}

#pragma mark Table cell image support

- (void)startIconDownload:(Item *)iRecord forIndexPath:(NSIndexPath *)indexPath
{
	if (self.imageDownloadsInProgress) {
		IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
		if (iconDownloader == nil) 
		{
			iconDownloader = [[IconDownloader alloc] init];
			iconDownloader.iRecord = iRecord;
			iconDownloader.status = YES;
			iconDownloader.indexPathInTableView = indexPath;
			iconDownloader.delegate = self;
			[self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
			[iconDownloader startDownload];
			[iconDownloader release];   
		}
	}
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.entries count] > 0)
    {
        NSArray *visiblePaths = [self.tableView  indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
			if (indexPath.row < [self.entries count]) {
				Item *iRecord = [self.entries objectAtIndex:indexPath.row];
				
				if (!iRecord.icon ) // avoid the app icon download if the app already has an icon
				{
					iRecord.index = [indexPath row];
					[self startIconDownload:iRecord forIndexPath:indexPath];
				}
			}
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
	XQDebug(@"\n>>>>>>>>>----->>>>>Don't update\n");
	
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
	
    if (iconDownloader != nil)
    {
        CustomCell *cell = (CustomCell*)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
		if (cell) {
			if (iconDownloader.status && iconDownloader.iRecord.icon ) {
				
				
				UIActivityIndicatorView *v = (UIActivityIndicatorView *)[cell.img viewWithTag:1];
				[v stopAnimating];
				[v removeFromSuperview];
				
				[cell.img setAlpha:0.0];
				cell.img.image = iconDownloader.iRecord.icon;
				[UIView beginAnimations:nil context:nil];
				[UIView setAnimationDuration:0.9];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
				[cell.img setAlpha:1];
				[UIView commitAnimations];
			}
		}
    }

}

#pragma mark -


#pragma mark Deferred image loading (UIScrollViewDelegate)

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
	
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.tableView.delegate = nil;
	self._refreshHeaderView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	if (_reloading) {
		[self.view addSubview:[SHKActivityIndicator currentIndicator]];
		[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Loading...")];
		[[SHKActivityIndicator currentIndicator] setTop:LOADDING_POSITION - 10];
	}
	
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];	
	if (self.entries) {
		[self.tableView reloadData];
	}
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)dealloc {

	self.api = nil;
	self.tableView = nil;
	self.imageDownloadsInProgress=nil;
	self.entries=nil;
	self._refreshHeaderView = nil;
    self.loginToolbar = nil;
    [super dealloc];
}

@end
