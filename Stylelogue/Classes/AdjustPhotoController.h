//
//  AdjustPhotoController.h
//  Stylelogue
//


//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>


@class UIViewWrapper;
@class UIImageViewExtension;
@interface AdjustPhotoController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
	
	UIImage *selectedImage;
	UIImage *myThumnail;
	UIViewWrapper *thumbnail;
	UIImageViewExtension *selectedImageView;
	UIView *squareToCutThumbnail;
	UITableView *tableView;
}

@property (nonatomic, retain) UIImage *myThumnail;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *squareToCutThumbnail;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIViewWrapper *thumbnail;
@property (nonatomic, retain) UIImageViewExtension *selectedImageView;

@end
