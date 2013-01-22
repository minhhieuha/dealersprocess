//
//  TakePhotoLandingController.m
//  Stylelogue
//

#import "TakePhotoLandingController.h"
#import "ColorDirective.h"
#import "AdjustPhotoController.h"
#import "FontLabelExtension.h"
#import "UIViewExtension.h"

@implementation TakePhotoLandingController
@synthesize tableView;
@synthesize pickerCamera;

- (id)init {
    if ((self = [super init])) {
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Upload Style"];
    }
    return self;
}

- (void)loadView {
	
	[super loadView];
	UITableView *tableView = [[UITableView alloc] init];
	[self.view addSubview:tableView];
	[tableView setFrame:self.view.bounds];
	[tableView clampFlexibleMiddle];
	tableView.scrollEnabled = NO;
	
	[tableView setDelegate:self];
	[tableView setDataSource:self];
	[tableView setBackgroundColor:[UIColor blackColor]];
	[tableView setTop:tableView.top-10];
	
	[tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	tableView.separatorColor = RGBACOLOR(0x22, 0x22, 0x22, 1);
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	v.backgroundColor = [UIColor blackColor];
	[tableView setTableHeaderView:v];
	[tableView setTableFooterView:v];
	[v release];
	
	[self setTableView:tableView];
	[tableView release];
	
	UIButton *button = [UIButton numericPadButton:@"images/button.back.png"];
	[button setTitle:@"back" forState:UIControlStateNormal];
	[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
	button.titleLabel.textColor = MAINCOLOR;
	[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
	
	XQDebug(@"\nCancel cancel\n");
	[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.leftBarButtonItem = favorite;
	[favorite release];

	UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(320/2-50, 380, 100, 20)];
	[self.view addSubview:pageControl];
	pageControl.numberOfPages = 3;
	pageControl.currentPage = 0;
	[pageControl setUserInteractionEnabled:NO];
	[pageControl release];
}

-(void)backFunction
{
	UIActivityIndicatorView *indicator = [self.view viewWithTag:999];
	if (indicator) {
		[indicator stopAnimating];
		[indicator removeFromSuperview];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Delegate and Data Source for UITableView

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UILabel *topLabel;
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		TableCellHilightedView *selectedView = [[TableCellHilightedView alloc] initWithFrame:cell.frame];
		cell.selectedBackgroundView = selectedView;
		[selectedView release];
		
		TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:cell.frame];
		cell.backgroundView = backGroundView;
		[backGroundView release];
		
		topLabel = [[[UILabel alloc] initWithFrame: CGRectMake( cell.frame.origin.x+20, cell.frame.origin.y + 10, tableView.bounds.size.width,40)] autorelease];
		
		[topLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
		[topLabel setTextColor:MAINCOLOR];
		
		[cell.contentView addSubview:topLabel];
		
		
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.tag = 111;
		topLabel.textColor = [UIColor whiteColor];
		
		[topLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
		[topLabel setTextColor:MAINCOLOR];
		switch ([indexPath row]) {
			case 0:
				topLabel.text = @"Take New Photo";
				break;
			case 1:
				topLabel.text = @"Select Photo from Gallery";
				break;
			case 2:
				cell.backgroundView = nil;
				cell.selectedBackgroundView = nil;
				cell.userInteractionEnabled = NO;
				topLabel.text = @"Stylelogue is a curated user submission site. There can be a delay in photo approvals (we handpicked from thousands of photos everyday!) and not all submissions will be accepted. Please don’t take it personally, we’re in this for curating great fashion inspirations! See http://stylelogue.it/faq for submission guidelines.";
				[topLabel setTextAlignment:UITextAlignmentLeft];
				[topLabel setLineBreakMode:UILineBreakModeWordWrap];
				[topLabel setNumberOfLines:0];
				topLabel.textColor = DATECOLOR;
				topLabel.top = 0;
				topLabel.width = 300;
				topLabel.height = 200;
				[topLabel setFont:[UIFont fontWithName:FONT size:15]];
				break;
		}
	}
	
	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([indexPath row]) {
		case 0:
			[self getCameraPicture];
			break;
		case 1:
			[self selectExitingPicture];
			break;
	}
	
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath row] == 2) {
		return 200;
	}
	return 60;
}

#pragma mark summon photo picker modal interface

-(void)getCameraPicture
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        return;
            
	if (!self.pickerCamera) {
		XQDebug(@"\nAlloc gain getcameara picture\n");
		UIImagePickerController* picker = [[UIImagePickerController alloc] init];
		[self setPickerCamera:picker];
		[picker release];
		
		self.pickerCamera.delegate = self;
		self.pickerCamera.allowsImageEditing = NO;
	}
	
	self.pickerCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.pickerCamera.view.backgroundColor = [UIColor  blackColor];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	[self presentModalViewController:pickerCamera animated:YES];
}

-(void)selectExitingPicture
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        return;
    }
	if (!self.pickerCamera) {
		XQDebug(@"\nAlloc gain getcameara picture\n");
		UIImagePickerController* picker = [[UIImagePickerController alloc] init];
		[self setPickerCamera:picker];
		[picker release];
		
		self.pickerCamera.delegate = self;
		self.pickerCamera.allowsImageEditing = NO;
	}
	self.pickerCamera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	self.pickerCamera.view.backgroundColor = [UIColor  blackColor];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	[self presentModalViewController:self.pickerCamera animated:YES];
}

#pragma mark Delegate For Photo Picker

- (void)useImage:(UIImage *)image {

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (self.pickerCamera) {
		self.pickerCamera = nil;
	}
	
	AdjustPhotoController *adjustPhotoController = [[AdjustPhotoController alloc] initWithImage:[image imageByScalingAndCroppingForSize:CGSizeMake(320, 480)]];
	[self.navigationController pushViewController:adjustPhotoController animated:YES];
	[adjustPhotoController release];
	[pool drain];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage : (UIImage *)image editingInfo:(NSDictionary *)editingInfo
{	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];	
	if (self.pickerCamera) {
		self.pickerCamera = nil;
	}
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 160, LOADDINGSIZE, LOADDINGSIZE)];
	indicator.tag = 999;
	
	[self.view addSubview:indicator];
	[indicator startAnimating];
	[indicator release];

	[NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
	[picker setToolbarHidden:YES animated:YES];
	if (self.pickerCamera) {
		self.pickerCamera = nil;
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	XQDebug(@"here...");
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	self.view.backgroundColor = [UIColor blackColor];	
}

-(void)viewWillDisappear:(BOOL)animated
{
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:999];
	if (indicator) {
		[indicator stopAnimating];
		[indicator removeFromSuperview];
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	XQDebug(@"\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>TakePhotoLangdingccontroller dealloc\n");
	self.tableView = nil;
	if (self.pickerCamera) {
		self.pickerCamera = nil;
	}
    [super dealloc];
}

@end
