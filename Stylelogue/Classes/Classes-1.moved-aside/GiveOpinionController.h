//
//  GiveopinionController.h
//  Stylelogue
//


//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "GradientView.h"
#import "ColorDirective.h"
#import "UIButtonExtension.h"
#import "UIViewExtension.h"
#import "StylelogueAppDelegate.h"
#import "ASIHTTPRequestDelegate.h"

@interface GiveopinionController : UIViewController <UITextViewDelegate, ASIHTTPRequestDelegate> {
	
	UIWebView *opinionsView;
	UIImageView *backgroundImage;
	UIImage *selectedImage;
	UIView *textFieldRoundedWrapper;
	UITextView *textFieldForAddionalNotes;
	UIImageView *backGround;
	Item *it;
	
	NSMutableArray* opinionList;
}

@property (nonatomic, retain) 	NSMutableArray* opinionList;
@property (nonatomic, retain) 	Item *it;
@property(nonatomic, retain) 	UIImageView *backGround;
@property(nonatomic, retain) 	UIView *textFieldRoundedWrapper;
@property(nonatomic, retain) 	UITextView *textFieldForAddionalNotes;

@property(nonatomic, retain) 	UIImage *selectedImage;
@property(nonatomic, retain) 	UIImageView *backgroundImage;
@property(nonatomic, retain)	UIWebView *opinionsView;
@end
