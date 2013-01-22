//
//  FacebookInfo.h
//  Stylelogue
//
//  Created by Peter Quang Nguyen on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FacebookInfo : UIView {
	
	NSString *name;
	NSString *uid;
	NSString *location;
}


@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *location;
@end
