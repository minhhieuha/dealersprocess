//
//  NSNotificationOperation.m
//
//
// on 7/21/10.
// Rubify. All rights reserved.
//

#import "NSNotificationOperation.h"
#import "NSNotificationPoster.h"

@implementation NSNotificationOperation

@synthesize notificationName;
@synthesize notificationArgument;

- (id)initWithName:(NSString *)name andArgument:(id)argument
{
	if (![super init]) return nil;
	self.notificationName = name;
	self.notificationArgument = argument;
	return self;
}

- (void)dealloc {
	self.notificationName = nil;
	self.notificationArgument = nil;
    [super dealloc];
}

- (void)main {
	[NSNotificationCenter shootNotification:self.notificationName withObject:self.notificationArgument]; 
}

@end



@implementation NSObject(OperationSimplified)

- (void)addOperationToQueue:(NSOperationQueue *)queue withMethod:(SEL)selector
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSInvocationOperation *operation = [[[NSInvocationOperation alloc] 
										 initWithTarget:self
										 selector:selector
										 object:NULL] autorelease];
	[queue addOperation:operation];
	[pool drain];
}

- (void)addOperationToQueue:(NSOperationQueue *)queue withMethod:(SEL)selector withArgument:(id)argument
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	NSInvocationOperation *operation = [[[NSInvocationOperation alloc] 
										 initWithTarget:self
										 selector:selector
										 object:argument] autorelease];
	[queue addOperation:operation];
	[pool drain];
}

@end