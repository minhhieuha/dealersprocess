
//
//  ViewDetailController.m
//  Stylelogue
//XQDebug
//  Created by Nguyen Xuan Quang on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewDetailController.h"

#define minval(a,b) (a<b?a:b)

@implementation ViewDetailController

@synthesize entries;
@synthesize horizontalView;
@synthesize opinionButton;
@synthesize removeButton;
@synthesize likeButton;
@synthesize imageDownloadsInProgress;
@synthesize api;
@synthesize index;
@synthesize backGround;
@synthesize fullScreenView;
@synthesize fullScreenImage;
@synthesize lock;
@synthesize r;

@synthesize addLabel;
@synthesize removeLabel;	
@synthesize likeLabel;
@synthesize allowLock, loginToolbar;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithEntries:(NSMutableArray*)entries selectedIndex:(int)index lockScroll:(BOOL)allowLock{
	
    self = [super init];
    if (self) {
		
		self.allowLock = allowLock;
		self.entries = entries;
		self.index = index;

		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Need Opinions"];
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
	[self.fullScreenView removeFromSuperview];
	[self.backGround removeFromSuperview];
	[self.fullScreenView removeFromSuperview]; 
	
	[self.api cancelDownLoad];
	[self cancelDownloading];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelDownloading
{
	XQDebug(@"\nCancel downloading...\n");
	if (self.imageDownloadsInProgress) {
		
		NSArray *keys = [self.imageDownloadsInProgress allKeys];
		
		for (NSIndexPath *index in keys) {
			IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:index];
			if (iconDownloader) {
				iconDownloader.delegate = nil;
				[iconDownloader cancelDownload];
			}
		}
	}
}

-(void)setTextForMenuBar:(Item*)it
{
	if (it.current_user_lookbook) {

		[removeLabel setTop:self.addLabel.top];
		[removeLabel setLeft:removeButton.left - 1];
		[removeLabel setText:@"Remove"];
		
	}else {

		[removeLabel setTop:self.addLabel.top];
		[removeLabel setLeft:removeButton.left + 8];
		[removeLabel setText:@"Add"];
	}
	
	if (it.current_user_like) {
		
		[likeLabel setTop:self.addLabel.top];
		[likeLabel setLeft:likeButton.left + 5];
		[likeLabel setText:@"Unlike"];
	}else {
		
		[likeLabel setTop:self.addLabel.top];
		[likeLabel setLeft:likeButton.left + 8];
		[likeLabel setText:@"Like"];
	}

}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	XQDebug(@"\n->>>>>>>>>>>>>>>>>>Begin to load details view<<<<<<<<<<<<<<<<<<============\n");
	[super loadView];
	
	NSMutableDictionary *imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
	[self setImageDownloadsInProgress:imageDownloadsInProgress];
	[imageDownloadsInProgress release];
	CGRect frameRect	= CGRectMake(0, 12, 320, 405);
	EasyTableView *horizontalView	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:[self.entries count] ofWidth:320];
	[self setHorizontalView:horizontalView];
	[horizontalView release];
	
	self.horizontalView.delegate						= self;
	self.horizontalView.tableView.backgroundColor	= [UIColor blackColor];
	self.horizontalView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.horizontalView.cellBackgroundColor			= [UIColor blackColor];
	self.horizontalView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	
	if (allowLock) {
		
		self.horizontalView.tableView.scrollEnabled = NO;
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stylelogue.title.png"]] autorelease];//[FontLabel titleLabelNamed2:@"STYLELOGUE"];
		self.navigationItem.titleView.height -= 18;
		self.navigationItem.titleView.width -= 18; 
	}
	[self.view addSubview:self.horizontalView];
	
	UIButton *button = [UIButton numericPadButton:@"images/button.hot.png"];
	[button setTitle:@"share" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	
	[button addTarget:self action:@selector(gotoSharePage) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.rightBarButtonItem = favorite;
	[favorite release];
	
	self.opinionButton = [UIButton numericPadButton: @"images/icon.read.opinion.png"];
	[self.opinionButton addTarget:self action:@selector(readButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.opinionButton.titleLabel setFont:[UIFont fontWithName:FONTREGULAR size:OPINIONNUMBERSIZE]];
	self.opinionButton.titleLabel.textColor = MAINCOLOR;
	
	UIView *toolbar = [[GradientView alloc] initWithFrame:CGRectMake(0, 365 , 320, 60)];
	[toolbar setBackgroundColor:[UIColor clearColor]];
	[toolbar setNeedsDisplay];
	[self.view addSubview:toolbar];
	
	[self.opinionButton setLeft:160-80 - self.opinionButton.width];
	[self.opinionButton setTop:(toolbar.height - self.opinionButton.height)/2 - 10];
	[toolbar addSubview:self.opinionButton];
	
	
	UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
	[self setAddLabel:addLabel];
	[addLabel release];

	
	[self.addLabel setText:@"Opinions"];
	[self.addLabel setFont:[UIFont fontWithName:FONTREGULAR size:TOOLBARSIZE]];
	[self.addLabel setTop:self.opinionButton.height - 24];
	[self.addLabel setTextColor:MAINCOLOR];
	[self.addLabel setBackgroundColor:[UIColor clearColor]];
	[self.addLabel setLeft:self.opinionButton.left - 3];
	[toolbar addSubview:self.addLabel];
	
	
	self.likeButton = [UIButton numericPadButton: @"images/icon.like.item.png"];
	[self.likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

	[self.likeButton setLeft:160 + 80];
	
	[self.likeButton setTop:(toolbar.height - self.likeButton.height)/2 - 10];
	[toolbar addSubview:self.likeButton];
	
	UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
	[self setLikeLabel:likeLabel];
	[likeLabel release];
	
	[self.likeLabel setText:@"Unlike"];
	[self.likeLabel setFont:[UIFont fontWithName:FONTREGULAR size:TOOLBARSIZE]];
	[self.likeLabel setTop:self.likeButton.height];
	[self.likeLabel setTextColor:MAINCOLOR];
	[self.likeLabel setBackgroundColor:[UIColor clearColor]];
	[self.likeLabel setLeft:self.likeButton.left + 7];
	[toolbar addSubview:self.likeLabel];

	
	self.removeButton = [UIButton numericPadButton: @"images/icon.add.to.looksbook.png"];
	[self.removeButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.removeButton setLeft:160-self.removeButton.width/2];
	[self.removeButton setTop:(toolbar.height - self.removeButton.height)/2 - 10];
	[toolbar addSubview:self.removeButton];
	AppMainNavigationController* mainController = (AppMainNavigationController*)self.navigationController;
	if (mainController.goFrom == 3) {
		self.removeButton.enabled = NO;
	}else {
		self.removeButton.enabled = YES;
	}

	UILabel *removeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
	[self setRemoveLabel:removeLabel];
	[removeLabel release];
	
	[self.removeLabel setText:@"Remove"];
	[self.removeLabel setFont:[UIFont fontWithName:FONTREGULAR size:TOOLBARSIZE]];
	[self.removeLabel setTop:self.removeButton.height];
	[self.removeLabel setTextColor:MAINCOLOR];
	[self.removeLabel setBackgroundColor:[UIColor clearColor]];
	[self.removeLabel setLeft:self.removeButton.left + 6];
	[toolbar addSubview:self.removeLabel];
	
	[toolbar release];
	
	Item *it = [self.entries objectAtIndex:self.index];
	[self setTextForMenuBar:it];

	self.api = [APIController api];
	self.api.userID = mainController.userID;
	self.horizontalView.tag = -1;
	[self.horizontalView selectCellAtIndex:self.index animated:NO];
	[self updateInterface:self.index];
	lock = NO;
	
	UIView *backGround = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[self setBackGround:backGround];
	[backGround release];
	self.backGround.backgroundColor = [UIColor blackColor];
	
	UIImageViewExtension *fullScreenImage = [[UIImageViewExtension alloc] init];
	[self setFullScreenImage:fullScreenImage];
	[fullScreenImage release];
	
	self.fullScreenImage.tag = 1;//dont allow user to rotate the image view
	[self.fullScreenImage setTop:0];
	
	UIViewWrapper *fullScreenView = [[UIViewWrapper alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[self setFullScreenView:fullScreenView];
	[fullScreenView release];
	
	self.fullScreenView.delegate = self;
	self.fullScreenView.backgroundColor = [UIColor clearColor];
	self.fullScreenView.userInteractionEnabled = YES;
	self.fullScreenView.multipleTouchEnabled = YES;
	self.fullScreenView.receiver = self.fullScreenImage;

	[[[UIApplication sharedApplication] keyWindow] addSubview:self.backGround];
	[[[UIApplication sharedApplication] keyWindow] addSubview:self.fullScreenImage];
	[[[UIApplication sharedApplication] keyWindow] addSubview:self.fullScreenView];
	
	[self.fullScreenView setFrame:[UIScreen mainScreen].applicationFrame];
	[self.backGround setFrame:[UIScreen mainScreen].applicationFrame];
	[self.backGround setAlpha:0];
	[self.fullScreenImage setAlpha:0];
	[self.fullScreenView setAlpha:0]; 
	
	self.view.backgroundColor = [UIColor blackColor];
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

//should supply the 2 images for sharing and then will commit to server
-(void)gotoSharePage
{
	Item *it = (Item*)[self.entries objectAtIndex:self.horizontalView.beginPage];
	UIImage *originImage = it.originPhoto;
	UIImage *thumnail = it.icon;
	SharePhotoPageController *shareQuestionController = [[SharePhotoPageController alloc] initWithImage:originImage thumbail:thumnail  times:NO itemID: it.itemID];
	shareQuestionController.textToShare = [NSString stringWithFormat:@"%@ %@", it.question.content, it.question.additional_note];
	shareQuestionController.url = it.photo;
	shareQuestionController.give_opinion_url = it.give_opinion_url;
	shareQuestionController.photo = it.photo;
	[self.navigationController pushViewController:shareQuestionController animated:YES];
	[shareQuestionController removePageControl];
	[shareQuestionController release];
}

#pragma mark EasyTableViewDelegate

// These delegate methods support both example views - first delegate method creates the necessary views

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
	
	UIView *template = [[[UIView alloc] initWithFrame:rect] autorelease];

	template.backgroundColor = [UIColor blackColor];
	UIImageView *originPic = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x, round(rect.origin.y+10), rect.size.width, rect.size.height)];
	originPic.tag = 1;
	[template addSubview:originPic];
	[originPic release];
	
	
	UIView *mv = [[UIView alloc] initWithFrame:CGRectMake(3, 249, 320, 150)];
	mv.userInteractionEnabled = NO;
	mv.backgroundColor = [UIColor clearColor];
	if (![self.view viewWithTag:1234]) {
		
		UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 257, 320, 108)];
		v.backgroundColor = [UIColor blackColor];
		[self.view addSubview:v];
		
		v.userInteractionEnabled = NO;
		[v setAlpha:0.7];
		[v release];
		[self.view addSubview:mv];
	}
	mv.tag = 1234;
	
	UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 28, rect.size.width, 65)];
	textView.text = @" ";
	textView.font = [UIFont fontWithName:textView.font.fontName size:12];
	textView.tag = 2;
	textView.textColor = RGBACOLOR(0xFF, 0xFF, 0xFF, 0.1);
	
	textView.textColor = MAINCOLOR;
	[textView setFont:[UIFont fontWithName:FONT size:STATESIZE - 1]];
	
	textView.backgroundColor = [UIColor clearColor];
	textView.userInteractionEnabled = NO;
	[mv addSubview:textView];
	[textView release];
	
	textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 6, rect.size.width, 40)];
	textView.text = @" ";
	textView.tag = 6;
	
	textView.textColor = MAINCOLOR;
	[textView setContentMode:UIViewContentModeTopLeft];
	[textView setFont:[UIFont fontWithName:FONT size:CAPITALSIZE]];
	
	textView.backgroundColor = [UIColor clearColor];
	textView.userInteractionEnabled = NO;
	[mv addSubview:textView];
	[textView release];
	
	UILabel *textView2 = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x + 160, mv.height - 35 - 23 , rect.size.width, 18)];
	textView2.text = @"Likes";
	textView2.tag = 4;
	textView2.textColor = [UIColor whiteColor];
	textView2.backgroundColor = [UIColor clearColor];
	
	textView2.textColor = MAINCOLOR;
	[textView2 setFont:[UIFont fontWithName:FONT size:RATESIZE]];
	
	textView2.userInteractionEnabled = NO;
	
	[mv addSubview:textView2];
	[textView2 release];
	
	int n = 50*3;
	DrawLine *dr = [[DrawLine alloc] initWithFrame:CGRectMake(rect.origin.x + 8,mv.height - 35 - 21 , n, 10)];
	
	dr.tag = 3;
	[mv addSubview:dr];
	[dr setTop:dr.top + 5];
	[dr release];
	
	CGFloat width = 30;
	CGFloat height = 30;
	
	
	CGRect centeredFrame = CGRectMake(round([[UIApplication sharedApplication] keyWindow].bounds.size.width/2 - width/2),
									  round([[UIApplication sharedApplication] keyWindow].bounds.size.height/2 - height/2),
									  width,
									  height);
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:centeredFrame];
	[template addSubview: spinner];
	[spinner setHidden:YES];
	spinner.tag = 5;
	[spinner release];
	[mv release];
	
	return template;
}

- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndex:(NSUInteger)index {
	
	Item *it = (Item*)[entries objectAtIndex:index];

	UIImageView *fullImg = (UIImageView *)[view viewWithTag:1];
	if (!it.originPhoto) {
		UIImage *image = [UIImage imageNamed:@"images/Placeholder.png"];
		[fullImg setHeight:fullImg.width/image.size.width*image.size.height];
		fullImg.image = nil;	
		
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
		[self startIconDownload:it forIndexPath:indexPath];
		UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[view viewWithTag:5];
		[indicator startAnimating];
		[indicator setHidden:NO];

	}else {
		XQDebug(@"\nimage --- setting -- \n");
		UIImage *image = it.originPhoto;
		[fullImg setHeight:fullImg.width/image.size.width*image.size.height];
		fullImg.image = image;
		
		if (it.originImageHaveLoaded) {
			UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[view viewWithTag:5];
			[indicator stopAnimating];
			[indicator setHidden:YES];
		}
	}

	self.likeButton.tag = index;
	self.removeButton.tag = index;
	self.opinionButton.tag = index;
}

-(void)tap
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	[self.view setNeedsDisplay];
	
	[UIView beginAnimations:nil context:nil];
	[UIView	setAnimationDuration:0.5];
	[self.backGround setAlpha:0];
	[self.fullScreenImage setAlpha:0];
	[self.fullScreenView setAlpha:0]; 
	[UIView commitAnimations];
	self.horizontalView.tag = 0;
	XQDebug(@"\npress -(void)tap\n");
}

