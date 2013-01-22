//
//  ForgotPasswordController.m
//  Stylelogue
//
//  Created by Quang Nguyen on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ForgotPasswordController.h"


@implementation ForgotPasswordController

- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.titleView = [FontLabel titleLabelNamed3:@"Recover Password"];
        UIButton *button = [UIButton numericPadButton:@"images/button.back.png"];
		[button setTitle:@"back" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
        UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = favorite;
        [favorite release];
    }
    return self;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[[SHKActivityIndicator currentIndicator] hide];
}

- (void)loadView
{
    [super loadView];
    UIWebView *opinionsView = [[UIWebView alloc] initWithFrame: self.view.bounds];
	opinionsView.backgroundColor = [UIColor blackColor];
    opinionsView.delegate = self;
	[opinionsView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:@"http://stylelogue.it/users/password/new"]]];//will change this url to the recover password url
    [[opinionsView.subviews objectAtIndex:0] setScrollEnabled:NO];  //to stop scrolling completely
    [[opinionsView.subviews objectAtIndex:0] setBounces:NO]; //to stop bouncing
    
	[self.view addSubview:opinionsView];
    [opinionsView release];
    
    XQDebug(@"\nawehoiahwipeceqrceaaewcwaecc srva===========\n");
    
    [self.view addSubview: [SHKActivityIndicator currentIndicator]];
    [[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Loading...")];
	[[SHKActivityIndicator currentIndicator] setTop:150];
}

-(void)sendEmail:(id)sender
{
    XQDebug(@"\nsend email to recover password\n");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
