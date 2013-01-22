//
//  NSString+Base64.m
//  trackasave
//
// on 6/13/10.
// Rubify. All rights reserved.
//

#import "NSString+Base64.h"


@implementation NSString(Base64NSObject)

-(NSString *)base64String
{
	return [[self dataUsingEncoding:NSASCIIStringEncoding] base64EncodedString];
}

- (NSMutableString *)decodedBase64String
{
	NSData *urlDataDecoded = [NSData dataFromBase64String:self];
	NSMutableString *requestString = [[NSMutableString alloc] initWithData:urlDataDecoded encoding:NSASCIIStringEncoding];
	return [requestString autorelease];
}

@end