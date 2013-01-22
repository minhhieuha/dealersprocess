//
//  SharePhotoPageController.h
//  Stylelogue
//


//

#import <UIKit/UIKit.h>
#import "FontLabel.h"

#import "SHKItem.h"
//#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKMail.h"

#import "ColorDirective.h"
#import "UIViewExtension.h"
#import "StylelogueAppDelegate.h"

#import "TableCellHilightedView.h"
#import "TableViewCellBackGroundView.h"

@interface SharePhotoPageController : UIViewController<UITableViewDataSource, UITableViewDelegate, ParsingFinishDelegate> {

	UIImage * selectedImage;
	UIImage * thumnailImage;
	UIImageView *backgoundImage;
	BOOL times;
	UITableView *tableView;
	NSString *textToShare;
	NSString *url;
	
	UIPageControl *pageControl;
	NSString *give_opinion_url;
	NSString *photo;
}

@property(nonatomic, copy) 	NSString *photo;
@property(nonatomic, copy) 	NSString *give_opinion_url;
@property(nonatomic, copy) 	NSString *url;
@property(nonatomic,copy) 	NSString *textToShare;
@property(nonatomic, retain) 	UITableView *tableView;
@property(readwrite) 	BOOL times;
@property(nonatomic, retain) 	UIImageView *backgoundImage;
@property(nonatomic, retain) UIImage *thumnailImage;
@property(nonatomic,retain) UIImage *selectedImage;

@end
