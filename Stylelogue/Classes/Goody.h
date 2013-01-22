//
//  Goody.h
//  Stylelogue
//


//

#import <Foundation/Foundation.h>
#import "Item.h"


//{"result":"successful","goodies":
//	[{"goody":{
//		"title":"Shopping Center",
//		"photo_url":"http://stylelouge.projectwebby.com/system/photos/1/iphone_size/fbfdcef4-08b7-11e0-aa00-00248c3856b7.png?1292464712",
//		"id":"1",
//		"description":"Description of Shopping Center"}}]}

@interface Goody : Item {
	
	NSString *title;
	NSString *photo_url;
	int GID;
	NSString *_description;
}

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *photo_url;
@property(readwrite) int GID;
@property(nonatomic, retain) NSString *_description;

@end
