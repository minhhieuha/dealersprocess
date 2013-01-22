
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "Goody.h"
#import "Opinion.h"
#import "Owner.h"
#import "UISilentView.h"

@protocol ParsingFinishDelegate

-(void)didFinishParsing:(NSMutableArray*)parsedData;
-(void)didPostOpinion;
-(void)didFinishParsingQuestions:(NSMutableArray*)parsedData;

@end

@interface APIController : NSObject<ASIHTTPRequestDelegate, ParsingFinishDelegate> {
	
	NSString *userID;
	NSString *userName;
	NSString *currentCity;
	id<ParsingFinishDelegate> delegate;
	int task;
	ASIFormDataRequest *request;
	BOOL finish;
	BOOL alowNotify;
	NSString *message;
}

@property(nonatomic, retain) 	NSString *message;
@property(readwrite) BOOL alowNotify;
@property(nonatomic, retain) ASIFormDataRequest *request;
@property(nonatomic, assign) id<ParsingFinishDelegate> delegate;
@property(nonatomic, retain) NSString *userID;
@property(nonatomic, retain) NSString *userName;
@property(nonatomic, retain) NSString *currentCity;
@property(readwrite) 	int task;

+api;

-(void)cancelDownLoad;
-(void)getDataFromWebService:(int)num pageNum:(int)page which:(int)which;
-(void)createItem:(NSString*)thumbnailImage originImage:(NSString*)image longitude:(float)lo latitude:(float)la question:(NSString*)q additionalNote:(NSString*)note;
-(void)createItem2bis:(UIImage*)thumbnailImage originImage:(UIImage*)image longitude:(double)lo latitude:(double)la question:(NSString*)q additionalNote:(NSString*)note;
-(void)createUser:(NSString*)DeviceToken;
- (NSString *)urlEncodeValue:(NSString *)str;
-(void)listRecentItemOfCurrentUser:(int)num pageNum:(int)page;
-(void)listHostItemOfCurrentUser:(int)num pageNum:(int)page;
-(void)listItemOfLooksbook:(int)num pageNum:(int)page;
-(void)addOpinionForItem:(int)item questionID:(int)questionID content:(NSString*)content;
-(void)listOpinionsOfQuestion:(int)questionID numberOpinionsPerpage:(int)num pageNum:(int)page;
-(void)addOpinionForItem:(int)item questionID:(int)questionID content:(NSString*)content; 
-(void)listGoodies:(int)num pageNum:(int)page;

-(void)parseNotifications:(NSString*)data;
-(void)parseItems:(NSString*)data;
-(void)parseQuestions:(NSString*)data;
-(void)parseOpinions:(NSString*)data;
-(void)parseGoodies:(NSString*)data;

-(void)deleteItems:(NSString*)items;
-(void)likeItem:(int)item;
-(void)unlikeItem:(int)item;
-(void)likeGoody;
-(void)unlikeGoody;
-(void)addToLookbook:(int)item;
-(void)addGoodyToLookbook:(int)goody;
-(void)removeFromLookbook:(int)item type:(NSString*)type;
-(void)listQuestion:(int)num page:(int)page;
-(void)getAllNotifications:(int)num pageNum:(int)page;
-(void)removeOpinions:(int)item opinionID:(int)opinionID andPassword:(NSString*)pass;


#pragma mark Push notification API

+ (NSString*)base64forData:(NSData*)theData;
-(void)registerTheDeviceInfo:(NSString*)deviceToken deviceAlias:(NSString*)deviceAlias;
-(void)postNotificationToUserByUserID:(NSString*)content userid:(NSString*)uid itemID:(int*)itemID;

#pragma mark -------------

@end
