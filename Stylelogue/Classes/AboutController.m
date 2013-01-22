//  AboutController.m
//  Stylelogue
//
//  Created by Peter Quang Nguyen on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import "AboutController.h"


@implementation AboutController

@synthesize tableView;
- (id)init {
	
    if ((self = [super init])) {

		self.navigationItem.titleView = [FontLabel titleLabelNamed:@"About"];
		//[self.navigationItem setHidesBackButton:YES animated:YES];
		UIButton *button = [UIButton numericPadButton:@"images/button.back.png"];
		[button setTitle:@"back" forState:UIControlStateNormal];
		[button setFont:[UIFont fontWithName:FONT size:UINAVIGATIONBARSIZE]];
		button.titleLabel.textColor = MAINCOLOR;
		[button.titleLabel  setTextAlignment:UITextAlignmentCenter];
		
		[button addTarget:self action:@selector(backFunction) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *favorite = [[UIBarButtonItem alloc] initWithCustomView:button];
		
		self.navigationItem.leftBarButtonItem = favorite;
		[favorite release];
	}
	return self;
}

-(void)backFunction
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView {
	
	[super loadView];	
	self.view.backgroundColor = [UIColor blackColor];
	
	//begin to init the table view to show alll control to allow user to change all configs
	UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	[self setTableView:tableView];
	[tableView release];
	
	[self.view addSubview:self.tableView];
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	v.backgroundColor = [UIColor blackColor];
	[self.tableView setTableFooterView:v];
	[v release];
	
	self.tableView.backgroundColor = [UIColor clearColor];
	[self.tableView clampFlexibleMiddle];
	
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	self.tableView.scrollEnabled = NO;
	
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	self.tableView.separatorColor = RGBACOLOR(0x22, 0x22, 0x22, 1);
	

	
	AppMainNavigationController *mainController = (AppMainNavigationController*)self.navigationController;
	mainController.goFrom = 0;
	
}


#pragma mark Delegate and Data Source for UITableView

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (void)emailToMyFriend
{
	StylelogueAppDelegate *mainController = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
	SHKItem *item = [SHKItem text:@"Tell us what you think and how we can do better!"];
	item.title = [NSString stringWithFormat: @"Feedback from %@" , mainController.fbuserinfo.name];
	NSArray *recips = [NSArray arrayWithObjects:@"contact@stylelogue.it",nil];
	item.recipients = recips;
	[SHKMail shareItem:item];
}

- (void)emailToMyFriend2
{
	StylelogueAppDelegate *mainController = (StylelogueAppDelegate*)[[UIApplication sharedApplication] delegate];
	SHKItem *item = [SHKItem text:@"Need help? Tell us about it."];
	item.title = @"Contact Support";
	NSArray *recips = [NSArray arrayWithObjects:@"support@stylelogue.it",nil];
	item.recipients = recips;
	[SHKMail shareItem:item];
}

-(void)viewTerms
{
	ViewTerms *terms = [[ViewTerms alloc] init];
	[self.navigationController pushViewController:terms animated:YES];
	[terms release];
}

-(void)viewTerms1
{
	ViewTerms1 *terms = [[ViewTerms1 alloc] init];
	[self.navigationController pushViewController:terms animated:YES];
	[terms release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch ([indexPath row]) {
		case 0:
			[self emailToMyFriend];
			break;
			
		case 1:
			[self emailToMyFriend2];
			break;

		case 2:
			[self viewTerms];
			break;
			
		case 3:
			[self viewTerms1];
			break;
		default:
			break;
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	XQDebug(@"\nHEllo\n");
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UILabel *topLabel;
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	topLabel = [[[UILabel alloc] initWithFrame: CGRectMake( cell.frame.origin.x + 20, cell.frame.origin.y + 7, tableView.bounds.size.width,40)] autorelease];
	[topLabel setFont:[UIFont fontWithName:FONT size:FONTSIZE]];
	[topLabel setTextColor:MAINCOLOR];
	topLabel.backgroundColor = [UIColor clearColor];
	
	if ([indexPath row] != 4) {
		
		TableCellHilightedView *selectedView = [[TableCellHilightedView alloc] initWithFrame:CGRectMake(-555, 0, cell.frame.size.width, cell.frame.size.height)];
		cell.selectedBackgroundView = selectedView;
		[selectedView release];
		
		TableViewCellBackGroundView *backGroundView = [[TableViewCellBackGroundView alloc] initWithFrame:CGRectMake(-555, 0, cell.frame.size.width, cell.frame.size.height)];
		cell.backgroundView = backGroundView;
		[backGroundView release];
		
	}
	
	switch ([indexPath row]) {
		case 0:
			topLabel.text = @"Send feedback";
			break;
		case 1:
			topLabel.text = @"Contact support";
			break;
		case 2:
			topLabel.text = @"Terms of Service";
			break;
		case 3:
			topLabel.text = @"Privacy Policy";
			break;
		case 4:
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			topLabel.text = @"Stylelogue v1.0";
			topLabel.textColor = DATECOLOR;
			topLabel.left = 0;
			[topLabel setTextAlignment:UITextAlignmentCenter];
			[topLabel setFont:[UIFont fontWithName:FONT size:15]];
			break;
	}
	
	[cell.contentView addSubview:topLabel];

	return cell;
	
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];	
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
	[tableView release];
}


@end
