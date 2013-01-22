//
//  SelectPicker.h
//
//
// on 6/30/10.
// Rubify. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectPicker : UIView {
	NSArray *choices;
	NSArray *valueChoices;
	UILabel *label;

	NSString *pickerInfoMessage;
	
	int selectedOffset;
	id pickerDelegate;
	SEL pickerDelegateSelector;
}

@property (nonatomic, copy) NSArray *choices;
@property (nonatomic, copy) NSArray *valueChoices;
@property (nonatomic, copy) NSString *pickerInfoMessage;

@end