-(void)unlockAnimation
{
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	lock = NO;
}

- (void)easyTableView:(EasyTableView *)easyTableView selectedView:(UIView *)selectedView atIndex:(NSUInteger)index deselectedView:(UIView *)deselectedView {
	
	if (easyTableView.tag != -1 && !lock) {
		
		if ((index >= 0) && (index < [self.entries count])) {
			
			XQDebug(@"\nRow for select: %d\n", index);
			
			[self.navigationController.view setFrame:CGRectMake(0, 0, 320, 480)];
			self.navigationController.view.backgroundColor = [UIColor blackColor];
			
			Item *it = (Item*)[entries objectAtIndex:index];
			
			if (!it.originPhoto) {
				return;
			}
			
			lock = YES;
			
			UIImageView *fullImg = (UIImageView *)[selectedView viewWithTag:1];
			
			[self.fullScreenImage setFrame:fullImg.frame];
			[self.fullScreenImage setTop:20+30];
			
			[self.view bringSubviewToFront:self.fullScreenImage];
			self.fullScreenImage.image = it.originPhoto;
			XQDebug(@"\nSize of image: w=%f, h=%f\n", 320/it.originPhoto.size.width*it.originPhoto.size.width, 320/it.originPhoto.size.width*it.originPhoto.size.height);

			r = CGRectMake(0,0,320,480);
			[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
			[self.view setBackgroundColor:[UIColor blackColor]];
			[self.view setNeedsDisplay];
			[self.fullScreenImage setFrame:r];
			[UIView beginAnimations:nil context:nil];
			[UIView	setAnimationDuration:0.5];
			[self.backGround setAlpha:1];
			[self.fullScreenImage setAlpha:1];
			[self.fullScreenView setAlpha:1];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(unlockAnimation)];
			[UIView commitAnimations];
			easyTableView.tag  = 1;
		}
		
	}else {
		
		easyTableView.tag = 0;
	}
}

