//
//  UIViewWrapper.h
//  Stylelogue
//


//

#import <Foundation/Foundation.h>
#import "UIImageViewExtension.h"



@protocol UIViewExtendDelegate <NSObject>
-(void)tap;
@end

@interface UIViewWrapper : UIImageView {
	id<UIViewExtendDelegate> delegate;
	UIImageViewExtension* receiver;
	BOOL shouldJumback;
}

@property (readwrite) 	BOOL shouldJumback;
@property(nonatomic, retain)	UIImageViewExtension* receiver;
@property (nonatomic, assign)  id<UIViewExtendDelegate> delegate;

@end
