//
//  FontLabelExtension.m
//  Stylelogue
//
//  Created by Freddy Wang on 12/29/10.

//

#import "FontLabelExtension.h"


@implementation FontLabel(LabelExtension)

+ (UILabel *)titleLabelNamed:(NSString *)string
{
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)] autorelease];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:MAINCOLOR];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setFont:[UIFont fontWithName:FONT size:TITLESIZE]];
	[label setText:string];
	return label;
}

+ (UILabel *)titleLabelNamed3:(NSString *)string
{
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 30)] autorelease];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:MAINCOLOR];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setFont:[UIFont fontWithName:FONT size:TITLESIZE33]];
	[label setText:string];
	return label;
}

+ (UILabel *)titleLabelNamed4:(NSString *)string
{
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 30)] autorelease];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:MAINCOLOR];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setFont:[UIFont fontWithName:FONT size:TITLESIZE]];
	[label setText:string];
	return label;
}

+ (UILabel *)titleLabelNamed2:(NSString *)string
{
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)] autorelease];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:MAINCOLOR];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setFont:[UIFont fontWithName:FONT size:25]];
	[label setText:string];
	return label;
}

+(FontLabel*)makeFontLabel:(NSString*) mess1 mess2:(NSString*)mess2
{
	//find the 
	NSString *mess = [NSString stringWithFormat:@"%@ %@", mess1, mess2];
	FontLabel *label4 = [[FontLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
	
	ZMutableAttributedString *str = [[ZMutableAttributedString alloc] initWithString:mess
																		  attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																					  [ZFont fontWithUIFont:[UIFont fontWithName:FONT size:15]],
																					  ZFontAttributeName, MAINCOLOR, ZForegroundColorAttributeName, [UIColor clearColor], ZBackgroundColorAttributeName,
																					  nil]];
	
	[str addAttribute:ZFontAttributeName value:[ZFont fontWithUIFont:[UIFont fontWithName:FONT size:20]] range:NSMakeRange([mess1 length], [mess2 length]+1)];
	[str addAttribute:ZForegroundColorAttributeName value:RGBACOLOR(0x55, 0x55, 0x55, 1) range:NSMakeRange([mess1 length], [mess2 length]+1)];
	label4.zAttributedText = str;
	label4.backgroundColor = [UIColor clearColor];
	[str release];
	label4.textAlignment = UITextAlignmentLeft;
	label4.numberOfLines = 0;
	return [label4 autorelease];
}


@end