- (void)updateInterface:(int)currentRow
{
	XQDebug(@"\nUpdate interface<<<<<<<<<<<<<<<<<<<============\n");
	if (currentRow >=0 && currentRow < [self.entries count]) {
		
		
		Item *it = [self.entries objectAtIndex:currentRow];
		
		//self.title = it.question.content;
		DrawLine *dr = (DrawLine *)[[self.view viewWithTag:1234] viewWithTag:3];
		CGRect r = dr.frame;
		int n = it.number_of_likes;
		
		int width = 170.0/50;
		CGFloat lineColorWidth = minval(170, width*(it.number_of_likes+(it.number_of_likes > 0?1:0)));
		r.size.width = lineColorWidth;
		
		[dr setHeight:5];
		[dr setWidth:r.size.width];
		[dr setNeedsDisplay];
		
		UITextView *opinion = (UITextView *)[[self.view viewWithTag:1234]  viewWithTag:2];
		opinion.text = it.question.additional_note;
		opinion.left = round(opinion.left);
		opinion.top = round(opinion.top);
		opinion = (UITextView *)[[self.view viewWithTag:1234]  viewWithTag:6];
		opinion.text = it.question.content;
		opinion.left = round(opinion.left);
		opinion.top = round(opinion.top);
		
		UILabel *like = (UILabel*)[[self.view viewWithTag:1234]  viewWithTag:4];
		CGRect r1 = like.frame;
		r1.origin.x = r.size.width + r.origin.x + (n!=0?5:0);
		[like setFrame:r1];
		
		NSLog(@"%@", NSStringFromCGRect(r1));
		NSLog(@"%@", like);
		NSLog(@"%f", like.font.pointSize);
		
		like.text = [NSString stringWithFormat:@"%d Likes",  it.number_of_likes];
		
		
		XQDebug(@"\n[NSString stringWithFormat:,it.question.number_of_opinions]=%@\n", [NSString stringWithFormat:@"%d",it.question.number_of_opinions]);
		if (![self.opinionButton.titleLabel.text isEqualToString:[NSString stringWithFormat:@"%d",it.question.number_of_opinions]]) {
			[self.opinionButton setTitle:[NSString stringWithFormat:@"%d",it.question.number_of_opinions] forState:UIControlStateNormal];
			[[self.opinionButton titleLabel] adjustWidth:15];
		}
		
		self.likeButton.tag = currentRow;
		self.removeButton.tag = currentRow;
		self.opinionButton.tag = currentRow;
		
		AppMainNavigationController* mainController = (AppMainNavigationController*)self.navigationController;
		if (mainController.goFrom == 3) {
			
			self.removeButton.hidden = YES;
			self.removeLabel.hidden = YES;
			self.opinionButton.left = 60;
			self.likeButton.left = 220;
			self.addLabel.left = 58;
			self.likeLabel.left = 220;
		}else {
			
			self.removeButton.enabled = YES;
			removeLabel.enabled = YES;
			if (it.current_user_lookbook) {
				[self.removeButton setBackgroundImage:[UIImage imageNamed:@"images/icon.remove.opinion.orange.png"] forState:UIControlStateNormal];
			}else {
				[self.removeButton setBackgroundImage:[UIImage imageNamed:@"images/icon.add.to.looksbook.png"] forState:UIControlStateNormal];
			}
			
		}

		if (it.current_user_like) {
			[self.likeButton setBackgroundImage:[UIImage imageNamed:@"images/icon.liked.item.png"] forState:UIControlStateNormal];
		}else {
			[self.likeButton setBackgroundImage:[UIImage imageNamed:@"images/icon.like.item.png"] forState:UIControlStateNormal];
		}
		
		[self setTextForMenuBar:it];
	}

}

