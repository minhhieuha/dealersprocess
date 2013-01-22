//
//  SelectQuestionController.m
//  Stylelogue
//


//

#import "SelectQuestionController.h"
#import "FontLabelExtension.h"
#import "UISilentView.h"
#import "SheetPickerView.h"
#import "UIImage+WhiteBorder.h"

@implementation SelectQuestionController

@synthesize selectQuestionButton;
@synthesize selectQuestionLabel;
@synthesize additionalNoteTitle;
@synthesize wordsLabel;

@synthesize textFieldRoundedWrapper;
@synthesize textFieldForAddionalNotes;

@synthesize questionChoosen;

@synthesize questions;
@synthesize selectQuestionView;
@synthesize selectedImage;
@synthesize thumnailImage;
@synthesize backGroundImage;

@synthesize tableView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init {
    if ((self = [super init])) {
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"My Question"];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image thumbail:(UIImage*)thumnail
{
	self = [super init];
	self.selectedImage = image;
	self.thumnailImage =  thumnail;
	self.navigationItem.titleView = [FontLabel titleLabelNamed:@"My Question"];
	
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[super loadView];
	UIImageView *backGroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[self setBackGroundImage:backGroundImage];
	[backGroundImage release];
	self.backGroundImage.image = self.selectedImage;
	[self.backGroundImage setAlpha:0.1];
	[self.view addSubview:self.backGroundImage];
	
	self.selectQuestionButton = [UIButton buttonWithImageNamed:@"images/dropdown.png"];
	[self.selectQuestionButton addTarget:self action:@selector(selectQuestion:) forControlEvents:UIControlEventTouchUpInside];
	[self.selectQuestionButton setTop:20];
	[self.selectQuestionButton setLeft:21];
	[self.selectQuestionButton setWidth: self.selectQuestionButton.width - 1];
	[self.view addSubview:self.selectQuestionButton];
	
	UILabel *selectQuestionLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.selectQuestionButton.bounds, 12, 8)];
	[self setSelectQuestionLabel:selectQuestionLabel];
	[selectQuestionLabel release];
	self.selectQuestionLabel.text = @"Select Question";
	[self.selectQuestionLabel setWidth:self.selectQuestionButton.width - 50];
	self.selectQuestionLabel.backgroundColor = [UIColor clearColor];
	[self.selectQuestionButton addSubview:self.selectQuestionLabel];
	
	UILabel *additionalNoteTitle = [[UILabel alloc] initWithFrame:self.selectQuestionLabel.bounds];
	[self setAdditionalNoteTitle: additionalNoteTitle];
	[additionalNoteTitle release];
	self.additionalNoteTitle.text = @"Additional note";
	[self.additionalNoteTitle setFont:[UIFont fontWithName:FONT size:12]];
	[self.additionalNoteTitle setBackgroundColor:[UIColor clearColor]];
	[self.additionalNoteTitle setTextColor:[UIColor whiteColor]];
	[self.additionalNoteTitle setTop:115];
	[self.additionalNoteTitle setHeight:12];
	[self.additionalNoteTitle setLeft:25];
	[self.view addSubview:self.additionalNoteTitle];
	
	self.textFieldRoundedWrapper = [UIView viewWithStretchableBackgroundImage:@"images/textfield.background.png" widthCap:11 andHeightCap:11];
	[self.textFieldRoundedWrapper setLeft:20];
	[self.textFieldRoundedWrapper setTop:130];
	
	[self.view addSubview:self.textFieldRoundedWrapper];
	
	UITextView * textFieldForAddionalNotes = [[UITextView alloc] initWithFrame:CGRectInset(self.textFieldRoundedWrapper.bounds, 12, 8)];
	[self setTextFieldForAddionalNotes:textFieldForAddionalNotes];
	[textFieldForAddionalNotes release];
	[self.textFieldForAddionalNotes setFont:[UIFont fontWithName:FONT size:15]];
	[self.textFieldRoundedWrapper addSubview:self.textFieldForAddionalNotes];
	[self.textFieldForAddionalNotes clampFlexibleMiddle];
	[self.textFieldForAddionalNotes setDelegate:self];
	[self.textFieldForAddionalNotes setContentInset:UIEdgeInsetsMake(-8, -4, 0, 0)];
	[self.textFieldForAddionalNotes setKeyboardAppearance:UIKeyboardAppearanceAlert];
	
	UILabel *wordsLabel = [[UILabel alloc] initWithFrame:self.selectQuestionLabel.bounds] ;
	[self setWordsLabel:wordsLabel];
	[wordsLabel release];
	self.wordsLabel.width = self.textFieldRoundedWrapper.width;
	[self.wordsLabel setLeft:self.textFieldRoundedWrapper.left];
	self.wordsLabel.backgroundColor = [UIColor clearColor];
	self.wordsLabel.textColor = [UIColor whiteColor];
	[self.wordsLabel setTop:self.textFieldRoundedWrapper.top + self.textFieldRoundedWrapper.height + 1];
	[self.wordsLabel setFont:[UIFont fontWithName:FONT size:12]];
	self.wordsLabel.text = @"6/140 Words";
	[self.view addSubview:self.wordsLabel];
	[self.wordsLabel setTextAlignment:UITextAlignmentRight];
	
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
	
	self.wordsLabel.text = [NSString stringWithFormat:@"%d/140 chars", [self.textFieldForAddionalNotes.text length]];
	
	NSMutableArray *questions = [[NSMutableArray alloc] init] ;
	[self setQuestions:questions];
	[questions release];
	AppMainNavigationController* mainController = (AppMainNavigationController*)self.navigationController;
	XQDebug(@"\nQuestion count: %d\n", [mainController.questions count]);
	for (int i=0; i<[mainController.questions count]; i++) {
		Question *q = (Question *)[mainController.questions objectAtIndex:i];
		[self.questions addObject:q.content];
		XQDebug(@"\nQ: %@\n", q.content);
	}
	
	UITableView *tableView = [[UITableView alloc] init];
	[self setTableView:tableView];
	[tableView release];
	[self.view addSubview:self.tableView];
	[self.tableView setFrame:self.view.bounds];
	[self.tableView clampFlexibleMiddle];
	self.tableView.scrollEnabled = NO;
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setBackgroundColor:[UIColor clearColor]];

	
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	//self.tableView.separatorColor = RGBACOLOR(0x22, 0x22, 0x22, 1);
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	v.backgroundColor = RGBACOLOR(0x22, 0x22, 0x22, 1);
	[self.tableView setTableHeaderView:v];
	[v release];
	
	v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	v.backgroundColor = RGBACOLOR(0x22, 0x22, 0x22, 1);
	[self.tableView setTableFooterView:v];
	[v release];
	
	[self.tableView setTop:200];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	NSString *filesContent = [[NSString alloc] initWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"myfile.txt"]];
	XQDebug(@"\nlastQuestion: %@\n", filesContent);
	if (filesContent) {
		questionChoosen = YES;
		self.selectQuestionLabel.text = filesContent;
	}else {
		questionChoosen = NO;
	}
	
	//pag control
	UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(320/2-50, 380, 100, 20)];
	[self.view addSubview:pageControl];
	pageControl.numberOfPages = 3;
	pageControl.currentPage = 1;
	[pageControl setUserInteractionEnabled:NO];
	[pageControl release];


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
		cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
		
		TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:CGRectMake(-222, 0, cell.frame.size.width, cell.frame.size.height)];
		cell.backgroundView = backGroundView;
		[backGroundView release];
		
		cell.backgroundView.backgroundColor = [UIColor clearColor];
		
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
				topLabel.text = @"Submit";
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
			[self submitItem];
			break;
	}
	
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}



