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

@implementation MyLooksbookController

@synthesize tableView;
@synthesize imageDownloadsInProgress;
@synthesize entries;
@synthesize api;
@synthesize _refreshHeaderView;
@synthesize currentPage;
@synthesize entriesItems;


#pragma mark Init and Load View

- (id)init {
	
    if ((self = [super init])) {
        // Custom initialization
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"My Lookbook"];
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
		[button setTitle:@"edit" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		
		[button addTarget:self action:@selector(editFunction) forControlEvents:UIControlEventTouchUpInside];
		favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		self.navigationItem.rightBarButtonItem = favorite;
		[favorite release];
    }
    return self;
}

-(void)editFunction
{
	if (_reloading) {
		return;
	}
	
	if ([entries count] >= 1) {
		
		Item* iRecord = [entries objectAtIndex:0];
		if(!([entries count] > 1 || ([entries count] == 1 && ![iRecord.question.content isEqualToString:@""]))) 
		{
			return;
		}
	}
	
	if (self.navigationItem.rightBarButtonItem.tag == 0) {
		[self.tableView setEditing:YES animated:YES];
		
		UIButton *button = [UIButton numericPadButton:@"images/button.done.png"];
		[button setTitle:@"done" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		
		[button addTarget:self action:@selector(editFunction) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		button.tag = 1;
		
		self.navigationItem.rightBarButtonItem = favorite;
		self.navigationItem.rightBarButtonItem.tag  = 1;
		[favorite release];
		
		//[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]].hidden = YES;
		
	}else {
		
		[self.tableView setEditing:NO animated:YES];
		UIButton *button = [UIButton numericPadButton:@"images/button.done.png"];
		[button setTitle:@"edit" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		[button addTarget:self action:@selector(editFunction) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem * favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		button.tag = 0;
		
		self.navigationItem.rightBarButtonItem = favorite;
		self.navigationItem.rightBarButtonItem.tag = 0;
		[favorite release];
		
		//[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]].hidden = NO;
	}
	
}

-(int)getIndex:(int)index
{
	int c = -1;
	for (int i=0; i<=index; i++) {
		Goody *g = [self.entries objectAtIndex:i];
		if ([g.type isEqualToString:@"item"]) {
			c++;
		}
	}
	return c;
}

#pragma mark Alert View to conform to user that they have want to delete this item

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		
		Item *it = [[self.entries objectAtIndex:alertView.tag] retain];
		
		NSArray *row = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
		
		NSUInteger totalRow = [self.entries count];
		
		if (totalRow != 1) {
			
			[self.tableView beginUpdates];
			
			[self.entries removeObjectAtIndex:alertView.tag];
			[self.tableView reloadData];
			
			[self.tableView deleteRowsAtIndexPaths:row withRowAnimation:UITableViewRowAnimationLeft];
			[self.tableView endUpdates];
			
			for (int i = 0; i< [self.entriesItems count]; i++) {
				Goody *g = [self.entriesItems objectAtIndex:i];
				if (g.index == it.index) {		
					[self.entriesItems removeObjectAtIndex:i];
				}
			}
			
		}else {
			//call to refresh again
			if ([self.entries count] == 1) {
				Item* it = [[Item alloc] init];
				Question *q =  [[Question alloc] init];
				it.question = q;
				it.question.content = @"";
				it.question.additional_note = @"No Item Available";
				it.icon = [UIImage imageNamed:@"Placeholder.png"];
				[self.entries insertObject:it atIndex:0];
				[q release];
				[it release];
				[self.entries removeObjectAtIndex:1];
				self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				
				[self.tableView setEditing:NO animated:YES];
				UIButton *button = [UIButton numericPadButton:@"images/button.done.png"];
				[button setTitle:@"edit" forState:UIControlStateNormal];
				[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
				button.titleLabel.textColor = MAINCOLOR;
				[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
				[button addTarget:self action:@selector(editFunction) forControlEvents:UIControlEventTouchUpInside];
				UIBarButtonItem * favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
				button.tag = 0;
				
				self.navigationItem.rightBarButtonItem = favorite;
				self.navigationItem.rightBarButtonItem.tag = 0;
				[favorite release];
				
				[self.tableView reloadData];
			}
		}
		
		[self.view setNeedsDisplay];
		[api removeFromLookbook:it.itemID type:it.type];
		[it release];
	}
}


#pragma mark --

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
	[tableView setTableFooterView:v];
	[v release];
	
	AppMainNavigationController *mainController = (AppMainNavigationController *)self.navigationController;
	self.api = [APIController api];
	self.api.userID = mainController.userID;
	[self.api setDelegate:self];
	currentPage = 1;
	[self.api listItemOfLooksbook:20 pageNum:currentPage];
	
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		//_refreshHeaderView = view;
		[self set_refreshHeaderView:view];
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	
	
	UIView *toolbar = [[GradientView alloc] initWithFrame:CGRectMake(0, 357 , 320, 60)];
	[toolbar setBackgroundColor:[UIColor clearColor]];
	[toolbar setNeedsDisplay];
	[self.view addSubview:toolbar];
	
	UIButton *addButton = [UIButton numericPadButton: @"images/icon.get.quick.opinion.png"];
	[addButton addTarget:self action:@selector(goToQuickOpinion:) forControlEvents:UIControlEventTouchUpInside];
	
	[addButton setLeft:140];
	[addButton setTop:(toolbar.height - addButton.height)/2 - 10];
	[toolbar addSubview:addButton];
	
	UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
	[addLabel setText:@"Upload Style"];
	[addLabel setFont:[UIFont fontWithName:FONTREGULAR size:TOOLBARSIZE]];
	[addLabel setTop:addButton.height - 23];
	[addLabel setTextColor:MAINCOLOR];
	[addLabel setBackgroundColor:[UIColor clearColor]];
	[addLabel setLeft:addButton.left - 10];
	[toolbar addSubview:addLabel];
	[addLabel release];
	
	[toolbar release];
	
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
	_reloading = YES;
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	[self.api setDelegate:self];
	currentPage = 1;
	[self.api listItemOfLooksbook:20 pageNum:currentPage];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}


#pragma mark -

#pragma mark Parsing finish delegate
-(void)didFinishParsing:(NSMutableArray*)parsedData
{
	if (![api.message isEqualToString:@""]) {
		UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"" message:api.message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
		[alertView show];
		[alertView release];
		
	}
	
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
	}
	
	NSMutableArray *entriesItems  = [[NSMutableArray alloc] init];
	[self setEntriesItems:entriesItems];
	[entriesItems release];
	
	int index=0;
	for (Goody*g in self.entries) {
		if ([g.type isEqualToString:@"item"]) {
			g.index = index++;
			[self.entriesItems addObject:g];
		}
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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	XQDebug(@"\nHEllo-----------\n");

	if ([indexPath row] == [self.entries count]) {
		XQDebug(@"\n	if ([indexPath row] == [self.entries count]) {\n");
		return 	UITableViewCellEditingStyleNone;
	}
	
	if ([entries count] >= 1) {
		
		Item* iRecord = [entries objectAtIndex:0];
		if(!([entries count] > 1 || ([entries count] == 1 && ![iRecord.question.content isEqualToString:@""]))) 
		{
			return UITableViewCellEditingStyleNone;
		}
	}
	
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	XQDebug(@"\nChange to begin edit mode\n");
	[self.tableView setEditing:YES animated:YES];
	UIButton *button = [UIButton numericPadButton:@"images/button.done.png"];
	[button setTitle:@"done" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	
	[button addTarget:self action:@selector(editFunction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	button.tag = 1;
	
	self.navigationItem.rightBarButtonItem = favorite;
	self.navigationItem.rightBarButtonItem.tag  = 1;
	[favorite release];
	
	//[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]].hidden = YES;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView setEditing:NO animated:YES];
	
	UIButton *button = [UIButton numericPadButton:@"images/button.done.png"];
	[button setTitle:@"edit" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	
	[button addTarget:self action:@selector(editFunction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem * favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	button.tag = 0;
	
	self.navigationItem.rightBarButtonItem = favorite;
	self.navigationItem.rightBarButtonItem.tag = 0;
	[favorite release];
	
	//[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]].hidden = NO;
	XQDebug(@"\nChange to end edit mode\n");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	XQDebug(@"\n-==============>>>>>>>>>>>>>>>>>> (void)tableView:(UITableView *)tableView commitEditingStyle\n");
	Item *it = [self.entries objectAtIndex:[indexPath row]];
	
	XQDebug(@"\nit.owner.fb_user_id=%@\n", it.owner.fb_user_id);
	
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
    
	if (it.owner.user_id == del.user.user_id) {
		NSString * mess = [NSString stringWithFormat:@"%@Are you sure you want to remove this item?", it.number_of_added_to_lookbook-1 < 1? @"":[it.type isEqualToString:@"item"]? [NSString stringWithFormat:@"%d user%@ added your picture.\n", it.number_of_added_to_lookbook-1, it.number_of_added_to_lookbook-1>1?@"s have":@" has"]:@""];
		UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Confirmation" message:mess delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		alertView.tag = [indexPath row];
		[alertView show];
		[alertView release];
	}else {
		NSString * mess = [NSString stringWithFormat:@"Are you sure you want to remove this item?"];
		UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Confirmation" message:mess delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		alertView.tag = [indexPath row];
		[alertView show];
		[alertView release];
	}
}

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
			[self.api listItemOfLooksbook:20 pageNum:++currentPage];
			XQDebug(@"\ncurrentPage=%d\n", currentPage);
		}
		
		return;
	}

	Item *it = [self.entries objectAtIndex:[indexPath row]];
	
	if ([tableView cellForRowAtIndexPath:indexPath].tag == 1) {

		UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:@"Have %d users have added your picture\nAre you sure you want to remove this item?", it.number_of_added_to_lookbook-1] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
		alertView.tag = [indexPath row];
		[alertView show];
		[alertView release];
		
	}else {
		if ([it.type isEqualToString:@"item"]) {
			
			ViewDetailController *viewDetail = [[ViewDetailController alloc] initWithEntries:self.entriesItems selectedIndex: [self getIndex:[indexPath row]] lockScroll:NO];
			viewDetail.navigationItem.titleView = [FontLabel titleLabelNamed:@"My Lookbook"];
			
			AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
			mainController.goFrom = 3;
			[self.navigationController pushViewController:viewDetail animated:YES];
			[viewDetail release];
		}else {
			AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
			mainController.goFrom = 3;
			
			Goody *g = (Goody*)[self.entries objectAtIndex:[indexPath row]];
			GoodiesController *goodies = [[GoodiesController alloc] initWithGoody:g];
			[self.navigationController pushViewController:goodies animated:YES];
			[goodies release];
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
		if (indexPath.row == nodeCount ) {
			
			cell.capitalLabel.text = @"";
			
			cell.rate.text = @"";
			cell.stateLabel.text=@"More Styles...";
			cell.stateLabel.top = MORE_POSITION;
			cell.stateLabel.textColor = MAINCOLOR;
			
			cell.capitalLabel.hidden = NO;
			cell.lineColor.hidden = YES;
			cell.img.hidden = NO;
			//cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			UIView *selectedView = [UIView viewWithBackgroundColor:RGBACOLOR(0x06,0x06,0x06,0)];
			[selectedView setFrame:cell.frame];
			cell.selectedBackgroundView = selectedView;
			
			if (self.tableView.isEditing) {
				cell.hidden = YES;
			}else {
				cell.hidden = NO;
			}
			
			
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
				
				cell.stateLabel.textColor = MAINCOLOR;
				cell.selectedBackgroundView = nil;
				cell.backgroundView = nil;
				
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
			
			if ([iRecord.type isEqualToString:@"goody"]) {
				
				Goody *iRecord = [[self.entries objectAtIndex:indexPath.row] retain];
				cell.capitalLabel.text = iRecord.question.content;
				//cell.stateLabel.text = iRecord.question.additional_note;
				cell.rate.text = [NSString stringWithFormat:@"%d Likes", iRecord.number_of_likes];
				
				cell.capitalLabel.lineBreakMode = UILineBreakModeTailTruncation;
				cell.capitalLabel.highlightedTextColor = [UIColor blackColor];
				cell.stateLabel.highlightedTextColor = [UIColor blackColor];
				cell.rate.highlightedTextColor = [UIColor blackColor];
				cell.selectionStyle = UITableViewCellSelectionStyleGray;
				
				int width = 170.0/50;
				CGFloat lineColorWidth = minval(170, width*iRecord.number_of_likes);
				[cell.lineColor setWidth:lineColorWidth];
				[cell.rate setLeft:[cell.lineColor left]+lineColorWidth+5];
				[cell.lineColor setHeight:8];
				
				BOOL emptyAdditionalLine = !iRecord.question.additional_note || [iRecord.question.additional_note length] == 0;
				[cell.lineColor setTop: [cell.lineColor top] + 4 + (emptyAdditionalLine ? -15 : 0)];
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
				
				cell.rate.hidden = YES;
				cell.lineColor.hidden = YES;
				
				cell.stateLabel.text = cell.capitalLabel.text;
				[cell.capitalLabel setTop:cell.capitalLabel.top + 5];
				[cell.stateLabel setTop:cell.stateLabel.top + 10];
				
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
			
			
			[iRecord release];
		}
		
    }
    return cell;
}

-(void)cancelDownloading
{
//	if (self.imageDownloadsInProgress) {
//		
//		NSArray *keys = [self.imageDownloadsInProgress allKeys];
//		XQDebug(@"\nCancel downloading...%d\n",[keys count]);
//		
//		for (NSIndexPath *index in keys) {
//			IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:index];
//			if (iconDownloader) {
//
//				[iconDownloader cancel];
//			}
//		}
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];	
	if (self.entries) {
		[self.tableView reloadData];
	}
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)dealloc {
	
	self._refreshHeaderView = nil;
	self.entries = nil;
	self.imageDownloadsInProgress = nil;
	self.api = nil;
	self.tableView = nil;
	self.entriesItems = nil;
    [super dealloc];
}

@end


