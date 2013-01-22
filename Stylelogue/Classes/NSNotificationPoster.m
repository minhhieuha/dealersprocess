//
//  NSNotificationPoster.m
//
//
// on 6/28/10.
// Rubify. All rights reserved.
//

#import "NSNotificationPoster.h"


@implementation NSNotificationCenter(PosterSimplified)

+ (void)shootNotification:(NSString *)selectorName
{
	[[NSNotificationCenter defaultCenter] postNotificationName:selectorName object:NULL];
}

+ (void)shootNotification:(NSString *)selectorName withObject:(id)object
{
	[[NSNotificationCenter defaultCenter] postNotificationName:selectorName object:object];
}

@end


@implementation NSObject(NotificationSimplified)

- (void)registerNotification:(NSString *)selectorName 
{
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:NSSelectorFromString(selectorName) 
												 name:selectorName 
											   object:NULL];	 
}
	 
- (void)removeRegisteredNotification:(NSString *)selectorName
{
	[[NSNotificationCenter defaultCenter] removeObserver:self 
												 name:selectorName 
											   object:NULL];	 
}

@end

	 