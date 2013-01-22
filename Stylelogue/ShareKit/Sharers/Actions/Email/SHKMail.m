//
//  SHKMail.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/17/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "SHKMail.h"


@implementation MFMailComposeViewController (SHK)

- (void)SHKviewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	// Remove the SHK view wrapper from the window
	[[SHK currentHelper] viewWasDismissed];
}

@end


@implementation SHKMail

#pragma mark -
#pragma mark Configuration : Service Defination

+ (NSString *)sharerTitle
{
	return @"Email";
}

+ (BOOL)canShareText
{
	return YES;
}

+ (BOOL)canShareURL
{
	return YES;
}

+ (BOOL)canShareImage
{
	return YES;
}

+ (BOOL)canShareFile
{
	return YES;
}

+ (BOOL)shareRequiresInternetConnection
{
	return NO;
}

+ (BOOL)requiresAuthentication
{
	return NO;
}


#pragma mark -
#pragma mark Configuration : Dynamic Enable

+ (BOOL)canShare
{
	return [MFMailComposeViewController canSendMail];
}

- (BOOL)shouldAutoShare
{
	return YES;
}


#pragma mark -
#pragma mark Share API Methods

- (BOOL)send
{
	//NSLog(@"\n- (BOOL)send\n");
	self.quiet = YES;
	
	if (![self validateItem])
		return NO;
	
	return [self sendMail]; // Put the actual sending action in another method to make subclassing SHKMail easier
}

- (BOOL)sendMail
{	//NSLog(@"\n- (BOOL)sendMail\n");
	MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
	mailController.mailComposeDelegate = self;
	
	NSString *body = [item customValueForKey:@"body"];
	
	if (body == nil)
	{
		if (item.URL != nil)
		{	
			NSString *urlStr = [item.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			if (body != nil)
				body = [body stringByAppendingFormat:@"<br/><br/>%@", urlStr];
			else
				body = urlStr;
		}
		
		if (item.data)
		{
			NSString *attachedStr = SHKLocalizedString(@"Attached: %@", item.title ? item.title : item.filename);
			
			if (body != nil)
				body = [body stringByAppendingFormat:@"<br/><br/>%@", attachedStr];
			
			else
				body = attachedStr;
			
			[mailController addAttachmentData:item.data mimeType:item.mimeType fileName:item.filename];
		}

		if (item.image)
		{
			NSString *base64String = [UIImageJPEGRepresentation(item.image, 1) base64Encoding];
			NSString * emailBody = [NSString stringWithFormat:@"<br><img src='data:image/png;base64,%@'/><br>%@", base64String, item.text];
			[mailController setMessageBody:emailBody isHTML:YES];	
		}else {
			NSString * emailBody = [NSString stringWithFormat:@"<br>%@", item.text];
			[mailController setMessageBody:emailBody isHTML:YES];	
		}

		// fallback
		if (body == nil)
			body = @"";
		
		// sig
		if (SHKSharedWithSignature)
		{
			body = [body stringByAppendingString:@"<br/><br/>"];
			body = [body stringByAppendingString:SHKLocalizedString(@"Sent from %@", SHKMyAppName)];
		}
		
		[item setCustomValue:body forKey:@"body"];
	}

	[mailController setToRecipients:item.recipients];
	[mailController setSubject:item.title];
//	[mailController setBccRecipients:item.Bccs];
//  [mailController setMessageBody:body isHTML:YES];
			
	[[SHK currentHelper] showViewController:mailController];
	
	return YES;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
	
	switch (result) 
	{
		case MFMailComposeResultSent:
			//NSLog(@"\nMFMailComposeResultSent\n");
			[self sendDidFinish];
			break;
		case MFMailComposeResultSaved:
			//NSLog(@"\nMFMailComposeResultSaved\n");
			[self sendDidFinish];
			break;
		case MFMailComposeResultCancelled:
			//NSLog(@"\nMFMailComposeResultCancelled\n");
			[self sendDidCancel];
			break;
		case MFMailComposeResultFailed:
			//NSLog(@"\nMFMailComposeResultFailed\n");
			[self sendDidFailWithError:nil];
			break;
	}
}


@end
