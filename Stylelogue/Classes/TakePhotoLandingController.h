//
//  TakePhotoLandingController.h
//  Stylelogue
//


//

#import <UIKit/UIKit.h>

#import "TableCellHilightedView.h"
#import "TableViewCellBackGroundView.h"


@interface TakePhotoLandingController : UIViewController<UITableViewDataSource, UITableViewDelegate,  UIImagePickerControllerDelegate , UINavigationControllerDelegate> {

	UITableView *tableView;
	UIImagePickerController *pickerCamera;
}

@property(nonatomic, retain) 	UIImagePickerController *pickerCamera;

@property(nonatomic, retain) 	UITableView *tableView;

@end
