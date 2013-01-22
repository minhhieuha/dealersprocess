//
//  NSNotificationOperation.h
//
//
// on 7/21/10.
// Rubify. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNotificationOperation : NSOperation {
	NSString *notificationName;
	id notificationArgument;
}

@property(nonatomic, copy) NSString *notificationName;
@property(nonatomic, retain) id notificationArgument;

@end
