//
//  UISilentView.m
//  iPhonePhilipCapital
//
//  Created by Freddy Wang on 12/8/10.

//

#import "UISilentView.h"


@implementation UISilentView

static BOOL alertViewCalled;

@synthesize silentDelegate;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	alertViewCalled = NO;

	if (self.silentDelegate) {
		if ([self.silentDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
			[self.silentDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
		}
	}
	
	self.silentDelegate = nil;
	self.delegate = nil;
}

- (void)show
{
	if (![[NSThread currentThread] isMainThread]) {
		[self performSelectorOnMainThread:@selector(show) withObject:NULL waitUntilDone:YES];
		return;
	}

	if (alertViewCalled) {
		return;
	}
	
	if (self.delegate) {
		self.silentDelegate = self.delegate;
	}
	self.delegate = self;
	
	alertViewCalled = YES;
	
	[super show];
}

@end
