//
//  NSStringPathExtension.m
//  trackasave
//
// on 5/28/10.
// Rubify. All rights reserved.
//

#import "NSStringPathExtension.h"


@implementation NSString(PathExtension)


+ (NSString *)documentDirectoryPath
{
	//NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
		
	return documentsDirectory;
}

+ (NSString *)homeDirectoryPath
{
	return NSHomeDirectory(); // parent folder of document directory
}

+ (NSString *)temporaryDirectoryPath
{
	return NSTemporaryDirectory();
}

+ (NSString *)bundlePath
{
	return [[NSBundle mainBundle] bundlePath];
}


@end
