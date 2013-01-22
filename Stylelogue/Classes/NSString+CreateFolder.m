//
//  NSString+CreateFolder.m
//
//
// on 7/27/10.
// Rubify. All rights reserved.
//

#import "NSString+CreateFolder.h"


@implementation NSString(CreateFolder)

- (void)createFolder
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *folder = [self stringByReplacingOccurrencesOfString:[self lastPathComponent] withString:@""];
	if ([fileManager fileExistsAtPath:folder] == NO)
	{
		[fileManager createDirectoryAtPath:folder attributes: nil];
	}
}

@end
