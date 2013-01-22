//
//  AppMainNavigationController.m
//  Stylelogue
//


//

#import "AppMainNavigationController.h"


@implementation AppMainNavigationController

@synthesize userID;
@synthesize questions;
//@synthesize facebook;
@synthesize delegate;
@synthesize goFrom;
@synthesize facebookName;
//@synthesize session;
@synthesize deviceToken;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return YES;
	}
	return NO;
}

-(void)dealloc
{
	[super dealloc];
	self.userID = nil;
	self.questions = nil;
//	self.facebook = nil;
	self.facebookName = nil;
//	self.session = nil;
	self.deviceToken = nil;
}

@end
