
#import "IconDownloader.h"
#import "UIViewExtension.h"
#import "Item.h"
#import "UIImage+WhiteBorder.h"

#define kAppIconHeight 57


@implementation IconDownloader

@synthesize iRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize status;


#pragma mark NSURLConnection delegate methods


- (void)requestFinished:(ASIHTTPRequest *)request
{
	XQDebug(@"\nFinish Download....................<<<<<<<<<<<<<<<\n");
	UIImage *image = [[UIImage alloc] initWithData:[[[request responseData] retain] autorelease]];

	if(status)
	{		
		CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		iRecord.icon = [UIGraphicsGetImageFromCurrentImageContext() whiteBorderedImage];
		
		if ([iRecord.type isEqualToString: @"goody"]) {
			iRecord.originPhoto = image;
		}
		UIGraphicsEndImageContext();

	}else {

		XQDebug(@"\nHave finish downloading origin image<<<<<<<<<<<<\n");
		if([[[[request originalURL] path] componentsSeparatedByString:@"loading_photo"] count] >= 2) {
			if (!iRecord.originPhoto) {
				iRecord.originPhoto = image;
				iRecord.originImageHaveLoaded = NO;
			}
		}else {
			iRecord.originImageHaveLoaded = YES;
			iRecord.originPhoto = image;
		}
	}

    [image release];
	
    // call our delegate and tell it that our icon is ready for display
	if (self.delegate) {
		
		[self.delegate appImageDidLoad:self.indexPathInTableView];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	delegate = nil;
}

#pragma mark API helper functions ------------------------


#pragma mark

- (void)dealloc
{
	if (imageConnection) {
		[imageConnection clearDelegatesAndCancel];
		[imageConnection release];
	}
	if (imageConnection1) {
		[imageConnection1 clearDelegatesAndCancel];
		[imageConnection1 release];
	}
	
	delegate = nil;
	[iRecord release];
	[indexPathInTableView release];
	[super dealloc];
}

- (void)startDownload
{
	NSString *path;

	iRecord.originImageHaveLoaded = NO;
	if (status) {
		
		path = iRecord.cropped_photo;
		
//		if ((iRecord.message != nil) && ([[iRecord.message componentsSeparatedByString:@"commented"] count] == 2)) {
//            
//            XQDebug(@"\nComment here here here...........\n");
//			
//			path = iRecord.photo;
//			NSURL *url = [NSURL URLWithString:path];
//			imageConnection1 = [[ASIHTTPRequest requestWithURL:url] retain];
//			[imageConnection1 setDelegate:self];
//			[imageConnection1 setRequestMethod:@"GET"];
//			[imageConnection1 startAsynchronous];
//		}

	}else {
		XQDebug(@"\nStart downloading loading image\n");
		path = iRecord.loading_photo;
		NSURL *url = [NSURL URLWithString:path];
		imageConnection1 = [[ASIHTTPRequest requestWithURL:url] retain];
		[imageConnection1 setDelegate:self];
		[imageConnection1 setRequestMethod:@"GET"];
		[imageConnection1 startAsynchronous];
		path = iRecord.photo;
	}
	
	XQDebug(@"\nStart downloading origin image\n");
	NSURL *url = [NSURL URLWithString:path];
	imageConnection = [[ASIHTTPRequest requestWithURL:url] retain];
	[imageConnection setDelegate:self];
	[imageConnection setRequestMethod:@"GET"];
	[imageConnection startAsynchronous];
}

-(void)cancel
{

}

- (void)cancelDownload
{

}

#pragma mark -

@end

