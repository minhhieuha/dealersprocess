//
//  NSString+Formatter.m
//
//
// on 8/4/10.
// Rubify. All rights reserved.
//

#import "NSString+Formatter.h"


@implementation NSString(Formatter)

- (NSString *)decimalString
{
	NSNumberFormatter *decimalFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[decimalFormatter setMinimumFractionDigits:0];
	[decimalFormatter setMaximumFractionDigits:3];
	return [decimalFormatter stringFromNumber:[NSNumber numberWithFloat:[self floatValue]]];
}

// kilo mega?
- (NSString *)decimalWithUnitString
{
	float v = [[self noDecimalCommaString] floatValue];
	if (v > 1000000) {
		return [NSString stringWithFormat:@"%@m", [[NSString stringWithFormat:@"%d", (int)(0.000001 * v)] decimalString]];
	}
	if (v > 1000) {
		return [NSString stringWithFormat:@"%@k", [[NSString stringWithFormat:@"%d", (int)(0.001 * v)] decimalString]];
	}
	return [NSString stringWithFormat:@"%@", [[NSString stringWithFormat:@"%d", (int)(1 * v)] decimalString]];
}

- (NSString *)twoPointDecimalString
{
	NSNumberFormatter *decimalFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[decimalFormatter setMinimumFractionDigits:2];
	[decimalFormatter setMaximumFractionDigits:3];
	return [decimalFormatter stringFromNumber:[NSNumber numberWithFloat:[self floatValue]]];
}

- (NSString *)noDecimalCommaString
{
	return [self stringByReplacingOccurrencesOfString:@"," withString:@""];
}

@end
