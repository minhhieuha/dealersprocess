    //
//  GiveopinionController.m
//  Stylelogue
//


//

#import "GiveopinionController.h"


@implementation GiveopinionController

@synthesize opinionsView;
@synthesize backgroundImage;
@synthesize selectedImage;
@synthesize textFieldRoundedWrapper;
@synthesize textFieldForAddionalNotes;
@synthesize backGround;
@synthesize it;
@synthesize opinionList;


- (id)init {
    if ((self = [super init])) {
		
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Need Opinions"];
    }
    return self;
}

- (id)initWithItem:(Item*)it{
    if ((self = [super init])) {
		self.it = it;
		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"Need Opinions"];
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
	self.backgroundImage.image = self.it.originPhoto;
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	[self.view addSubview:self.backgroundImage];
	[self.backgroundImage setAlpha:0.2];

	
	UIButton *button = [UIButton buttonWithImageNamed:@"images/button.back.png"];//change to cancel image for this button
	
	NSLog(@"\nCancel cancel\n");
	[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.leftBarButtonItem = favorite;
	[favorite release];

	self.opinionsView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 355)];
	self.opinionsView.backgroundColor = [UIColor clearColor];
	[self.opinionsView setOpaque:NO];
	[self.view addSubview:opinionsView];
	
	UIView *toolbar = [[GradientView alloc] initWithFrame:CGRectMake(0, 357, 320, 60)];
	[self.view addSubview:toolbar];
	

	UIButton *addButton = [UIButton numericPadButton: @"images/icon.submit.opinion.png"];
	[addButton addTarget:self action:@selector(addOpinion) forControlEvents:UIControlEventTouchUpInside];
	
	[addButton setLeft:140];
	[addButton setTop:(toolbar.height - addButton.height)/2];
	[toolbar addSubview:addButton];
	
	[addButton release];
	
	[toolbar release];
	
	
	self.backGround = [[UIView alloc] initWithFrame:self.view.bounds];
	[self.backGround setAlpha:0.0];
	[self.view addSubview:self.backGround];
	[self.backGround setBackgroundColor:[UIColor blackColor]];
	
	
	self.textFieldRoundedWrapper = [UIView viewWithStretchableBackgroundImage:@"images/textfield.background.png" widthCap:11 andHeightCap:11];
	[self.textFieldRoundedWrapper setLeft:20];
	//[self.textFieldRoundedWrapper setTop:100];
	[self.textFieldRoundedWrapper setHeight:200];
	
	
	[self.view addSubview:self.textFieldRoundedWrapper];
	
	self.textFieldForAddionalNotes = [[UITextView alloc] initWithFrame:CGRectInset(self.textFieldRoundedWrapper.bounds, 8, 8)];
	[self.textFieldForAddionalNotes setFont:[UIFont fontWithName:@"Helvetica" size:15]];
	[self.textFieldRoundedWrapper addSubview:textFieldForAddionalNotes];
	[self.textFieldForAddionalNotes clampFlexibleMiddle];
	[self.textFieldForAddionalNotes setDelegate:self];
	[self.textFieldForAddionalNotes setKeyboardAppearance:UIKeyboardAppearanceAlert];

	[self.textFieldRoundedWrapper setTop:0-self.textFieldRoundedWrapper.height];
	
	
	//list all opinion of this items
	StylelogueAppDelegate *myDelegate = (StylelogueAppDelegate *)[[UIApplication sharedApplication] delegate];
	[myDelegate listOpinionsOfQuestion:it.question.qID numberOpinionsPerpage:100 pageNum:1 delegate:self];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"\nBegin to parse Opinions: %@\n", [request responseString]);	
	
	
	StylelogueAppDelegate *myDelegate = (StylelogueAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.opinionList = [myDelegate parseOpinions:[request responseString]];
	//begin to update the interface
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];  
	NSData *myData = [NSData dataWithContentsOfFile:filePath];  
	if (myData) {  
		NSLog(@"\nLoad content is ok\n"); 
		NSString *template = [[NSString alloc] initWithData:myData encoding:NSASCIIStringEncoding];
		
		NSLog(@"\ntemplate is: %@\n", template);
		NSString *str=[[NSString alloc] init];
		for (int i=0; i<[self.opinionList count]; i++) {
			Opinion *op = (Opinion*)[self.opinionList objectAtIndex:i];
			str = [NSString stringWithFormat:@"%@%@", str,[NSString stringWithFormat:template, @"images/icon.liked.item.png", op.owner.fb_user_id, op.posted_at, op.content]];
			NSLog(@"\nFacebook ID: %@\n", op.owner.fb_user_id);
			NSLog(@"\nstr: %@\n", str);
		}
		NSLog(@"\nOpinion %d-->%@\n", str);
		[template release];
		[opinionsView loadHTMLString: str baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
	} 
	
	NSLog(@"\nOpinion count: %d\n", [self.opinionList count]) ;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	
}

