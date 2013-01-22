//
//  SheetPickerView.m
//
//
// on 6/23/10.
// Rubify. All rights reserved.
//

#import "SheetPickerView.h"
#import "UIViewAnimation.h"
#import "UIViewExtension.h"
#import "ColorDirective.h"
#import "UILabelGenerator.h"
#import "UIButtonExtension.h"

@implementation SheetPickerView

static UIPickerView *mainPicker;
static UIView *mainPickerWrapper;
static UILabel *label;
static UILabel *labelHighlight;
static UIControl *alphaPanelView;
static UIView *bgColorView;

+ (UIPickerView *)onlyPicker
{
	if (!mainPicker) {
		CGRect rect = [[UIScreen mainScreen] applicationFrame]; 

		bgColorView = [UIView viewWithClearBackgroundImage:@"images/picker.top.bg.png"];
		bgColorView.width = rect.size.width;
		
		CGFloat pickerHeight = 216;
	//	CGFloat offsetToFitPurple = (pickerHeight - 44)/2;
		
		alphaPanelView = [[UIControl viewWithBackgroundColor:RGBACOLOR(0,0,0,0.2)] retain];
		alphaPanelView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
		[alphaPanelView addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
		[alphaPanelView clampTop];
		
		UIView *subWrapper = [[UIView alloc] initWithFrame:CGRectZero];
		
		mainPickerWrapper = [[UIView alloc] initWithFrame:CGRectZero];
		mainPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
		mainPicker.showsSelectionIndicator = YES;
			
		mainPickerWrapper.alpha = 0;
		alphaPanelView.alpha = 0;
		alphaPanelView.exclusiveTouch = YES;
		subWrapper.clipsToBounds = YES;
		mainPickerWrapper.top = rect.size.height - (pickerHeight-86) - bgColorView.height;
		mainPickerWrapper.top = 0;
		
		[mainPickerWrapper clampBottom];
		[mainPicker clampTop];
		
		[subWrapper addSubview:mainPicker];
		[mainPickerWrapper addSubview:subWrapper];
		[subWrapper release];
		[mainPickerWrapper addSubview:bgColorView];
		
		labelHighlight = [[UILabel normalWhiteLabel] retain];
		[labelHighlight setTextColor:RGBACOLOR(25,25,25,0.5)];
		labelHighlight.frame = CGRectMake(15, 32, rect.size.width-30, 16);
		[mainPickerWrapper addSubview:labelHighlight];
		
		
		label = [[UILabel normalBlackLabel] retain];
		[label setTextColor:RGBACOLOR(241,241,241,1)];
		label.frame = CGRectMake(labelHighlight.left, labelHighlight.top-1, labelHighlight.width, labelHighlight.height);
		[mainPickerWrapper addSubview:label];
		
		
		UIButton *doneButton = [UIButton pillBlueButtonWithTitle:@"Done"  target:self selector:@selector(confirm) position:CGPointMake(rect.size.width-90, 23) width:80];
		
		[mainPickerWrapper addSubview:doneButton];
		
		[self setInfo:@"Please pick one"];
	}
	
	return mainPicker;
}

+ (void)show
{
	[[[[self onlyPicker] superview] superview] fadeIn];
	[alphaPanelView fadeIn];
}

+ (void)hide
{
	[[[[self onlyPicker] superview] superview] fadeOut];
	[alphaPanelView fadeOut];
}

+ (void)cancel
{
	[self hide];
	UIPickerView *pickerView = [self onlyPicker];
	if ([pickerView delegate]) {
		if ([pickerView.delegate respondsToSelector:@selector(pickerViewCancelled)]) {
			[pickerView.delegate performSelector:@selector(pickerViewCancelled)];
		}
	}
}

+ (void)confirm
{
	[self hide];
	UIPickerView *pickerView = [self onlyPicker];
	if ([pickerView delegate]) {
		if ([pickerView.delegate respondsToSelector:@selector(pickerViewConfirmed)]) {
			[pickerView.delegate performSelector:@selector(pickerViewConfirmed)];
		}
	}
}

+ (void)setInfo:(NSString *)info
{
	[label setText:info];
	[labelHighlight setText:info];
}

+ (void)anchorPickerTo:(UIView *)target
{
	[self onlyPicker];
	[target addSubview:alphaPanelView];
	[target addSubview:[[[self onlyPicker] superview] superview]];
	
	
	CGFloat pickerHeight = 216;
	CGFloat messagePanelOffset = bgColorView.height;
	//messagePanelOffset = 80;
	CGFloat offsetToFitPurple = (pickerHeight - 44)/2;
	CGFloat pickerWrapperHeight = pickerHeight - offsetToFitPurple + messagePanelOffset;

	[mainPickerWrapper setFrame:CGRectMake(0, target.height - pickerWrapperHeight, mainPicker.width, pickerWrapperHeight)];
	[mainPicker setFrame:CGRectMake(-10, -offsetToFitPurple, mainPicker.width+20, pickerHeight)];
	[[mainPicker superview] setFrame:CGRectMake(0, messagePanelOffset, mainPicker.width, pickerHeight)];
}

@end
