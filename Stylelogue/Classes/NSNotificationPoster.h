//
//  NSNotificationPoster.h
//
//
// on 6/28/10.
// Rubify. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSNotificationCenter(PosterSimplified) 
+ (void)shootNotification:(NSString *)selectorName;
+ (void)shootNotification:(NSString *)selectorName withObject:(id)object;
@end

@interface NSObject(NotificationSimplified)
- (void)registerNotification:(NSString *)selectorName;
- (void)removeRegisteredNotification:(NSString *)selectorName;
@end
