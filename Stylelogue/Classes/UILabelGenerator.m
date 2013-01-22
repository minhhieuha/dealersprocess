//
//  UILabelGenerator.m
//  trackasave
//
// on 5/27/10.
// Rubify. All rights reserved.
//

#import "UILabelGenerator.h"


@implementation UILabel(IMGenerator)


+ (id)smallLabel
{
	UILabel *label;
	label = [[UILabel alloc] init];
	label.font = [UIFont systemFontOfSize:12];
	label.backgroundColor = [UIColor clearColor];	
	
	return [label autorelease];
}

+ (id)smallBlackLabel
{
	UILabel *label;
	label = [self smallLabel];
	label.textColor = [UIColor blackColor];
	return label;
}

+ (id)smallWhiteLabel
{
	UILabel *label;
	label = [self smallLabel];
	label.textColor = [UIColor whiteColor];
	return label;
}

+ (id)smallBlackCenterLabel
{
	UILabel *label;
	label = [self smallBlackLabel];
	label.textAlignment = UITextAlignmentCenter;
	return label;
}

+ (id)smallWhiteCenterLabel
{
	UILabel *label;
	label = [self smallWhiteLabel];
	label.textAlignment = UITextAlignmentCenter;
	return label;
}

+ (id)normalLabel
{
	UILabel *label;
	label = [[UILabel alloc] init];
	label.font = [UIFont systemFontOfSize:15];
	label.backgroundColor = [UIColor clearColor];	
	
	return [label autorelease];
}

+ (id)normalBlackLabel
{
	UILabel *label;
	label = [self normalLabel];
	label.textColor = [UIColor blackColor];
	return label;
}

+ (id)normalWhiteLabel
{
	UILabel *label;
	label = [self normalLabel];
	label.textColor = [UIColor whiteColor];
	return label;
}

+ (id)normalBlackCenterLabel
{
	UILabel *label;
	label = [self normalBlackLabel];
	label.textAlignment = UITextAlignmentCenter;
	return label;
}

+ (id)normalWhiteCenterLabel
{
	UILabel *label;
	label = [self normalWhiteLabel];
	label.textAlignment = UITextAlignmentCenter;
	return label;
}

+ (id)titleLabel
{
	UILabel *label;
	label = [[UILabel alloc] init];
	label.font = [UIFont systemFontOfSize:20];
	label.backgroundColor = [UIColor clearColor];	
	
	return [label autorelease];
}

+ (id)titleBlackLabel
{
	UILabel *label;
	label = [self titleLabel];
	label.textColor = [UIColor blackColor];
	return label;
}

+ (id)titleWhiteLabel
{
	UILabel *label;
	label = [self titleLabel];
	label.textColor = [UIColor whiteColor];
	return label;
}

+ (id)titleBlackCenterLabel
{
	UILabel *label;
	label = [self titleBlackLabel];
	label.textAlignment = UITextAlignmentCenter;
	return label;
}

+ (id)titleWhiteCenterLabel
{
	UILabel *label;
	label = [self titleWhiteLabel];
	label.textAlignment = UITextAlignmentCenter;
	return label;
}

@end
