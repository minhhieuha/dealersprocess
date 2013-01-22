//
//  ViewLog.m
//  iPadHotel
//
//  Created by Freddy Wang on 12/1/10.

//

#import "ViewLog.h"

void doLog(int level, id formatstring,...)
{
    int i;
    for (i = 0; i < level; i++) printf("|   ");
    
    va_list arglist;
    if (formatstring)
    {
        va_start(arglist, formatstring);
        id outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
        fprintf(stderr, "%s\n", [outstring UTF8String]);
        va_end(arglist);
    }
}


@implementation UIView(ViewLog)

+ (void) explode: (id) aView level: (int) level
{
//	if ([aView isKindOfClass:[UIImageView class]]) {
//		doLog(level, @"%@", aView);
//	}
	if ([aView isKindOfClass:[UILabel class]]) {
		doLog(level, @"%@(%@)", [[aView class] description], [[aView text] length] < 20 ? [aView text] : [[aView text] substringToIndex:20]);
	} else {
		doLog(level, @"%@", [aView respondsToSelector:@selector(layoutDescription)] ? [aView layoutDescription] : [[aView class] description]);
	}
	doLog(level, @"%@", NSStringFromCGRect([aView frame]));
	for (UIView *subview in [aView subviews])
		[self explode:subview level:(level + 1)];
}

+ (void) showViewLog
{
	[self showViewLogOf:[[UIApplication sharedApplication] keyWindow]];
}

+ (void) showViewLogOf:(UIView *)view
{
	[self explode:view level:0];
}

@end
