//
//  SelectPicker.m
//
//
// on 6/30/10.
// Rubify. All rights reserved.
//

#import "SelectPicker.h"
#import "UIViewExtension.h"
#import "UIViewAnimation.h"
#import "UILabelGenerator.h"
#import "ColorDirective.h"
#import "SheetPickerView.h"
#import "UIWindowKeyboard.h"

@implementation SelectPicker

@synthesize choices;
@synthesize valueChoices;
@synthesize pickerInfoMessage;

static SelectPicker *currentShowing;

- (id)init {
    if ((self = [super init])) {

		NSAutoreleasePool *pool = [NSAutoreleasePool new];
		
		UIButton *dropDownButton = [UIButton pillDropDownButtonWithTitle:@"" 
																  target:self 
																selector:@selector(toggle) 
																position:CGPointMake(0, 0) 
																   width:200];
		[self addSubview:dropDownButton];

		
		self.pickerInfoMessage = @"Select";
		
		self.height = dropDownButton.height;
		self.width = 160;
		
		[dropDownButton setTitle:@"" forState:UIControlStateNormal];
		[dropDownButton clampFlexibleMiddle];
		
		choices = [[NSArray array] retain];
		valueChoices = nil;
		selectedOffset = 0;
		
		label = [UILabel normalLabel];
		label.frame = CGRectMake(10, 0, dropDownButton.width-40, dropDownButton.height);
		label.exclusiveTouch = NO;
		label.userInteractionEnabled = NO;
		label.text = @"";
		[label clampFlexibleMiddle];
		
		[self addSubview:label];
		
		[pool release];
    }
    return self;
}

+ (void)hidePicker
{
	if (currentShowing) {
		[SheetPickerView hide];
		[[SheetPickerView onlyPicker] setDelegate:nil];
		[[SheetPickerView onlyPicker] setDataSource:nil];
	}
	currentShowing = nil;
}

- (void)toggle
{
	if (currentShowing == self) {
		[[self class] hidePicker];
	} else {
		[self showPicker];
	}
}

- (void)pickerViewCancelled
{
	[[self class] hidePicker];
}

- (void)pickerViewConfirmed
{
	[[self class] hidePicker];
}


- (void)showPicker
{
	[UIWindow resignAnyKeyboard];
	
	[SheetPickerView show];
	[SheetPickerView setInfo:self.pickerInfoMessage];
	[[SheetPickerView onlyPicker] setDelegate:self];
	[[SheetPickerView onlyPicker] setDataSource:self];	

	int row = [choices indexOfObject:label.text];
	row = row < 0 ? 0 : row;
	[[SheetPickerView onlyPicker] selectRow:row inComponent:0 animated:NO];
	selectedOffset = row;
	
	currentShowing = self;
}

- (void)setPickerInfo:(NSString *)pickerMessage
{
	self.pickerInfoMessage = pickerMessage;
	if ([[SheetPickerView onlyPicker] delegate] == self) {
		[SheetPickerView setInfo:pickerMessage];
	}
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [choices count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [choices objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 35;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view 
{
	UILabel *pickerLabel = (UILabel *)view;
	// Reuse the label if possible, otherwise create and configure a new one
	if ((pickerLabel == nil) || ([pickerLabel class] != [UILabel class])) 
	{  //newlabel
		CGRect frame = CGRectMake(0.0, 20.0, pickerView.width - 40, 45.0);
		pickerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		pickerLabel.textAlignment = UITextAlignmentCenter;
		pickerLabel.backgroundColor = [UIColor clearColor];
		pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
	}			
	pickerLabel.textColor = [UIColor blackColor];
	pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
	return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString *value;

	if (valueChoices && row < [valueChoices count]) {
		value = [valueChoices objectAtIndex:row];
	} else {
		value = [choices objectAtIndex:row];
	}
	[self setTextValue:[choices objectAtIndex:row]];
	selectedOffset = row;
	
	if (pickerDelegate && pickerDelegateSelector) {
		if ([pickerDelegate respondsToSelector:pickerDelegateSelector]) {
			[pickerDelegate performSelector:pickerDelegateSelector withObject:value];
		}
	}
}

- (void)setDelegate:(id)delegate withSelector:(SEL)selector
{
	pickerDelegate = delegate;
	pickerDelegateSelector = selector;
}

- (void)setTextValue:(NSString *)value
{
	label.text = value;	
	[label adjustsFontSizeToFitWidth];
}

- (void)setSelectedValue:(NSString *)value
{
	selectedOffset = [valueChoices indexOfObject:value];
	if (selectedOffset >= 0 && selectedOffset < [choices count]) {
		[self setTextValue:[choices objectAtIndex:selectedOffset]];
	} else {
		[self setTextValue:@""];
	}
}

- (NSString *)textValue
{
	if (valueChoices && (selectedOffset >= 0) && (selectedOffset < [valueChoices count])) {
		return [valueChoices objectAtIndex:selectedOffset];
	} else if ((selectedOffset >= 0) && (selectedOffset < [choices count])) {
		return [choices objectAtIndex:selectedOffset];
	}
	return label.text;
}

- (void)dealloc {
	self.choices = nil;
	self.valueChoices = nil;
	self.pickerInfoMessage = nil;
	
	[[SheetPickerView onlyPicker] setDelegate:nil];
	[[SheetPickerView onlyPicker] setDelegate:nil];
    [super dealloc];
}


@end
