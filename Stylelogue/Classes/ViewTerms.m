    //
//  ViewTerms.m
//  Stylelogue
//
//  Created by Peter Quang Nguyen on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewTerms.h"


@implementation ViewTerms


-(void)backFunction
{
	[[SHKActivityIndicator currentIndicator] hide];
	[self.navigationController popViewControllerAnimated:YES];
}

- (id)init {
	
    if ((self = [super init])) {
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Terms of Service"];
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
	
	NSURLRequest *url = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://stylelogue.it/legal/terms"]];

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
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