-(void)backFunction
{
	[self.navigationController popViewControllerAnimated:YES];
//	StylelogueAppDelegate* del = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
//	[del popViewsToSelectImage];
}

#pragma mark UIPicker View Delegate

- (void)pickerViewCancelled
{
}

- (void)pickerViewConfirmed
{
	
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	XQDebug(@"\nQuestion: %@\n", [self.questions objectAtIndex:row]);
	self.selectQuestionLabel.text = [self.questions objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	XQDebug(@"\nNumber of question: %d\n", [self.questions count]);
	return [self.questions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [self.questions objectAtIndex:row];
}

#pragma mark -------------


- (void)uploadPhoto{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
	
	NSError *error;
	BOOL succeed = [self.selectQuestionLabel.text writeToFile:[documentsDirectory stringByAppendingPathComponent:@"myfile.txt"]
							  atomically:YES encoding:NSUTF8StringEncoding error:&error];
	if (!succeed){
		// Handle error here
		
		XQDebug(@"\nError to write files\n");
	}
	
	StylelogueAppDelegate *de = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
	[de uploadPhotoToServerInBackground:self.thumnailImage originImage:self.selectedImage question:self.selectQuestionLabel.text additionalNote:self.textFieldForAddionalNotes.text];
	[pool drain];
}

-(void)submitItem
{
	if (!questionChoosen) {
		UISilentView *confirmSubmitPhoto = [[[UISilentView alloc] initWithTitle:@"Question" message:@"Please select a question" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[confirmSubmitPhoto setTag:100];
		[confirmSubmitPhoto show];
		return;
	}
//	UISilentView *confirmSubmitPhoto = [[UISilentView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to submit this photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//	[confirmSubmitPhoto setTag:111];
//	[[confirmSubmitPhoto autorelease] show];
	
	[self submitItemConfirm];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 111) {
		if (buttonIndex == 1) {
			[self submitItemConfirm];
		}else
		{
			[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
		}
	}
	else {
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	}

}

-(void)submitItemConfirm
{
	[self performSelectorInBackground:@selector(uploadPhoto) withObject:nil];
	SharePhotoPageController *shareQuestionController = [[SharePhotoPageController alloc] initWithImage:self.selectedImage thumbail:self.thumnailImage times:YES itemID:0];
	shareQuestionController.textToShare = [NSString stringWithFormat:@"%@ %@", self.selectQuestionLabel.text, self.textFieldForAddionalNotes.text];
	[self.navigationController pushViewController:shareQuestionController animated:YES];
	[shareQuestionController release];
}

-(IBAction)selectQuestion:(id)sender
{	
	XQDebug(@"\nSelect Questions\n");
	
	[SheetPickerView show];
	[SheetPickerView setInfo:@"Please select a question"];
	[[SheetPickerView onlyPicker] setDelegate:self];
	[[SheetPickerView onlyPicker] setDataSource:self];	
	
	if (self.questions && [self.questions count] > 0) {
		self.selectQuestionLabel.text = [self.questions objectAtIndex:0];
		questionChoosen = YES;
	}
}

-(void)cancelButton
{	
	[self.textFieldForAddionalNotes resignFirstResponder];
	self.selectQuestionView.backgroundColor = [UIColor clearColor];
	[UIView beginAnimations:NULL context:NULL];
	[UIView setAnimationDuration:0.5];
	[self.selectQuestionView setTop:480];
	[UIView commitAnimations];
}

#pragma mark  UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if (textView == textFieldForAddionalNotes) {
		[UIView beginAnimations:NULL context:NULL];
		[textFieldRoundedWrapper setFrame:CGRectMake(textFieldRoundedWrapper.frame.origin.x, 12, textFieldRoundedWrapper.frame.size.width, 170)];
		self.wordsLabel.top = self.wordsLabel.top + 12;
		[textFieldForAddionalNotes setFrame:CGRectInset(textFieldRoundedWrapper.bounds, 12, 8)];
		[textFieldForAddionalNotes setScrollEnabled:YES];
		[UIView commitAnimations];
	}
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		
		if (textView == textFieldForAddionalNotes) {
			[UIView beginAnimations:NULL context:NULL];
			
			[textFieldRoundedWrapper setFrame:CGRectMake(textFieldRoundedWrapper.frame.origin.x, 130, textFieldRoundedWrapper.frame.size.width, 40)];
			[textFieldForAddionalNotes setFrame:CGRectInset(textFieldRoundedWrapper.bounds, 12, 8)];
			[textFieldForAddionalNotes setScrollEnabled:NO];
			self.wordsLabel.top = self.wordsLabel.top - 12;
			
			[UIView commitAnimations];
		}
        return NO;
    }
	
	if (textFieldForAddionalNotes.text && [textFieldForAddionalNotes.text length]>= 140 && [text length] > 0) {
		return NO;
	}
	
	if (textFieldForAddionalNotes.text) {
		self.wordsLabel.text = [NSString stringWithFormat:@"%d/140 chars", [textFieldForAddionalNotes.text length]];
	}
	
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	XQDebug(@"\n- (void)textViewDidChange:(UITextView *)textView\n");
	if (textFieldForAddionalNotes.text) {
		
		if ([textFieldForAddionalNotes.text length] > 140) {
			textFieldForAddionalNotes.text = [textFieldForAddionalNotes.text substringToIndex:140];
		}
		self.wordsLabel.text = [NSString stringWithFormat:@"%d/140 chars", [textFieldForAddionalNotes.text length]];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
	
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
	self.view.backgroundColor = [UIColor blackColor];
}


- (void)dealloc {
	
	XQDebug(@"\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Select Question Controller dealloc\n");
	
	self.selectQuestionButton = nil;
	self.selectQuestionLabel = nil;
	self.additionalNoteTitle = nil;
	self.wordsLabel = nil;
	
	self.textFieldRoundedWrapper = nil;
	self.textFieldForAddionalNotes = nil;
	
	self.questions = nil;
	self.selectQuestionView = nil;
	self.selectedImage = nil;
	self.thumnailImage = nil;
	self.backGroundImage = nil;

	self.tableView = nil;

    [super dealloc];
}
@end
