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

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 300.0f
#define CELL_CONTENT_MARGIN 20.0f

@implementation GiveopinionController

@synthesize tableView;

@synthesize entries;
@synthesize api;
@synthesize _refreshHeaderView;
@synthesize currentPage;
@synthesize it;

@synthesize backgroundImage;
@synthesize selectedImage;
@synthesize textFieldRoundedWrapper;
@synthesize textFieldForAddionalNotes;
@synthesize backGround;
@synthesize names;
@synthesize imageDownloadsInProgress;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

#pragma mark Init and Load View

- (id)initWithItem:(Item*)it{
    if ((self = [super init])) {
		[self setIt:it];
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Opinions"];
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

-(void)editFunction:(id)sender
{
	
	if (_reloading) {
		return;
	}
	
	
	if ([entries count] >= 1) {
		
		Opinion* iRecord = [entries objectAtIndex:0];
		if(!([entries count] > 1 || ([entries count] == 1 && iRecord.ID != -1111))) 
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
		
		[button addTarget:self action:@selector(editFunction:) forControlEvents:UIControlEventTouchUpInside];
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
		[button addTarget:self action:@selector(editFunction:) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem * favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		button.tag = 0;
		
		self.navigationItem.rightBarButtonItem = favorite;
		self.navigationItem.rightBarButtonItem.tag = 0;
		[favorite release];
		
		//[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]].hidden = NO;
	}
}

-(void)cancelDownloading
{
	AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
	mainController.delegate = nil;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[self setBackgroundImage:backgroundImage];
	[backgroundImage release];
	
	
	//check that if the origin image is empty so then begin to download it then will update to uiimageview later
	if (!it.originPhoto) {
		[self startIconDownload:it forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	}else {
		self.backgroundImage.image = self.it.originPhoto;
	}
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	[self.view addSubview:self.backgroundImage];
	[self.backgroundImage setAlpha:0.2];

	UIView *backGround = [[UIView alloc] initWithFrame:self.view.bounds];
	[self setBackGround:backGround];
	[backGround release];
	[self.backGround setAlpha:0.0];
	[self.view addSubview:self.backGround];
	[self.backGround setBackgroundColor:[UIColor blackColor]];
	
	
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y,self.view.bounds.size.width, self.view.bounds.size.height - 92) style:UITableViewStylePlain];
	[self setTableView:tableView];
	[tableView release];
    self.tableView.rowHeight = kCustomRowHeight;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.separatorColor = [UIColor colorWithRed:0xff green:0xff blue:0xff alpha:0.1];
	[self.view addSubview:self.tableView];
	self.tableView.scrollEnabled = YES;
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	v.backgroundColor = [UIColor clearColor];
	[self.tableView setTableFooterView:v];
	[v release];
	
	
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
	
	[button addTarget:self action:@selector(editFunction:) forControlEvents:UIControlEventTouchUpInside];
	favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.rightBarButtonItem = favorite;
	[favorite release];
	
	
	self.textFieldRoundedWrapper = [UIView viewWithStretchableBackgroundImage:@"images/textfield.background.png" widthCap:11 andHeightCap:11];
	[self.textFieldRoundedWrapper setLeft:20];
	[self.textFieldRoundedWrapper setHeight:200];
	
	
	[self.view addSubview:self.textFieldRoundedWrapper];
	
	UITextView *textFieldForAddionalNotes = [[UITextView alloc] initWithFrame:CGRectInset(self.textFieldRoundedWrapper.bounds, 8, 8)];
	[self setTextFieldForAddionalNotes:textFieldForAddionalNotes];
	[textFieldForAddionalNotes release];
	[self.textFieldForAddionalNotes setFont:[UIFont fontWithName:FONT size:15]];
	[self.textFieldRoundedWrapper addSubview:self.textFieldForAddionalNotes];
	[self.textFieldForAddionalNotes clampFlexibleMiddle];
	[self.textFieldForAddionalNotes setDelegate:self];
	[self.textFieldForAddionalNotes setKeyboardAppearance:UIKeyboardAppearanceAlert];
	
	[self.textFieldRoundedWrapper setTop:0-self.textFieldRoundedWrapper.height];
	
	
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		//_refreshHeaderView = view;
		[self set_refreshHeaderView:view];
		[view release];
		
	}
	
	UIView *toolbar = [[GradientView alloc] initWithFrame:CGRectMake(0, 357, 320, 60)];
	[self.view addSubview:toolbar];
	
	UIButton *addButton = [UIButton numericPadButton: @"images/icon.submit.opinion.png"];
	[addButton addTarget:self action:@selector(addOpinion) forControlEvents:UIControlEventTouchUpInside];
	
	[addButton setLeft:140];
	[addButton setTop:(toolbar.height - addButton.height)/2 - 10];
	[toolbar addSubview:addButton];
	
	UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
	[addLabel setText:@"Write Opinion"];
	[addLabel setFont:[UIFont fontWithName:FONTREGULAR size:TOOLBARSIZE]];
	[addLabel setTop:addButton.height - 23];
	[addLabel setTextColor:MAINCOLOR];
	[addLabel setBackgroundColor:[UIColor clearColor]];
	[addLabel setLeft:addButton.left - 16];
	[toolbar addSubview:addLabel];
	[addLabel release];
	
	[toolbar release];
	
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
	
	NSMutableDictionary *names = [[NSMutableDictionary alloc] init];
	[self setNames:names];
	[names release];

	AppMainNavigationController *mainDelegate = (AppMainNavigationController*)self.navigationController;
	self.api = [APIController api];
	self.api.userID = mainDelegate.userID;
	XQDebug(@"\nHello world main Delegate: %@\n", self.api.userID);
	[self.api setDelegate:self];
	currentPage = 1;
	[self.api listOpinionsOfQuestion:it.question.qID numberOpinionsPerpage:20 pageNum:1];
	
	[self.view addSubview:[SHKActivityIndicator currentIndicator]];
	[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Loading...")];
	[[SHKActivityIndicator currentIndicator] setTop:LOADDING_POSITION];
	_reloading = YES;
	
	XQDebug(@"\nHello world main Delegate: %@\n", self.api.userID);
}

- (void)didGetFacebookName:(NSArray*)array {
	
	NSArray *userNames = [array retain];
	XQDebug(@"\n------------->>>>>>>>>>>>>>respone: %@\n", userNames);

	for (NSDictionary *dic in userNames) {
		[self.names setValue:[dic valueForKey:@"name"] forKey:[dic valueForKey:@"uid"]];
	}
	
	for (Opinion *p in self.entries) {
		p.owner.name = [self.names valueForKey:p.owner.fb_user_id];
	}
	[self.tableView reloadData];
	[userNames release];
}

-(void)failedToGetFacebookName
{
	for (Opinion *p in self.entries) {
		p.owner.name = @"Get Name Error";
	}
	[self.tableView reloadData];
}


#pragma mark Get name of Facebook user from facebook user id

-(void)getFBNameFromFBUserID:(NSString*)username
{
	XQDebug(@"\nHEllo: %d\n", self.it.question.number_of_opinions);
	if (self.it.question.number_of_opinions > 0) {
		
		[self setNames:[NSMutableDictionary dictionary]];
		for (Opinion* op in self.entries) {
			if (op.owner.fb_user_id) {
				XQDebug(@"\nAdd new keyss.....................<<<<<<<<<<<<<<<<\n");
				[self.names setValue:@"No Name" forKey:op.owner.fb_user_id];
			}
		}
		
		XQDebug(@"\nNumber of key: %d\n", [[self.names allKeys] count]);
		NSArray *allkeys = [self.names allKeys];
		NSMutableString *uids = [[[NSMutableString alloc] init] autorelease];
		[uids appendString:[NSString stringWithFormat:@"uid=%@ ", [allkeys objectAtIndex:0]]];
		for (NSString *n in allkeys) {
			XQDebug(@"\nkey: %@\n", n);
			[uids appendString:[NSString stringWithFormat:@" or uid=%@", n]];
		}
		XQDebug(uids);
		AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
		mainController.delegate = self;
		//SHKFacebook *facebook = mainController.facebook;
//		[facebook getNameOfUserbyFBUserID:uids delegate:mainController];
	}
}
#pragma mark ----
-(void)cancelOpinion
{
	self.tableView.hidden = NO;
	XQDebug(@"\nCancel Opinion\n");
	
	[self.textFieldForAddionalNotes resignFirstResponder];
	[UIView beginAnimations:NULL context:NULL];
	[self.textFieldRoundedWrapper setTop:0-self.textFieldRoundedWrapper.height];
	[UIView commitAnimations];
	[self.backGround setAlpha:0.0];
	
	UIButton *button = [UIButton numericPadButton:@"images/button.back.png"];
	[button setTitle:@"back" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	
	XQDebug(@"\nCancel cancel\n");
	[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.leftBarButtonItem = favorite;
	self.navigationItem.rightBarButtonItem = nil;
	[favorite release];
	
	[self.tableView setEditing:NO animated:NO];
	button = [UIButton numericPadButton:@"images/button.done.png"];
	[button setTitle:@"edit" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	[button addTarget:self action:@selector(editFunction:) forControlEvents:UIControlEventTouchUpInside];
	favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	button.tag = 0;
	
	self.navigationItem.rightBarButtonItem = favorite;
	self.navigationItem.rightBarButtonItem.tag = 0;
	[favorite release];
	
}

#pragma mark begin functions to download background image

- (void)startIconDownload:(Item *)iRecord forIndexPath:(NSIndexPath *)indexPath
{
	XQDebug(@"\n======>Give opinion begin to download background image\n");
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
		XQDebug(@"\nStart download icon...%d\n", [indexPath row]);
		iconDownloader = [[IconDownloader alloc] init];
		iconDownloader.iRecord = iRecord;
		iconDownloader.status = NO;
		iconDownloader.indexPathInTableView = indexPath;
		iconDownloader.delegate = self;
		[imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
		[iconDownloader startDownload];
		[iconDownloader release];
    }
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath
{	
	XQDebug(@"\n>>>>>>>>>>>>>List all opinion:  Have finish download\n");
	//check that if the origin image is empty so then begin to download it then will update to uiimageview later
	self.backgroundImage.image = self.it.originPhoto;
}

#pragma mark End down load background image for the liked item when go from the notification list

-(void)didPostOpinion
{	
//	AppMainNavigationController *mainNavi = (AppMainNavigationController*)self.navigationController;
//	[[APIController api] postNotificationToUserByUserID:[NSString stringWithFormat:@"%@ comments your photo", mainNavi.facebookName ] userid:self.it.owner.fb_user_id itemID:self.it.itemID];
	
	XQDebug(@"\n------------------->(void)didPostOpinion: %@\n", self.it.owner.fb_user_id);
	[self.api setDelegate:self];
	currentPage = 1;
	[self.api listOpinionsOfQuestion:it.question.qID numberOpinionsPerpage:20 pageNum:1];
}

-(void)postOpinion
{
	if (_reloading) {
		return;
	}
	
	if ([self.textFieldForAddionalNotes.text isEqualToString:@""]) {
		
		UISilentView *alertView = [[[UISilentView alloc] initWithTitle:@"Conformation" message:@"Please write your opinion" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[alertView show];
		
		return;
	}
	_reloading = YES;
	XQDebug(@"\n========>itemid: %d\n", it.itemID);
	self.tableView.hidden = NO;
	[self.api setDelegate:self];
	NSString *opinion = self.textFieldForAddionalNotes.text;
	XQDebug(@"\nAfter remove newline: %@\n", [opinion stringByReplacingOccurrencesOfString:@"\n" withString:@"<myNewLine>"]);
	NSString *slash = [opinion stringByReplacingOccurrencesOfString:@"\n" withString:@"<myNewLine>"];
	XQDebug(@"\nAfter add slash: %@\n", [slash stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]);
	[self.api addOpinionForItem:it.itemID questionID:it.question.qID content:[slash stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]];
	[self cancelOpinion];
}

-(void)addOpinion
{

	if (_reloading) {
		return;
	}
	
	self.textFieldForAddionalNotes.text =@"";
	self.tableView.hidden = YES;
	
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelOpinion)];
	
	self.navigationItem.leftBarButtonItem = favorite;
	[favorite release];

	favorite = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postOpinion)];
	
	self.navigationItem.rightBarButtonItem = favorite;
	[favorite release];
	
	[self.view bringSubviewToFront:self.textFieldRoundedWrapper];
	
	[self.backGround setAlpha:1];
	
	[UIView beginAnimations:NULL context:NULL];
	[self.textFieldRoundedWrapper setTop:100];
	[UIView commitAnimations];
	
	[self.textFieldForAddionalNotes becomeFirstResponder];
	[UIView beginAnimations:NULL context:NULL];
	[textFieldRoundedWrapper setFrame:CGRectMake(textFieldRoundedWrapper.frame.origin.x, 12, textFieldRoundedWrapper.frame.size.width, 180)];
	[UIView commitAnimations];
}


#pragma mark Text View Delegate sesstion

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	XQDebug(@"\n- (BOOL)textViewShouldBeginEditing:(UITextView *)textView\n");
	[UIView beginAnimations:NULL context:NULL];
	[textFieldRoundedWrapper setFrame:CGRectMake(textFieldRoundedWrapper.frame.origin.x, 12, textFieldRoundedWrapper.frame.size.width, 180)];
	[UIView commitAnimations];
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	return YES;
}

#pragma mark ---

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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -

#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{

	[self.api setDelegate:self];
	currentPage = 1;
	[self.api listOpinionsOfQuestion:it.question.qID numberOpinionsPerpage:20 pageNum:currentPage];
	
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{

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
			
			Opinion* iRecord = [parsedData objectAtIndex:0];
			if(!([parsedData count] > 1 || ([parsedData count] == 1 && iRecord.ID != -1111))) 
			{

				((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]).stateLabel.text = @"No More Opinions...";
				((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]).stateLabel.textColor = MAINCOLOR;
				
				UIActivityIndicatorView *ind = (UIActivityIndicatorView *)[((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]) viewWithTag:111];
				[ind stopAnimating];
				[ind removeFromSuperview];
				[self.tableView setNeedsDisplay];
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
	
		[self setEntries:parsedData];
	
		
	}
	
	[self.tableView reloadData];	
}



#pragma mark Alert View to conform to user that they have want to delete this item


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		
		Opinion *it = [[self.entries objectAtIndex:alertView.tag] retain];
		//check that current user have owned this item
		
		NSArray *row = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
		
		NSUInteger totalRow = [self.entries count];
		
		if (totalRow != 1) {
			
			[self.tableView beginUpdates];
			
			[self.entries removeObjectAtIndex:alertView.tag];
			[self.tableView reloadData];
			
			[self.tableView deleteRowsAtIndexPaths:row withRowAnimation:UITableViewRowAnimationLeft];
			[self.tableView endUpdates];
			
		}else {
			//call to refresh again
			if ([self.entries count] == 1) {
				
				Opinion* it = [[Opinion alloc] init];
				it.ID = -1111;
				it.content = @"No Opinion Available";
				[self.entries insertObject:it atIndex:0];
				[it release];
				[self.entries removeObjectAtIndex:1];
				self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
				
				[self.tableView setEditing:NO animated:YES];
				UIButton *button = [UIButton numericPadButton:@"images/button.done.png"];
				[button setTitle:@"edit" forState:UIControlStateNormal];
				[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
				button.titleLabel.textColor = MAINCOLOR;
				[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
				[button addTarget:self action:@selector(editFunction:) forControlEvents:UIControlEventTouchUpInside];
				UIBarButtonItem * favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
				button.tag = 0;
				
				self.navigationItem.rightBarButtonItem = favorite;
				self.navigationItem.rightBarButtonItem.tag = 0;
				[favorite release];
				
				[self.tableView reloadData];
			}
		}
		
		[self.view setNeedsDisplay];
		XQDebug(@"\nitemID:= %d , opinionID;= %d\n", self.it.itemID, it.ID);
        StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
		[api removeOpinions:self.it.itemID opinionID:it.ID andPassword: del.user.password];
		[it release];
	}
}


#pragma mark Table view creation (UITableViewDataSource)


- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	XQDebug(@"\nChange to begin edit mode\n");
	[self.tableView setEditing:YES animated:YES];
	UIButton *button = [UIButton numericPadButton:@"images/button.done.png"];
	[button setTitle:@"done" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	
	[button addTarget:self action:@selector(editFunction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	button.tag = 1;
	
	self.navigationItem.rightBarButtonItem = favorite;
	self.navigationItem.rightBarButtonItem.tag  = 1;
	[favorite release];
	
	//[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]].hidden = YES;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	XQDebug(@"\nHEllo-----------\n");
	
	if ([indexPath row] == [self.entries count]) {
		XQDebug(@"\n	if ([indexPath row] == [self.entries count]) {\n");
		return 	UITableViewCellEditingStyleNone;
	}
	
	if ([entries count] >= 1) {
		
		Opinion* iRecord = [entries objectAtIndex:0];
		if(!([entries count] > 1 || ([entries count] == 1 && iRecord.ID != -1111))) //!([parsedData count] > 1 || ([parsedData count] == 1 && iRecord.ID != -1111))
		{
			return UITableViewCellEditingStyleNone;
		}
	}
	
	return UITableViewCellEditingStyleDelete;
}



- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView setEditing:NO animated:YES];
	 UIButton *button = [UIButton numericPadButton:@"images/button.done.png"];
	[button setTitle:@"edit" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	[button addTarget:self action:@selector(editFunction:) forControlEvents:UIControlEventTouchUpInside];
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
	
	XQDebug(@"\nChange state for table view cell<<<<<<<<<<<<<<<<\n");
	
	Opinion *it = (Opinion*)[self.entries objectAtIndex:[indexPath row]];
    StylelogueAppDelegate *del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];

    if (del.user.user_id != it.owner.user_id) {
        
        NSString * mess = [NSString stringWithFormat:@"You don't own this item."];
        UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Confirmation" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];

        [alertView show];
        [alertView release];
        return;
    }
	
	NSString * mess = [NSString stringWithFormat:@"Are you sure you want to remove this opinion?"];
	UISilentView *alertView = [[UISilentView alloc] initWithTitle:@"Confirmation" message:mess delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	alertView.tag = [indexPath row];
	[alertView show];
	[alertView release];
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
			
			Opinion* iRecord = [entries objectAtIndex:0];
			if(!([entries count] > 1 || ([entries count] == 1 && iRecord.ID != -1111))) 
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
	
	
	
	if ([indexPath row] >= 0 && [indexPath row] < [self.entries count]) {
		NSString *text = ((Opinion*)[self.entries objectAtIndex:[indexPath row]]).content;
		XQDebug(@"\n%@\n", text);
		
		CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
		
		CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
		CGFloat height = size.height;		
		return height + (CELL_CONTENT_MARGIN * 2);	
	}
	return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	
	if (_reloading) {
		return;
	}
	
	if ([self.entries count] == indexPath.row) {
			
		if (![((CustomCell*)[self.tableView cellForRowAtIndexPath:indexPath]).stateLabel.text isEqualToString:@"No More Opinions..."]) {
			
			if ([((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]) viewWithTag:111]) {
				return;
			}
			
			
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];	
			UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
			[indicator setWidth:LOADDINGSIZE];
			[indicator setHeight:LOADDINGSIZE];
			[indicator setTop:(60 - LOADDINGSIZE)/2];
			[indicator setLeft:10];
			[((CustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.entries count] inSection:0]]) addSubview:indicator];
			indicator.tag = 111;
			[indicator startAnimating];
			[indicator release];
			[self.api setDelegate:self];
			[self.api listOpinionsOfQuestion:it.question.qID numberOpinionsPerpage:20 pageNum:++currentPage];
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
			
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"OpinionCustomCell" owner:self options:nil];
			
			for (id currentObject in topLevelObjects){
				if ([currentObject isKindOfClass:[UITableViewCell class]]){
					cell =  (CustomCell*) currentObject;
					break;
				}
			}
		}
		
		cell.capitalLabel.text = @"";
		
		cell.rate.text = @"";
		cell.stateLabel.text=@"Loading...";
		cell.stateLabel.top = MORE_POSITION;
		
		cell.capitalLabel.hidden = YES;
		cell.img.hidden = YES;
		cell.userInteractionEnabled = NO;
		[cell setHidden:YES];
		return cell;
    }
	
	CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentify];
	if (cell == nil) {
		
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"OpinionCustomCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (CustomCell*) currentObject;
				break;
			}
		}
	}
	
	[cell.stateLabel setLineBreakMode:UILineBreakModeWordWrap];
	[cell.stateLabel setMinimumFontSize:FONT_SIZE];
	[cell.stateLabel setNumberOfLines:0];
	[cell.stateLabel setFont:[UIFont fontWithName:FONT size:FONT_SIZE]];
	
	[cell.stateLabel setTag:1];

	[cell.capitalLabel setFont:[UIFont fontWithName:FONT size:CAPITALSIZE]];
	
	cell.stateLabel.textColor = MAINCOLOR;
	
	cell.rate.textColor = DATECOLOR;
	[cell.rate setFont:[UIFont fontWithName:FONT size:12]];
	cell.tag = 999;
	
    if (nodeCount > 0)
	{
		
		self.it.question.number_of_opinions = [self.entries count]; 
		
		if (indexPath.row == nodeCount) {
			
			XQDebug(@"\nif (indexPath.row == nodeCount) {\n");
			cell.capitalLabel.text = @"";
			
			cell.rate.text = @"";
			cell.stateLabel.text=@"More Opinions...";
			cell.stateLabel.textColor = MAINCOLOR;
			[cell.stateLabel setTop:cell.stateLabel.top - 20];
			cell.capitalLabel.hidden = YES;
			cell.img.hidden = YES;
			
			UIView *selectedView = [UIView viewWithBackgroundColor:RGBACOLOR(0x06,0x06,0x06,0)];
			[selectedView setFrame:cell.frame];
			[selectedView setAlpha:0.2];
			cell.selectedBackgroundView = selectedView;
			[cell.selectedBackgroundView setAlpha:0.1];
			
//			UIImage *arrowImage = [UIImage imageNamed: @"images/arrow.png"];
//			UIImage *arrowHighlightedImage = [UIImage imageNamed:@"images/arrow.new.png"];
//			UIButton *button = [[UIButton alloc] init];
//			[button setUserInteractionEnabled:NO];
//			[button setFrame:CGRectMake(cell.frame.size.width-5-arrowImage.size.width, (cell.frame.size.height-arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
//			[button setImage:arrowImage forState:UIControlStateNormal];
//			[button setImage:arrowHighlightedImage forState:UIControlStateHighlighted];
//		

			if (displayMoreStyles) {
				cell.hidden = NO;
			}else {
				cell.hidden = YES;
			}
			
			
			return cell;
		}else
		{
			XQDebug(@"\n----------1111111111111\n");
			Opinion *iRecord = [[self.entries objectAtIndex:indexPath.row] retain];
			cell.capitalLabel.text = iRecord.owner.name;//iRecord.owner.fb_user_id;//replace the name of this user here

			
			CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
			
			CGSize size = [iRecord.content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];

			[cell.stateLabel setText:iRecord.content];
			[cell.stateLabel setFrame:CGRectMake(round(cell.stateLabel.left), round(cell.capitalLabel.top + cell.capitalLabel.height + 5), CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), size.height)];
			//cell.stateLabel.backgroundColor = [UIColor redColor];
			
			//cell.stateLabel.text = iRecord.content;
			cell.rate.text = iRecord.posted_at;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;

			if (iRecord.ID == -1111) {
				
				XQDebug(@"\n----------1111111111111\n");
				cell.userInteractionEnabled = NO;
				
				cell.capitalLabel.hidden = YES;
				cell.stateLabel.hidden = NO;
				
				cell.stateLabel.left = 90;
				cell.rate.hidden = YES;
				cell.img.hidden = YES;
				self.it.question.number_of_opinions = 0; 
				[iRecord release];
				return cell;	
			}
			
			if (iRecord.owner.like_item) {
				
				cell.img.image = [UIImage imageNamed:@"images/icon.liked.item.png"];
				cell.img.width = cell.img.image.size.width/1.5;
				cell.img.height = cell.img.image.size.height/1.5;
				cell.img.top = cell.capitalLabel.top - 2;
				cell.img.left =cell.capitalLabel.left - 30;
			}else
			{
				cell.img.image = [UIImage imageNamed:@"images/icon.like.item.png"];
				cell.img.width = cell.img.image.size.width/1.5;
				cell.img.height = cell.img.image.size.height/1.5;
				cell.img.top = cell.capitalLabel.top - 2;
				cell.img.left =cell.capitalLabel.left - 30;
			}
			
			[iRecord release];
		}
		
    }
    return cell;
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
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
}

- (void)dealloc {
	
	self.textFieldRoundedWrapper = nil;
	self.textFieldForAddionalNotes = nil;
	self.backgroundImage = nil;
	self.selectedImage = nil;
	self.backGround = nil;
	self._refreshHeaderView = nil;
	self.entries = nil;
	self.imageDownloadsInProgress = nil;

	self.api = nil;
	self.it = nil;
	self.tableView = nil;
	self.names = nil;
    [super dealloc];
}

@end