#pragma mark -


#pragma mark Region for function to process the detail view for each item


-(IBAction)readButtonClicked:(id)sender
{		
	UIButton *bt = (UIButton*)sender;
	Item *it = (Item*)[self.entries objectAtIndex:bt.tag];		
	GiveopinionController *giveOpinionController = [[GiveopinionController alloc] initWithItem:it];
	[self.navigationController pushViewController:giveOpinionController animated:YES];
	[giveOpinionController release];
}

-(IBAction)removeButtonClicked:(id)sender
{
	
	UIButton *bt = (UIButton*)sender;
	XQDebug(@"\nCurrent Index is: %d\n", bt.tag);
	Item *it = [self.entries objectAtIndex:bt.tag];
	it.current_user_lookbook = !it.current_user_lookbook;
	if (it.current_user_lookbook) {
		[self.removeButton setBackgroundImage:[UIImage imageNamed:@"images/icon.remove.opinion.orange.png"] forState:UIControlStateNormal];
		[self.removeButton setNeedsDisplay];
		[self.api addToLookbook:it.itemID];
	}else {
		[self.removeButton setBackgroundImage:[UIImage imageNamed:@"images/icon.add.to.looksbook.png"] forState:UIControlStateNormal];
		[self.removeButton setNeedsDisplay];
		[self.api removeFromLookbook:it.itemID type:it.type];
	}
	[self setTextForMenuBar:it];
}

