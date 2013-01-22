//
//  NSOperationQueue.m
//
//
// on 8/2/10.
// Rubify. All rights reserved.
//

#import "NSOperationQueue+MainOperation.h"


@implementation NSOperationQueue(operationProcess)

+ (NSOperationQueue *)onlyMainQueue
{
	return [NSOperationQueue mainQueue];
	return [[[NSOperationQueue alloc] init] autorelease];
}

@end
