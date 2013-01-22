//
//  NSStringPathExtension.h
//  trackasave
//
// on 5/28/10.
// Rubify. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSString(PathExtension)

+ (NSString *)documentDirectoryPath;
+ (NSString *)homeDirectoryPath;
+ (NSString *)temporaryDirectoryPath;
+ (NSString *)bundlePath;

@end
