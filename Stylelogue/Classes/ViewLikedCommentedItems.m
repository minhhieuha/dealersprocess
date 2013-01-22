    //
//  ViewLikedCommentedItems.m
//  Stylelogue
//
//  Created by Peter Quang Nguyen on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewLikedCommentedItems.h"

#define kCustomRowHeight    60.0
#define kCustomRowCount     7
#define LineStyle UITableViewCellSeparatorStyleSingleLine
#define maxval(a,b) (a>b?a:b)

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 20.0f

@implementation ViewLikedCommentedItems

@synthesize tableView;
@synthesize imageDownloadsInProgress;
@synthesize entries;
@synthesize api;
@synthesize _refreshHeaderView;
@synthesize currentPage;

#pragma mark Init and Load View

-(id)init {
	
    if ((self = [super init])) {
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Notifications"];
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
	[self.navigationController popViewControllerAnimated:YES];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	[super loadView];
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y,self.view.bounds.size.width, self.view.bounds.size.height-35) style:UITableViewStylePlain];
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
	[self.api getAllNotifications:20 pageNum:currentPage];
	
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		[self set_refreshHeaderView:view];
		[view release];
	}
	
	// update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
		
	[self.view addSubview:[SHKActivityIndicator currentIndicator]];
	[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Loading...")];
	[[SHKActivityIndicator currentIndicator] setTop:LOADDING_POSITION];
	
	_reloading = YES;
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
	_reloading = YES;
	[self.api setDelegate:self];
	currentPage = 1;
	[self.api getAllNotifications:20 pageNum:currentPage];
	
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
	
	if ([parsedData count] < 20) {
		displayMoreStyles = NO;
	}else {
		displayMoreStyles = YES;
	}

	
	_reloading = NO;
	[[SHKActivityIndicator currentIndicator] hide];
	[[SHKActivityIndicator currentIndicator] removeFromSuperview];
	
	XQDebug(@"\nCancel delegate for the API\n");
	self.api.delegate = nil;
	if (self.entries && currentPage > 1) {
		
		if ([parsedData count] >= 1) {
			
			Item* iRecord = [parsedData objectAtIndex:0];
			if(!([parsedData count] > 1 || ([parsedData count] == 1 && ![iRecord.question.content isEqualToString:@""]))) 
			{
				((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]).stateLabel.text=@"No More Notifications...";
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
		
		if (![((CustomCell*)[self.tableView cellForRowAtIndexPath:indexPath]).stateLabel.text isEqualToString:@"No More Notifications..."])
		{
			
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
			[self.api getAllNotifications:20 pageNum:++currentPage];
			
		}
	}else {
		
		Item *it = (Item*)[self.entries objectAtIndex:[indexPath row]];		
		
		if ([[it.message componentsSeparatedByString:@"commented"] count] == 2) {
			GiveopinionController *giveOpinionController = [[GiveopinionController alloc] initWithItem:it];
			[self.navigationController pushViewController:giveOpinionController animated:YES];
			[giveOpinionController release];
			
		}else {
			
			ViewDetailController *viewDetail = [[ViewDetailController alloc] initWithEntries:self.entries selectedIndex:[indexPath row] lockScroll:YES];
			AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
			mainController.goFrom = 1;
			[self.navigationController pushViewController:viewDetail animated:YES];
			[viewDetail release];
		}
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
			cell.stateLabel.text=@"More Notifications...";
			cell.stateLabel.top = MORE_POSITION;
			cell.stateLabel.textColor = MAINCOLOR;
			
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
			
			Item *iRecord = [[self.entries objectAtIndex:indexPath.row] retain];
			
			if ([iRecord.question.content isEqualToString:@""]) {
				
				cell.selectedBackgroundView = nil;
				cell.backgroundView = nil;
				
				cell.stateLabel.text = iRecord.question.additional_note;
				cell.stateLabel.textColor = MAINCOLOR;
				cell.userInteractionEnabled = NO;
				
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
			
			
			TableCellHilightedView *selectedView = [[TableCellHilightedView alloc] initWithFrame:CGRectMake(-666, 0, cell.frame.size.width, cell.frame.size.height)];
			cell.selectedBackgroundView = selectedView;
			[selectedView release];
			
			TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:CGRectMake(-666, 0, cell.frame.size.width, cell.frame.size.height)];
			cell.backgroundView = backGroundView;
			[backGroundView release];
			
			
			NSString *mess = [NSString stringWithFormat:@"%@ %@", iRecord.message, iRecord.created_at];
			XQDebug(@"\nmess := %@\n", mess);
			ZMutableAttributedString *str = [[ZMutableAttributedString alloc] initWithString:mess
																				  attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																							  [ZFont fontWithUIFont:[UIFont fontWithName:FONT size:15]],
																							  ZFontAttributeName, [UIColor whiteColor], ZForegroundColorAttributeName, [UIColor clearColor], ZBackgroundColorAttributeName,
																							  nil]];
			
			[str addAttribute:ZFontAttributeName value:[ZFont fontWithUIFont:[UIFont fontWithName:FONT size:12]] range:NSMakeRange([iRecord.message length], [iRecord.created_at length]+1)];
			[str addAttribute:ZForegroundColorAttributeName value:RGBACOLOR(0x55, 0x55, 0x55, 1) range:NSMakeRange([iRecord.message length], [iRecord.created_at length]+1)];
			cell.viewDetail.zAttributedText = str;
			cell.viewDetail.textAlignment = UITextAlignmentLeft;
			cell.viewDetail.numberOfLines = 0;
			[str release];

			cell.capitalLabel.hidden = NO;
			cell.stateLabel.hidden = YES;
			cell.rate.hidden = YES;
			cell.lineColor.hidden = YES;
			cell.img.hidden = NO;
			
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
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

}

#pragma mark Table cell image support

- (void)startIconDownload:(Item *)iRecord forIndexPath:(NSIndexPath *)indexPath
{
	XQDebug(@"\nIcondownloader: %@\n", iRecord.cropped_photo);
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
	
	if (self.imageDownloadsInProgress == nil) {
		return;
	}
	
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

    [super didReceiveMemoryWarning];
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
		[[SHKActivityIndicator currentIndicator] setTop:LOADDING_POSITION];
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
    [super dealloc];
}

@end