-(void)cancelOpinion
{
	NSLog(@"\nCancel Opinion\n");
	
	[self.textFieldForAddionalNotes resignFirstResponder];
	[UIView beginAnimations:NULL context:NULL];
	[self.textFieldRoundedWrapper setTop:0-self.textFieldRoundedWrapper.height];
	[UIView commitAnimations];
	[self.backGround setAlpha:0.0];
	
	UIButton *button = [UIButton buttonWithImageNamed:@"images/button.back.png"];//change to cancel image for this button
	
	NSLog(@"\nCancel cancel\n");
	[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	self.navigationItem.leftBarButtonItem = favorite;
	self.navigationItem.rightBarButtonItem = nil;
	[favorite release];
}


-(void)postOpinion
{
	StylelogueAppDelegate *myDelegate = (StylelogueAppDelegate *)[[UIApplication sharedApplication] delegate];
	[myDelegate addOpinionForItem:it.itemID questionID:it.question.qID content:self.textFieldForAddionalNotes.text delegate: nil];
}

-(void)addOpinion
{
	
	
	
//	UIButton *button = [UIButton buttonWithImageNamed:@"images/button.back.png"];//change to cancel image for this button
//	
//	NSLog(@"\nCancel cancel\n");
//	[button addTarget:self action:@selector(cancelOpinion) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelOpinion)];
	
	self.navigationItem.leftBarButtonItem = favorite;
	[favorite release];
	
	
	//button = [UIButton buttonWithImageNamed:@"images/button.back.png"];//change to cancel image for this button
	
	//NSLog(@"\nCancel cancel\n");
	//[button addTarget:self action:@selector(postOpinion) forControlEvents:UIControlEventTouchUpInside];
	favorite = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postOpinion)];
	
	self.navigationItem.rightBarButtonItem = favorite;
	[favorite release];
	
	
	[self.backGround setAlpha:1];
	
	[UIView beginAnimations:NULL context:NULL];
	[self.textFieldRoundedWrapper setTop:100];
	[UIView commitAnimations];
	
	[self.textFieldForAddionalNotes becomeFirstResponder];
	[UIView beginAnimations:NULL context:NULL];
	[textFieldRoundedWrapper setFrame:CGRectMake(textFieldRoundedWrapper.frame.origin.x, 12, textFieldRoundedWrapper.frame.size.width, 180)];
	[UIView commitAnimations];
}



-(void)backFunction
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

//		[UIView beginAnimations:NULL context:NULL];
//		[textFieldRoundedWrapper setFrame:CGRectMake(textFieldRoundedWrapper.frame.origin.x, 12, textFieldRoundedWrapper.frame.size.width, 180)];
//		[UIView commitAnimations];
		
		//		
		//		UIButton *button = [UIButton buttonWithImageNamed:@"images/button.back.png"];//change to cancel image for this button
		//		
		//		NSLog(@"\nkhashicansipdcihsadihciahsdipchoiahsdio\n");
		//		[button addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
		//		UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		//		
		//		self.navigationItem.rightBarButtonItem = favorite;
		//		self.navigationItem.leftBarButtonItem = nil;
		//		self.navigationItem.hidesBackButton = YES;
		//		[favorite release];
		
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
		[UIView beginAnimations:NULL context:NULL];
		[self.textFieldRoundedWrapper setTop:0-self.textFieldRoundedWrapper.height];
		[UIView commitAnimations];
		[self.backGround setAlpha:0.0];
		
		UIButton *button = [UIButton buttonWithImageNamed:@"images/button.back.png"];//change to cancel image for this button
		
		NSLog(@"\nCancel cancel\n");
		[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		self.navigationItem.leftBarButtonItem = favorite;
		self.navigationItem.rightBarButtonItem = nil;
		[favorite release];
		
		
		//
//		if (textView == textFieldForAddionalNotes) {
//			[UIView beginAnimations:NULL context:NULL];
//			[textFieldRoundedWrapper setFrame:CGRectMake(textFieldRoundedWrapper.frame.origin.x, 130, textFieldRoundedWrapper.frame.size.width, 40)];
//			[UIView commitAnimations];
//			
			
			//			UIButton *button = [UIButton buttonWithImageNamed:@"images/button.back.png"];//change to cancel image for this button
			//			
			//			NSLog(@"\nCancel cancel\n");
			//			[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
			//			UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
			//			
			//			self.navigationItem.leftBarButtonItem = favorite;
			//			self.navigationItem.rightBarButtonItem = nil;
			//			[favorite release];
			
		//}
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	self.opinionList = nil;
	self.textFieldRoundedWrapper = nil;
	self.textFieldForAddionalNotes = nil;
	self.backgroundImage = nil;
	self.opinionsView = nil;
	self.selectedImage = nil;
	self.backGround = nil;
	self.it = nil;
    [super dealloc];	
}

@end
