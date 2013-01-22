    //
//  AdjustPhotoController.m
//  Stylelogue
//


//

#import "AdjustPhotoController.h"
#import "UIViewWrapper.h"
#import "UIViewExtension.h"
#import "UIViewGenerator.h"
#import "SelectQuestionController.h"
#import "ColorDirective.h"
#import "FontLabelExtension.h"

@implementation AdjustPhotoController

@synthesize selectedImage;
@synthesize thumbnail;
@synthesize squareToCutThumbnail;
@synthesize selectedImageView;
@synthesize tableView;
@synthesize myThumnail;

- (id)initWithImage:(UIImage *)image
{
	self = [super init];
	[self setSelectedImage:image];	
	self.navigationItem.titleView = [FontLabel titleLabelNamed:@"My Photo"];
	
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	if (self.selectedImage) {
		self.thumbnail = [UIViewWrapper viewWithClearBackgroundImage:@"images/square.0.png"];
		[self.thumbnail clampTop];
		[self.thumbnail setAnimationImages:[NSArray arrayWithObjects:
											[UIImage imageNamed:@"images/square.0.png"],
											[UIImage imageNamed:@"images/square.1.png"],
											[UIImage imageNamed:@"images/square.2.png"],
											[UIImage imageNamed:@"images/square.1.png"],
											nil]];
		[self.thumbnail setImage:nil];
		[self.thumbnail setAnimationDuration:0.8];
		[self.thumbnail startAnimating];
		[self.thumbnail setAlpha:0.6
		 ];
		
		UIImageViewExtension* selectedImageView = [[UIImageViewExtension alloc] initWithFrame:self.view.bounds];
		[self setSelectedImageView:selectedImageView];
		[selectedImageView release];
		self.selectedImageView.image = self.selectedImage;
		
		[self.selectedImageView setHeight:self.selectedImageView.width/self.selectedImage.size.width*self.selectedImage.size.height];
		
		[self.selectedImageView setCenter:CGPointMake(160, 200)];
		thumbnail.receiver = (UIImageViewExtension*)self.selectedImageView;
		
		thumbnail.userInteractionEnabled = YES;
		thumbnail.multipleTouchEnabled = YES;
		
		self.selectedImageView.userInteractionEnabled = NO;
		self.selectedImageView.multipleTouchEnabled = NO;
		
		[self.view addSubview:self.selectedImageView];
		[self.view addSubview:self.thumbnail];
	}

	
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
	
	UIView *squareToCutThumbnail = [[UIView alloc] initWithFrame:CGRectMake(80, 120, 160, 160)];
	[self setSquareToCutThumbnail:squareToCutThumbnail];
	[squareToCutThumbnail release];
	
	self.squareToCutThumbnail.backgroundColor = [UIColor redColor];

	UITableView *tableView = [[UITableView alloc] init];
	[self setTableView:tableView];
	[tableView release];
	[self.view addSubview:tableView];
	[self.tableView setFrame:self.view.bounds];
	[self.tableView clampFlexibleMiddle];
	self.tableView.scrollEnabled = NO;
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	[self.tableView setTop:self.tableView.top-10];
	
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	self.tableView.separatorColor = RGBACOLOR(0x22, 0x22, 0x22, 1);
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	v.backgroundColor = [UIColor blackColor];

	[self.tableView setTableFooterView:v];
	[v release];
	[self.tableView setTop:360]; 
	
	
	UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 245, 320, 50)];
	lab.backgroundColor = [UIColor clearColor];
	lab.textColor = MAINCOLOR;
	[lab setTextAlignment:UITextAlignmentCenter];
	[lab setFont:[UIFont fontWithName:FONT size:FONTSIZE+1]];
	lab.text = @"Move and Scale";
	
	[self.view addSubview:lab];
	[lab release];
	
	lab = [[UILabel alloc] initWithFrame:CGRectMake(86, 256, 150, 80)];
	lab.backgroundColor = [UIColor clearColor];
	lab.textColor = MAINCOLOR;
	[lab setLineBreakMode:UILineBreakModeWordWrap];
	[lab setNumberOfLines:0];
	[lab setTextAlignment:UITextAlignmentCenter];
	[lab setFont:[UIFont fontWithName:FONT size:12]];
	lab.text = @"Set preview thumbnail for your photo";
	[self.view addSubview:lab];
	[lab release];
	
}


#pragma mark Delegate and Data Source for UITableView

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UILabel *topLabel;
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		TableCellHilightedView *selectedView = [[TableCellHilightedView alloc] initWithFrame:CGRectMake(-222, 0, cell.frame.size.width, cell.frame.size.height)];
		cell.selectedBackgroundView = selectedView;
		[selectedView release];
		
		TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:CGRectMake(-222, 0, cell.frame.size.width, cell.frame.size.height)];
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
				topLabel.text = @"Continue";
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
			[self continueWithQuestion];
			break;
	}
	
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (void) writeCGImage: (CGImageRef) image toURL: (NSURL*) url withType: (CFStringRef) imageType andOptions: (CFDictionaryRef) options
{
	CGImageDestinationRef myImageDest = CGImageDestinationCreateWithURL((CFURLRef)url, imageType, 1, nil);
	CGImageDestinationAddImage(myImageDest, image, options);
	CGImageDestinationFinalize(myImageDest);
	CFRelease(myImageDest);
}

-(void)takeScreenShotImage
{
	UIGraphicsBeginImageContext(self.view.bounds.size);
	[self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	CGRect frame = CGRectMake(80,160,156,156);
	CGImageRef subimage = CGImageCreateWithImageInRect([viewImage CGImage], frame);
	UIImage *img = [[UIImage alloc] initWithCGImage:subimage];
	[self setMyThumnail:img];
	[img release];
	CFRelease(subimage);
}

-(void)backFunction
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)continueWithQuestion
{
	[self takeScreenShotImage];
	SelectQuestionController *selectQuestionController = [[SelectQuestionController alloc] initWithImage:self.selectedImage thumbail:self.myThumnail];
	[self.navigationController pushViewController:selectQuestionController animated:YES];
	[selectQuestionController release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	
	XQDebug(@"\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Adjust Photo Controller Dealloc\n");
	self.myThumnail = nil;
	self.selectedImage = nil;
	self.squareToCutThumbnail = nil;
	self.thumbnail = nil;
	self.selectedImageView = nil;
	self.tableView = nil;
    [super dealloc];
}
@end
