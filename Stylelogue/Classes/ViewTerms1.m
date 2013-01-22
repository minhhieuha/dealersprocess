//
//  ViewTerms.m
//  Stylelogue
//
//  Created by Peter Quang Nguyen on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewTerms.h"


@implementation ViewTerms1


-(void)backFunction
{
	[[SHKActivityIndicator currentIndicator] hide];
	[self.navigationController popViewControllerAnimated:YES];
}

- (id)init {
	
    if ((self = [super init])) {
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Privacy Policy"];
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
	}
	return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];
	
	UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
	
	NSURLRequest *url = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://stylelogue.it/legal/privacy"]];
	
	web.delegate = self;
	[web loadRequest:url];
	web.backgroundColor = [UIColor blackColor];
	[self.view addSubview:web];
	[web release];
	
	//[self.view addSubview:[SHKActivityIndicator currentIndicator]];
	[[SHKActivityIndicator currentIndicator] displayActivity:SHKLocalizedString(@"Loading...")];
	[[SHKActivityIndicator currentIndicator] setTop:200];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[[SHKActivityIndicator currentIndicator] hide];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