-(IBAction)likeButtonClicked:(id)sender
{
	UIButton *bt = (UIButton*)sender;
	XQDebug(@"\nCurrent Index is: %d\n", bt.tag);
	Item *it = [self.entries objectAtIndex:bt.tag];
	if (it.current_user_like) {
		
		[self.likeButton setBackgroundImage:[UIImage imageNamed:@"images/icon.like.item.png"] forState:UIControlStateNormal];
		XQDebug(@"\nUnLike\n");
		[self.api unlikeItem:it.itemID];
		it.current_user_like = NO;
		it.number_of_likes--;
		
	}else {
		
		XQDebug(@"\nLike: UserID: %@\n", it.owner.fb_user_id);
		[self.likeButton setBackgroundImage:[UIImage imageNamed:@"images/icon.liked.item.png"] forState:UIControlStateNormal];
		it.current_user_like = YES;
		it.number_of_likes++;
		[self.api likeItem:it.itemID];
	}
	
	DrawLine *dr = (DrawLine *)[[self.view viewWithTag:1234]  viewWithTag:3];
	CGRect r = dr.frame;
	int n = it.number_of_likes;
	
	if (n >=1 && n <= 10) {
		n=48;
	}else if (n >=10 && n <= 20) {
		n=2*48;
	}else if (n >=20 && n <= 30)
	{
		n=3*48;
	}else if(n >=30 && n <= 40)
	{
		n=4*48;
	}else if(n >=40 && n <= 50)
	{
		n=5*48;
	}else
	{
		n=0;
	}
	
	int width = 170.0/50;
	CGFloat lineColorWidth = minval(170, width*(it.number_of_likes+(it.number_of_likes > 0?1:0)));
	r.size.width = lineColorWidth;
	
	[dr setHeight:5];
	[dr setWidth:r.size.width];
	[dr setNeedsDisplay];
	
	UILabel *like = (UILabel*)[[self.view viewWithTag:1234]  viewWithTag:4];
	CGRect r1 = like.frame;
	r1.origin.x = round(r.size.width + r.origin.x + (n!=0?5:0));
	r1.origin.y = round(r1.origin.y);
	[like setFrame:r1];
	
	like.text = [NSString stringWithFormat:@"%d Likes",  it.number_of_likes];
	
	[self setTextForMenuBar:it];
}

#pragma mark -------------



- (void)startIconDownload:(Item *)iRecord forIndexPath:(NSIndexPath *)indexPath
{

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

- (void)loadImagesForOnscreenRows
{
    if ([self.entries count] > 0)
    {
        NSArray *visiblePaths = [self.horizontalView.tableView  indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Item *iRecord = [self.entries objectAtIndex:indexPath.row];
            
            if (!iRecord.originPhoto) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:iRecord forIndexPath:indexPath];
            }
        }
    }
}

- (void)appImageDidLoad:(NSIndexPath *)indexPath
{	

	XQDebug(@"\nHave finish download: %d\n", [indexPath row]);
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	
    if (iconDownloader != nil)
    {
        UIView *cell = (UIView*)[self.horizontalView viewAtIndex:[iconDownloader.indexPathInTableView row]];
        
		if (cell) {
			if (iconDownloader.iRecord.originPhoto ) {

				if (self.horizontalView.tag == 0) {
					UIImageView *fullImg = (UIImageView *)[cell viewWithTag:1];
					[fullImg setHeight:fullImg.width/iconDownloader.iRecord.originPhoto.size.width*iconDownloader.iRecord.originPhoto.size.height];
					fullImg.image = iconDownloader.iRecord.originPhoto;

					if (iconDownloader.iRecord.originImageHaveLoaded) {
						
						UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:5];
						[indicator stopAnimating];
						[indicator setHidden:YES];
						
					}
				}
			}
		}
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
	XQDebug(@"\n- (void)viewWillAppear:(BOOL)animated\n");
	[super viewWillAppear:animated];
	[self updateInterface:self.removeButton.tag];
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidUnload {
	
    [super viewDidUnload];
}


- (void)dealloc {
		
	self.addLabel = nil;
	self.removeLabel= nil;	
	self.likeLabel= nil;
	
	self.backGround= nil;
	self.fullScreenView= nil;
	self.fullScreenImage= nil;
		
	self.api= nil;
	self.imageDownloadsInProgress= nil;
	self.horizontalView= nil;
	self.entries= nil;
		
	self.opinionButton= nil;
	self.removeButton= nil;
	self.likeButton= nil;
		
    self.loginToolbar = nil;
    [super dealloc];
}

@end

