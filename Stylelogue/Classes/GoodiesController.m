    //
//  GoodiesController.m
//  Stylelogue
//


//

#import "GoodiesController.h"
#import "GradientView.h"
#import "ColorDirective.h"
#import "UIViewExtension.h"


@implementation GoodiesController

@synthesize goodies;
@synthesize opinionsView;
@synthesize api;
@synthesize addToLookbook;
@synthesize addText;
@synthesize shareButton;
@synthesize shareLabel, loginToolbar;


- (id)initWithGoody:(Goody*)goodies
{
	self = [super init];
	
	self.goodies = goodies;
	
    XQDebug(@"\nGoody: %@\n", goodies._description);
    
	self.navigationItem.titleView = [FontLabel titleLabelNamed:goodies.title];
	
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];
	
	UIWebView *opinionsView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 355)];
	[self setOpinionsView:opinionsView];
	[opinionsView release];
	self.opinionsView.backgroundColor = [UIColor blackColor];
	[self.opinionsView loadHTMLString: self.goodies._description baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

	[self.view addSubview:self.opinionsView];
	
	UIView *toolbar = [[GradientView alloc] initWithFrame:CGRectMake(0, 357, 320, 60)];
	[self.view addSubview:toolbar];
	
	UIButton *addButton = [UIButton numericPadButton: @"images/icon.share.it.png"];
	[addButton addTarget:self action:@selector(shareGoody:) forControlEvents:UIControlEventTouchUpInside];
	self.shareButton = addButton;
	
	[addButton setLeft:140 - 70];
	[addButton setTop:(toolbar.height - addButton.height)/2 - 10];
	[toolbar addSubview:addButton];
	
	UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
	self.shareLabel = shareLabel;
	[shareLabel setText:@"Share"];
	[shareLabel setFont:[UIFont fontWithName:FONTREGULAR size:TOOLBARSIZE]];
	[shareLabel setTop:addButton.height - 22];
	[shareLabel setTextColor:MAINCOLOR];
	[shareLabel setBackgroundColor:[UIColor clearColor]];
	[shareLabel setLeft:addButton.left + 3];
	[toolbar addSubview:shareLabel];
	[shareLabel release];

	addButton = [UIButton numericPadButton: @"images/icon.add.to.looksbook.png"];
	[addButton addTarget:self action:@selector(addToLooksBook:) forControlEvents:UIControlEventTouchUpInside];
	[self setAddToLookbook: addButton];
	
	[addButton setLeft:320 - 75 - addButton.width/2 - 15];
	[addButton setTop:(toolbar.height - addButton.height)/2 - 10];
	[toolbar addSubview:addButton];
	
	UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
	self.addText = addLabel;
	[addLabel setText:@"Add"];
	[addLabel setFont:[UIFont fontWithName:FONTREGULAR size:TOOLBARSIZE]];
	[addLabel setTop:self.shareLabel.top];
	[addLabel setTextColor:MAINCOLOR];
	[addLabel setBackgroundColor:[UIColor clearColor]];
	[addLabel setLeft:addButton.left - 5];
	[toolbar addSubview:addLabel];
	[addLabel release];
	[toolbar release];

	UIButton *button = [UIButton numericPadButton:@"images/button.back.png"];
	[button setTitle:@"back" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	
	XQDebug(@"\nCancel cancel\n");
	[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.leftBarButtonItem = favorite;
	[favorite release];
	AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
	self.api = [APIController api];
	self.api.userID = mainController.userID;
	
	
	if (goodies.current_user_lookbook) {

		[self.addToLookbook setBackgroundImage:[UIImage imageNamed:@"images/icon.remove.opinion.orange.png"] forState:UIControlStateNormal];
		[self.addToLookbook setNeedsDisplay];
		addText.text = @"Remove";
		addText.left = addToLookbook.left;
	}else {
		[self.addToLookbook setBackgroundImage:[UIImage imageNamed:@"images/icon.add.to.looksbook.png"] forState:UIControlStateNormal];
		[self.addToLookbook setNeedsDisplay];
		addText.text = @"Add";
		addText.left = addToLookbook.left + 8;
	}
	
	//AppMainNavigationController* mainController = (AppMainNavigationController*)self.navigationController;
	if (mainController.goFrom == 3) {
		
		self.addToLookbook.hidden = YES;
		self.addText.hidden = YES;
		self.shareButton.left = 140;
		self.shareLabel.left = 140;
		
	}else {
		self.addToLookbook.enabled = YES;
		addText.enabled = YES;
		//addText.left = addToLookbook.left + 5;
	}
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
        
        UIButton *button = [UIButton numericPadButton:@"images/login.share.png"];
        [button setTitle:@"share" forState:UIControlStateNormal];
        [button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE + 2]];
        button.titleLabel.textColor = [UIColor whiteColor];
        [button.titleLabel  setTextAlignment:UITextAlignmentCenter];

        [button addTarget:self action:@selector(shareGoody:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.rightBarButtonItem = favorite;
        [favorite release];
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

-(void)addToLooksBook:(id)sender
{
	XQDebug(@"\nHello lookbook: %d\n", self.goodies.current_user_lookbook);
	if (!goodies.current_user_lookbook) {
		goodies.current_user_lookbook = YES;
		[self.addToLookbook setBackgroundImage:[UIImage imageNamed:@"images/icon.remove.opinion.orange.png"] forState:UIControlStateNormal];
		[self.addToLookbook setNeedsDisplay];
		addText.text = @"Remove";
		addText.left = addToLookbook.left ;
		[self.api addGoodyToLookbook:self.goodies.itemID];
	}else {
		goodies.current_user_lookbook = NO;
		[self.addToLookbook setBackgroundImage:[UIImage imageNamed:@"images/icon.add.to.looksbook.png"] forState:UIControlStateNormal];
		[self.addToLookbook setNeedsDisplay];
		[self.api removeFromLookbook:goodies.itemID type:goodies.type];
		addText.text = @"Add";
		addText.left = addToLookbook.left + 8;
	}
}

-(void)shareGoody:(id)sender
{
	UIImage *originImage = nil;
	SharePhotoPageController *shareQuestionController = [[SharePhotoPageController alloc] initWithImage:originImage thumbail:nil  times:NO itemID:self.goodies.GID];
	//self.goodies.photo_url = @"http://stylelogue.it/goodies";
	self.goodies.give_opinion_url = @"http://stylelogue.it/goodies";
	shareQuestionController.url = self.goodies.photo_url;
	XQDebug(@"url=%@", self.goodies.photo_url);
	self.goodies.question.additional_note = self.goodies.question.content;
	shareQuestionController.textToShare = [NSString stringWithFormat:@"%@ %@", self.goodies.question.content, self.goodies.question.additional_note];
	shareQuestionController.give_opinion_url = self.goodies.give_opinion_url;
	shareQuestionController.photo = self.goodies.photo;
	
	XQDebug(@"\nself.goodies.photo=%@\n", self.goodies.photo_url);
	[self.navigationController pushViewController:shareQuestionController animated:YES];
	[shareQuestionController removePageControl];
	[shareQuestionController release];
}

-(void)backFunction
{
	[self.navigationController popViewControllerAnimated:YES];
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

- (void)dealloc {
	
	self.addToLookbook = nil;
	self.goodies = nil;
	self.opinionsView = nil;
	self.api = nil;
	self.addText = nil;
	self.shareButton = nil;
	self.shareLabel = nil;
    self.loginToolbar = nil;
    [super dealloc];

}


@end
