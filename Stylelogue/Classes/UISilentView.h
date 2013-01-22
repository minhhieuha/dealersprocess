//
//  UISilentView.h
//  iPhonePhilipCapital
//
//  Created by Freddy Wang on 12/8/10.

//

#import <UIKit/UIKit.h>


@interface UISilentView : UIAlertView {
	id silentDelegate;
}

@property (nonatomic, assign) id silentDelegate;

@end
