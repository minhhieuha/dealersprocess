//
//  SelectQuestionController.h
//  Stylelogue
//


//

#import <UIKit/UIKit.h>
#import "ColorDirective.h"
#import "UIViewExtension.h"
#import "SharePhotoPageController.h"
#import "ImageHelper.h"
#import "StylelogueAppDelegate.h"
#import "APIController.h"


@interface SelectQuestionController : UIViewController<ParsingFinishDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
	
	UIButton *selectQuestionButton;
	UILabel *selectQuestionLabel;
	UILabel *additionalNoteTitle;
	UILabel *wordsLabel;
	
	UIView *textFieldRoundedWrapper;
	UITextView *textFieldForAddionalNotes;
	
	BOOL questionChoosen;

	NSMutableArray *questions;
	UIButton* selectQuestionView;
	UIImage *selectedImage;
	UIImage *thumnailImage;
	UIImageView *backGroundImage;
	
	UITableView *tableView;

}

@property(nonatomic, retain) UIButton *selectQuestionButton;
@property(nonatomic, retain)  UILabel *selectQuestionLabel;
@property(nonatomic, retain)  UILabel *additionalNoteTitle;
@property(nonatomic, retain)  UILabel *wordsLabel;

@property(nonatomic, retain)  UIView *textFieldRoundedWrapper;
@property(nonatomic, retain)  UITextView *textFieldForAddionalNotes;

@property(readwrite) BOOL questionChoosen;

@property(nonatomic, retain) NSMutableArray *questions;
@property(nonatomic, retain) UIButton* selectQuestionView;
@property(nonatomic, retain) UIImage *selectedImage;
@property(nonatomic, retain) UIImage *thumnailImage;
@property(nonatomic, retain) UIImageView *backGroundImage;

@property(nonatomic, retain) UITableView *tableView;

@end
