#import "APIController.h"
#define kcreateItem 1
#define kcreateUser 2
#define klistRecentItemOfCurrentUser 3
#define klistHostItemOfCurrentUser 4
#define klistItemOfLooksbook 5
#define kaddOpinionForItem 6
#define klistOpinionsOfQuestion 7
#define kaddOpinionForItem 8 
#define klistGoodies 9
#define kparseItems 10
#define kparseQuestions 11
#define kparseOpinions 12
#define kparseGoodies 13
#define kdeleteItems 14
#define klikeItem 15
#define kunlikeItem 16
#define klikeGoody 17
#define kunlikeGoody 18
#define kaddToLookbook 19
#define kremoveFromLookbook 20
#define klistQuestion 21
#define ktaskForPushNotificationAPI 22
#define ktaskSentPushNotification 23
#define kgetAllNotifications 24
#define kremoveOpinions 25

#define kApplicationKey @"hy18-G-gQ8Su_I_9U0z3bA"
#define kApplicationSecret @"zruyw1t9Ra-mWS5YWFmZAw"
#define kApplicationKeyMaster @"ZvryPMLpTiCxgmmg4LPoOQ"

static APIController * sharedAPI = nil;  

@implementation APIController

@synthesize userID;
@synthesize delegate;
@synthesize task;
@synthesize request;
@synthesize alowNotify;
@synthesize userName;
@synthesize currentCity;
@synthesize message;

#pragma mark-

#pragma mark  Config Server
	static NSString *UAServer = @"https://go.urbanairship.com";
	#define SINGAPORE_SERVER //using project server
	
	#ifdef MY_SERVER
	static NSString * originURL = @"http://stylelogue85.com";//http://localhost:3000/  http://local_stylelogue.com:3001/ http://stylelouge.projectwebby.com
	#else
	#ifdef SINGAPORE_SERVER
	static NSString * originURL = @"http://stylelogue.it";//http://localhost:3000/  http://local_stylelogue.com:3001/ http://stylelouge.projectwebby.com
	#else
	static NSString * originURL = @"http://192.168.0.111:3000";//http://localhost:3000/  http://local_stylelogue.com:3001/ http://stylelouge.projectwebby.com
	#endif
	#endif

static NSString * apiKey = @"3c1a9614b932788598319be14abdf05eb0b46a6";

#pragma mark-

#pragma mark API for push notification

-(void)postNotificationToUserByUserID:(NSString*)content userid:(NSString*)uid itemID:(int*)itemID
{
	if ([uid isEqualToString:self.userID]) {
		XQDebug(@"\nisequal uid<<<<<<<<<<<<<<=================\n");
		return;
	}
	
	XQDebug(@"\nDevice alias: %@\n", [NSString stringWithFormat: @"{\"aliases\": [\"%@\"]}", uid]);
	
	self.task = ktaskSentPushNotification;
	
    NSString *urlString = [NSString stringWithFormat:@"%@%@", UAServer, @"/api/push/"];
    NSURL *url = [NSURL URLWithString:urlString];
	
	request = [ASIFormDataRequest requestWithURL:url];

    //Send along our device alias as the JSON encoded request body
    if(uid != nil && [uid length] > 0) {
		[request addRequestHeader:@"Content-Type" value:@"application/json"];
		XQDebug(@"\nContent: %@\n", [NSString stringWithFormat: @"{\"aliases\": [\"%@\"], \"aps\":{\"alert\":\"%@\", \"sound\":\"default\", \"extra\":\"%d\"}}", uid, content, itemID]);
		[request appendPostData:[[NSString stringWithFormat: @"{\"aliases\": [\"%@\"], \"aps\":{\"alert\":\"%@\", \"sound\":\"default\", \"extra\":\"%d\"}}", uid, content, itemID]
								 dataUsingEncoding:NSUTF8StringEncoding]];
    }
	
	[request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@",//remember to change when change to deploy project
													  [APIController base64forData:[[NSString stringWithFormat:@"%@:%@",
																					 kApplicationKey,
																					 kApplicationKeyMaster] dataUsingEncoding: NSUTF8StringEncoding]]]];
	
	XQDebug(@"\n%@\n", [NSString stringWithFormat:@"Basic %@",//remember to change when change to deploy project
						[APIController base64forData:[[NSString stringWithFormat:@"%@:%@",
													   kApplicationKey,
													   kApplicationKeyMaster] dataUsingEncoding: NSUTF8StringEncoding]]]);
    
	[request setDelegate:self];
	[request startAsynchronous];
}

+(NSString*)base64forData:(NSData*)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

-(void)registerTheDeviceInfo:(NSString*)deviceToken deviceAlias:(NSString*)deviceAlias
{
	XQDebug(@"\nTemplate: %@\n", [NSString stringWithFormat: @"{\"alias\": \"%@\"}", deviceAlias]);
	
	self.task = ktaskForPushNotificationAPI;
	
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@/", UAServer, @"/api/device_tokens/", deviceToken];
    NSURL *url = [NSURL URLWithString:urlString];
	
	request = [ASIFormDataRequest requestWithURL:url];
	[request setRequestMethod:@"PUT"];
    
    // Send along our device alias as the JSON encoded request body
    if(deviceAlias != nil && [deviceAlias length] > 0) {
		[request addRequestHeader:@"Content-Type" value:@"application/json"];
		[request appendPostData:[[NSString stringWithFormat: @"{\"alias\": \"%@\"}", deviceAlias]
                              dataUsingEncoding:NSUTF8StringEncoding]];
    }
	
	[request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@",
													  [APIController base64forData:[[NSString stringWithFormat:@"%@:%@",
																					 kApplicationKey,
																					 kApplicationSecret] dataUsingEncoding: NSUTF8StringEncoding]]]];
	[request setDelegate:self];
	[request startAsynchronous];
}


- (id)initWithUserID:(NSString*)userID {
	
    if ((self = [super init])) {
		self.userID = userID;
    }
    return self;
}

#pragma mark-

#pragma mark  singleton medthod
+(APIController*)api
{
	@synchronized(self)
	{
		if (sharedAPI == nil) {
			XQDebug(@"\nCreate new API\n");
			sharedAPI = [[APIController alloc] init];
		}  
	}
	return sharedAPI;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedAPI == nil) {
            sharedAPI = [super allocWithZone:zone];
            return sharedAPI;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

#pragma mark-

#pragma mark NSURLConnection delegate methods

-(void)cancelDownLoad
{
	XQDebug(@"\ncancel request.....>>>>>>>>>>>>\n");
	if (self.delegate) {
		XQDebug(@"\ncancel request.....>>>>>>>>>>>>\n");
		if (self.request) {
			XQDebug(@"\ncancel request.....>>>>>>>>>>>>\n");
			[self.request clearDelegatesAndCancel];
		}
		self.delegate = nil;
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	if (self.task == klistQuestion) {

		[self performSelectorOnMainThread:@selector(parseQuestions:) withObject:[request responseString] waitUntilDone:NO];
	}else if (self.task == kcreateItem || self.task == klistRecentItemOfCurrentUser || self.task == klistHostItemOfCurrentUser || self.task == klistItemOfLooksbook || 	self.task == klistGoodies) {
		

		[self performSelectorOnMainThread:@selector(parseItems:) withObject:[request responseString] waitUntilDone:NO];
		
	}else if(self.task == kaddOpinionForItem||self.task == kcreateUser || self.task == klikeItem || self.task == kunlikeItem)
	{

        XQDebug(@"\n---->>>did Post: %@\n", [request responseString]);
		if (self.task == kaddOpinionForItem) {

			if (delegate) {

                XQDebug(@"\n---->>>Ddid Post: %@\n", [request responseString]);
				[delegate didPostOpinion];
			}
		}
	}else if (self.task == klistOpinionsOfQuestion) {

		[self performSelectorOnMainThread:@selector(parseOpinions:) withObject:[request responseString] waitUntilDone:NO];
	}else if(self.task == ktaskForPushNotificationAPI || self.task == ktaskSentPushNotification)
	{

	}else if (self.task == kgetAllNotifications) {

		[self performSelectorOnMainThread:@selector(parseNotifications:) withObject:[request responseString] waitUntilDone:NO];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    XQDebug(@"\nFAiled: %@\n", [request error]);
	if (self.task == kcreateItem) {
		[self.delegate didFinishParsing:nil];
	}else {
		self.delegate = nil;	
	}
}

#pragma mark-

#pragma mark API helper functions

//18 - Delete Opinions
//URL: DELETE /opinions/iphone_destroy.json?json={item_id: 'item_id', opinion_ids: []}
//
//Successful: { result: 'successful'}
//Failed: {result: 'failed'}
static NSString* removeOpinionFunction = @"/opinions/iphone_destroy.json?";
static NSString* removeOpinionFormat = @"{\"item_id\": \"%d\", \"opinion_ids\": [\"%d\"] , \"secret\":\"%@\"}";
///opinions/iphone_destroy.json?json={"item_id":"item_id","opinion_ids":[],"secret":"$superSecretP^asword"}

-(void)removeOpinions:(int)item opinionID:(int)opinionID andPassword:(NSString*)pass
{
	self.task = kremoveOpinions;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, removeOpinionFunction, apiKey, [self urlEncodeValue:[NSString stringWithFormat:removeOpinionFormat,item,opinionID, @"$superSecretP^asword"]]]];
    XQDebug(@"\nURL: %@\n", [NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, removeOpinionFunction, apiKey, [self urlEncodeValue:[NSString stringWithFormat:removeOpinionFormat,item,opinionID, @"$superSecretP^asword"]]]);
    request = [ASIFormDataRequest requestWithURL:url];
    [request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
    [request setDelegate:self];
    [request setRequestMethod:@"DELETE"];
    [request startAsynchronous];		
}

//
//19 - Notifications
//URL: GET /users/notifications.json?json={current_fb_user_id: 'current_fb_user_id', page: 1, per_page: 20}
static NSString* getNotificationFunction = @"/users/notifications.json?";
static NSString* getNotificationValueFormat = @"{\"authentication_token\": \"%@\", \"page\": \"%d\", \"per_page\": \"%d\"}";

-(void)getAllNotifications:(int)num pageNum:(int)page
{
	if ((self.userID != nil) && (![self.userID isEqualToString:@""])) {
		
		self.task = kgetAllNotifications;
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, getNotificationFunction, apiKey,[self urlEncodeValue:[NSString stringWithFormat:getNotificationValueFormat,userID,page,num]]]];
//        
//        NSURL *url = [NSURL URLWithString:@"http://stylelogue.it/users/notifications.json?api_key=3c1a9614b932788598319be14abdf05eb0b46a6&json=%7B%22current_fb_user_id%22%3A%20%22100001458318695%22%2C%20%22page%22%3A%20%221%22%2C%20%22per_page%22%3A%20%2220%22%7D"];
		request = [ASIFormDataRequest requestWithURL:url];
		[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
		[request setDelegate:self];
		[request setRequestMethod:@"GET"];
		[request startAsynchronous];		
	}
}

-(void)getDataFromWebService:(int)num pageNum:(int)page which:(int)which
{
	
}

- (NSString *)requestDone:(ASIHTTPRequest *)request
{

}

//create the item for current user
static NSString* createItemFunction = @"/items/iphone_create.json";
static NSString* createItemValueFormat = @"{\"item\": {\"fb_user_id\": \"%@\", \"raw_cropped_photo_base_64\": \"%@\", \"raw_photo_base_64\": \"%@\", \"longitude\": \"%f\", \"latitude\": \"%f\", \"question_attr\": {\"content\": \"%@\", \"additional_note\": \"%@\"}}}";

-(void)createItem:(NSString*)thumbnailImage originImage:(NSString*)image longitude:(float)lo latitude:(float)la question:(NSString*)q additionalNote:(NSString*)note
{
	self.task = kcreateItem;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, createItemFunction]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:createItemValueFormat,userID,thumbnailImage,image,lo,la,q,note] forKey:@"json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDone:)];
	[request startAsynchronous];
}

//2bis - Create Item
//URl: POST /items/iphone_create.json?json={item: {fb_user_id: 'fb_user_id', longitude: 'longitude', latitude: 'latitude', question_attr: {content: 'content', additional_note: 'additional_note'}}}&photo=<FileUpload>&cropped_photo=<FileUpload>&loading_photo=<FileUpload>
//
//Successful: {result: 'successful', item: ITEM_JSON}
//Failed: {result: 'failed'}

//create the item for current user
static NSString* createItemFunction2bis = @"/items/iphone_create.json";
static NSString* createItemValueFormat2bis_ = @"{\"item\": {\"fb_user_id\": \"%@\", \"longitude\": \"%f\", \"latitude\": \"%f\", \"question_attr\": {\"content\": \"%@\", \"additional_note\": \"%@\"}}}";
static NSString *createItemValueFormat2bis = @"{\"authentication_token\":\"%@\",\"item\":{\"longitude\":\"%f\",\"latitude\":\"%f\",\"question_attr\":{\"content\":\"%@\",\"additional_note\":\"%@\"}}}";

-(void)createItem2bis:(UIImage*)thumbnailImage originImage:(UIImage*)image longitude:(double)lo latitude:(double)la question:(NSString*)q additionalNote:(NSString*)note
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//begin to resize image when commit data
	CGFloat compression = 0.9f;
	NSData *data1 = UIImageJPEGRepresentation(thumbnailImage, compression);
	
	while ([data1 length] > 51200 && compression > 0.1) {
		compression -= 0.1;
		data1 = UIImageJPEGRepresentation(thumbnailImage, compression);
	}
	
	compression = 0.9f;
	NSData *data2 = UIImageJPEGRepresentation(image, compression);
	
	XQDebug(@"\nThumnail: w: %f, h: %f\n", image.size.width, image.size.height);
	while ([data2 length] > 204800 && compression > 0.1) {
		compression -= 0.1;
		data2 = UIImageJPEGRepresentation(image, compression);
	}
	
	UIImage *img = [image imageByScalingAndCroppingForSize:CGSizeMake(133, 200)];
	XQDebug(@"\nThumnail: w: %f, h: %f\n", img.size.width, img.size.height);
	XQDebug(@"\nSize: w: %f h: %f\n", img.size.width, img.size.height);
	compression = 0.9f;
	NSData *data3 = UIImageJPEGRepresentation(img, compression);
	while ([data3 length] > 1024 && compression > 0.1) {
		compression -= 0.1;
		data3 = UIImageJPEGRepresentation(img, compression);
	}
	
	XQDebug(@"\nData1=%f, Data2=%f\n", [data1 length], [data2 length]);
	self.task = kcreateItem;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, createItemFunction2bis]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:0];
	
    XQDebug(@"\n====================>>>>>>>>>>>>>>>>>Create Items: %@\n", [NSString stringWithFormat:createItemValueFormat2bis,userID,lo,la,q,note]);
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:createItemValueFormat2bis,userID,lo,la,q,note] forKey:@"json"];
	[request addData:data2 forKey:@"photo"];
	[request addData:data1 forKey:@"cropped_photo"];
	[request addData:data3 forKey:@"loading_photo"];
	[request setDelegate:self];
	//[request setDidFinishSelector:@selector(requestDone:)];
	[request startAsynchronous];
	[pool drain];
}

//create user for the first time to login
//URL: POST /users/iphone_create.json?json={user: {fb_user_id: 'fb_user_id', name: 'fb_user_name'}}
static NSString* createUserFunction = @"/users/iphone_create.json";
static NSString* createUserValueFormat = @"{\"user\": {\"fb_user_id\": \"%@\", \"name\": \"%@\", \"current_city\": \"%@\", \"iphone_uuid\":\"%@\"}}";

-(void)createUser:(NSString*)DeviceToken
{
	XQDebug(@"\nUser id is: %@\n", userID);
	//self.task = kcreateUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, createUserFunction]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:createUserValueFormat,userID, userName, currentCity, DeviceToken] forKey:@"json"];
	XQDebug(@"\n[NSString stringWithFormat:createUserValueFormat,userID, userName]=%@\n", [NSString stringWithFormat:createUserValueFormat,userID, userName, currentCity, DeviceToken]);
	//[request setDelegate:self];
	[request startAsynchronous];
}

//encode the data before we can send to server
- (NSString *)urlEncodeValue:(NSString *)str
{
	NSString *result = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return [result autorelease]; 
}

//list all recent the items
static NSString* listRecentItemsFunction = @"/items/iphone_list.json?";
static NSString* listRecentItemsValueFormat = @"{\"flag\": \"recent\", \"per_page\": \"%d\", \"page\": \"%d\", \"authentication_token\":\"%@\"}";

-(void)listRecentItemOfCurrentUser:(int)num pageNum:(int)page
{
	self.task = klistRecentItemOfCurrentUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, listRecentItemsFunction, apiKey,[self urlEncodeValue:[NSString stringWithFormat:listRecentItemsValueFormat,num,page,userID]]]];
    
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	[request setDelegate:self];
	[request setRequestMethod:@"GET"];
	[request startAsynchronous];
}

//list all hot item of current user
static NSString* listHotItemsFunction = @"/items/iphone_list.json?";
static NSString* listHotItemsValueFormat = @"{\"flag\": \"hot\", \"per_page\": \"%d\", \"page\": \"%d\", \"authentication_token\": \"%@\"}";

-(void)listHostItemOfCurrentUser:(int)num pageNum:(int)page
{
    XQDebug(@"\nUser ID: %@\n", userID);
	self.task = klistHostItemOfCurrentUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, listHotItemsFunction, apiKey,[self urlEncodeValue:[NSString stringWithFormat:listHotItemsValueFormat,num,page,userID]]]];
	
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request setDelegate:self];
	[request setRequestMethod:@"GET"];
	[request startAsynchronous];
}


//list item of look book for current user
static NSString* listLooksbookFunction = @"/items/iphone_lookbook_items.json?";
static NSString* listLooksbookValueFormat = @"{\"authentication_token\": \"%@\", \"page\": \"%d\", \"per_page\": \"%d\"}";

-(void)listItemOfLooksbook:(int)num pageNum:(int)page
{
	self.task = klistItemOfLooksbook;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, listLooksbookFunction, apiKey,[self urlEncodeValue:[NSString stringWithFormat:listLooksbookValueFormat, userID,page, num]]]];
	XQDebug(@"\n[NSString stringWithFormat,originURL, listLooksbookFunction, apiKey,[self urlEncodeValue:[NSString stringWithFormat:listLooksbookValueFormat, userID,page, num]]]=%@\n", [NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, listLooksbookFunction, apiKey,[self urlEncodeValue:[NSString stringWithFormat:listLooksbookValueFormat, userID,page, num]]]);
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request setDelegate:self];
	[request setRequestMethod:@"GET"];
	[request startAsynchronous];
}


//7 - Post an opinion
//URL: POST /opinions/iphone_create.json?json={opinion: {question_id: 'question_id', content: 'content', fb_user_id: 'fb_user_id'}}
//
//Successful: { result: 'successful', opinion: OPINION_JSON }
//Failed: {result: 'failed'}

//add opinion for current user
static NSString* addOpinionForItemFunction = @"/opinions/iphone_create.json";
//static NSString* addOpinionForItemFormat = @"{\"opinion\": {\"question_id\": \"%d\", \"content\": \"%@\", \"authentication_token\": \"%@\"}}";
static NSString* addOpinionForItemFormat = @"{\"opinion\": {\"question_id\": \"%d\", \"content\": \"%@\"}, \"authentication_token\": \"%@\"}";
//{"opinion":{"question_id":"question_id","content": "content"},"authentication_token":"authentication_token"}
-(void)addOpinionForItem:(int)item questionID:(int)questionID content:(NSString*)content
{
	XQDebug(@"\nadd Opinion for item: %@\n", userID);
	self.task = kaddOpinionForItem;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, addOpinionForItemFunction]];
	
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:addOpinionForItemFormat,questionID,content,userID] forKey:@"json"];
	XQDebug(@"\nRequest: %@\n", [NSString stringWithFormat:addOpinionForItemFormat,questionID,content,userID]);
	[request setDelegate:self];
	[request startAsynchronous];
}

//list all opinion of current of current item
static NSString* listOpinionsFunction = @"/opinions/iphone_list.json?";
static NSString* listOpinionsValueFormat = @"{\"question_id\": \"%d\", \"per_page\": \"%d\", \"page\": \"%d\"}";

-(void)listOpinionsOfQuestion:(int)questionID numberOpinionsPerpage:(int)num pageNum:(int)page
{
	self.task = klistOpinionsOfQuestion;
	XQDebug(@"\n-(void)listOpinionsOfQuestion:(int)questionID numberOpinionsPerpage:(int)num pageNum:(int)page:= %@\n", userID);
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, listOpinionsFunction, apiKey,[self urlEncodeValue:[NSString stringWithFormat:listOpinionsValueFormat, questionID,num,page]]]];
	
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request setDelegate:self];
	[request setRequestMethod:@"GET"];
	[request startAsynchronous];
}

//list goodies of current user
static NSString* listGoodiesFunction = @"/goodies/iphone_list.json?";
static NSString* listGoodiesValueFormat = @"{\"per_page\": \"%d\", \"page\": \"%d\",  \"authentication_token\": \"%@\"}";

-(void)listGoodies:(int)num pageNum:(int)page
{
	self.task = klistGoodies;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, listGoodiesFunction, apiKey,[self urlEncodeValue:[NSString stringWithFormat:listGoodiesValueFormat,num,page, userID]]]];
	
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request setDelegate:self];
	[request setRequestMethod:@"GET"];
	[request startAsynchronous];
}

//delete item
static NSString* deleteItemFunction = @"/items/iphone_destroy.json";
static NSString* deleteItemValueFormat = @"{\"item_ids\": [%@]}";

-(void)deleteItems:(NSString*)items
{
	self.task = kcreateUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, deleteItemFunction]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:@"delete" forKey:@"_method"];
	[request addPostValue:[NSString stringWithFormat:deleteItemValueFormat,items] forKey:@"json"];
	[request setDelegate:self];
	[request startAsynchronous];
}

//delete item
static NSString* likeItemFunction = @"/items/iphone_like.json";
static NSString* likeItemFormat = @"{\"item_id\": \"%d\", \"authentication_token\": \"%@\"}";
-(void)likeItem:(int)item
{
	self.task = klikeItem;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, likeItemFunction]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:likeItemFormat,item,userID] forKey:@"json"];

	//[request setDelegate:self];
	[request startAsynchronous];
}

//unlike item
static NSString* unlikeItemFunction = @"/items/iphone_unlike.json";
static NSString* unlikeItemFormat = @"{\"item_id\": \"%d\", \"authentication_token\": \"%@\"}";

-(void)unlikeItem:(int)item
{
	self.task = kunlikeItem;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, unlikeItemFunction]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:unlikeItemFormat,item,userID] forKey:@"json"];
	//[request setDelegate:self];
	[request startAsynchronous];
}

-(void)likeGoody
{
	
}

-(void)unlikeGoody
{
	
}

//add to look book
static NSString* addToLooksbookItemFunction = @"/items/iphone_add_to_lookbook.json";
static NSString* addToLooksbookItemFormat = @"{\"item_id\": \"%d\", \"authentication_token\": \"%@\"}";

-(void)addToLookbook:(int)item
{
	self.task = kcreateUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, addToLooksbookItemFunction]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:addToLooksbookItemFormat,item,userID] forKey:@"json"];
	//[request setDelegate:self];
	[request startAsynchronous];
	
}


//13bis - Add to Lookbook a Goody
//
//URL: POST /goodies/iphone_add_to_lookbook.json?json={goody_id: 'goody_id', fb_user_id: 'fb_user_id'}
//
//Successful: { result: 'successful' }
//Failed: { result: 'failed' }

//add to look book
static NSString* addGoodyToLooksbookItemFunction = @"/goodies/iphone_add_to_lookbook.json";
static NSString* addGoodyToLooksbookItemFormat = @"{\"goody_id\": \"%d\", \"fb_user_id\": \"%@\"}";

-(void)addGoodyToLookbook:(int)goody
{
	self.task = kcreateUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, addGoodyToLooksbookItemFunction]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:addGoodyToLooksbookItemFormat,goody,userID] forKey:@"json"];
	XQDebug(@"\n[NSString stringWithFormat:addGoodyToLooksbookItemFormat,goody,userID]: %@\n", [NSString stringWithFormat:addGoodyToLooksbookItemFormat,goody,userID]);
	//[request setDelegate:self];
	[request startAsynchronous];
}

//{things: [{type: 'item', id: 1}, {type: 'goody', id: 2}, ...], fb_user_id: 'fb_user_id'}
//remove from look book for current item
static NSString* removeFromLooksbookItemFunction = @"/items/iphone_remove_from_lookbook.json";
static NSString* removeFromLooksbookItemFormat = @"{\"things\": [{\"type\": \"%@\", \"id\": \"%d\"}], \"authentication_token\": \"%@\"}";

-(void)removeFromLookbook:(int)item type:(NSString*)type
{
	self.task = kcreateUser;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",originURL, removeFromLooksbookItemFunction]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setNumberOfTimesToRetryOnTimeout:RETRY_TIMES];
	
	[request addPostValue:apiKey forKey:@"api_key"];
	[request addPostValue:[NSString stringWithFormat:removeFromLooksbookItemFormat,type,item,userID] forKey:@"json"];
	XQDebug(@"\nksblvhldshlihvldhlvslhlvdfhlshl--->%@\n", [NSString stringWithFormat:removeFromLooksbookItemFormat,type,item,userID]);
	//[request setDelegate:self];
	[request startAsynchronous];
}

static NSString* listQuestionsFunction = @"/sample_questions/iphone_list.json?";
static NSString* listQuestionsValueFormat = @"{\"per_page\": \"%d\", \"page\": \"%d\"}";

-(void)listQuestion:(int)num page:(int)page
{
	self.task = klistQuestion;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@api_key=%@&json=%@",originURL, listQuestionsFunction, apiKey,[self urlEncodeValue:[NSString stringWithFormat:listQuestionsValueFormat,num,page]]]];
	request = [ASIFormDataRequest requestWithURL:url];
	[request setDelegate:self];
	[request setRequestMethod:@"GET"];
	[request startAsynchronous];
	
}

-(void)getAllQuestions
{
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"txt"];  
	NSData *myData = [NSData dataWithContentsOfFile:filePath];  
	if (myData) {  
		
		NSString *str = [[NSString alloc] initWithData:myData encoding:NSASCIIStringEncoding];
		[self parseQuestions:str];
		[str release];
	}
	
}

#pragma mark-

#pragma mark  DAta parser

-(void)parseNotifications:(NSString*)data
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray *iRecords = [[NSMutableArray array] retain];
	// Create new SBJSON parser object
	SBJSON *parser = [[SBJSON alloc] init];  
	XQDebug(@"\n------>>>>Content of respone data: %@\n", data);
	NSDictionary *dic = (NSDictionary *) [parser objectWithString:data error:nil];
	
	Goody * tempItem;
	Owner *tmp1;
	Question *tmp;
	int i=0;
	//NSArray* arr = [dic allKeys];
	if(![[dic objectForKey:@"result"] respondsToSelector:@selector(isEqualToString:)])
	{
		[parser release];
		[iRecords release];
		return;
	}
	
	if ([[dic objectForKey:@"result"] isEqualToString:@"successful"]) 
	{
		
		NSArray* dic2 =[dic objectForKey:@"notifications"];//list of the items get from web service, have to parse this data to get info of items

		for (NSObject* x in dic2) {
			
			NSDictionary* xd = (NSDictionary*)x;
			NSArray* keys = [xd allKeys];
			tempItem = [[Goody alloc] init];

			for (NSString* k in keys) 
			{	

				//author_fb_user_id
				if([k isEqualToString: @"item"])
				{
					NSDictionary* vd = [xd objectForKey:k];
					//begin to parse the items
					NSArray  *allKeys = [vd allKeys];
					for (NSString* kk in allKeys) {
						
						if([kk isEqualToString: @"number_of_added_to_lookbook"])
						{
							tempItem.number_of_added_to_lookbook = [[vd objectForKey:kk] intValue];
							XQDebug(@"\nNumber of added to lookbook: %d\n", tempItem.number_of_added_to_lookbook);
						}else 
							if([kk isEqualToString: @"description"])
							{
								tempItem._description = [vd objectForKey:kk];
							}else 
								if([kk isEqualToString: @"title"])
								{
									tempItem.title = [vd objectForKey:kk];
									Question *q = [[Question alloc] init];
									q.content = [vd objectForKey:kk];
									tempItem.question = q;
									[q release];
								}else 

									if([kk isEqualToString: @"current_user_lookbook"])
									{	
										tempItem.current_user_lookbook = [((NSString*)[vd objectForKey:kk]) isEqualToString:@"true"]?YES:NO;
										if(tempItem.current_user_lookbook)
										{
											XQDebug(@"\n====================current_user_lookbook==>%@==============================\n",[vd objectForKey:kk]);
										}
										
									}else 
										if([kk isEqualToString: @"photo"])
										{
											tempItem.photo = [vd objectForKey:kk];
											XQDebug(@"\ntempItem.photo: %@\n", tempItem.photo);
											
										}else 
                                            if([kk isEqualToString: @"cropped_photo"])
                                            {
                                                tempItem.cropped_photo = [vd objectForKey:kk];
                                                
                                                XQDebug(@"\ncropped_photo: %@\n", tempItem.cropped_photo);
                                            }else 
											if([kk isEqualToString: @"loading_photo"])
											{
												tempItem.loading_photo = [vd objectForKey:kk];
												XQDebug(@"\nloading photo: %@\n", tempItem.loading_photo);
												
											}
											else 
												
												if([kk isEqualToString: @"id"])
												{
													tempItem.itemID = [[vd objectForKey:kk] intValue]; 
													
												}else 
													if([kk isEqualToString: @"number_of_likes"]) 
													{
														tempItem.number_of_likes = [[vd objectForKey:kk] intValue]; 
														if (tempItem.number_of_likes<=0) {
															tempItem.number_of_likes = 0;
															
														}
													}else 
														if([kk isEqualToString:  @"owner"])
														{
															tmp1 = [[Owner alloc] init];
															tmp1.fb_user_id = [[vd objectForKey:kk] objectForKey:@"fb_user_id"];
															tmp1.user_id = [[[vd objectForKey:kk] objectForKey:@"user_id"] intValue];
															tmp1.name = [[vd objectForKey:kk] objectForKey:@"name"];
															XQDebug(@"\nName: %@\n", tmp1.name);
															tempItem.owner = tmp1;
															[tmp1 release];
														}else
															//																	if([kk isEqualToString: @"created_at"])
															//																	{
															//																		tempItem.created_at = [vd objectForKey:kk];
															//																	}else 
															if([kk isEqualToString: @"latitude"])
															{
																tempItem.latitude = [[vd objectForKey:kk] floatValue];
															}else 
																if([kk isEqualToString: @"current_user_like"])
																{
																	tempItem.current_user_like = ![[vd objectForKey:kk] isEqualToString:@"false"];
																}else 
																	if([kk isEqualToString: @"longitude"])
																	{
																		tempItem.longitude = [[vd objectForKey:kk] floatValue];
																	}else 
																		if([kk isEqualToString: @"question"])
																		{
																			tmp = [[Question alloc] init];
																			tmp.additional_note = [[vd objectForKey:kk] objectForKey:@"additional_note"];
																			XQDebug(@"\nLength = %@\n", tmp.additional_note);
																			
																			
																			tmp.content = [[vd objectForKey:kk] objectForKey:@"content"];
																			tmp.qID = [[[vd objectForKey:kk] objectForKey:@"id"] intValue];
																			tmp.number_of_opinions = [[[vd objectForKey:kk] objectForKey:@"number_of_opinions"] intValue];
																			tempItem.question = tmp;
																			[tmp release];
																			
																		}
					}
					
				}else 
				//author_fb_user_id
//				if([k isEqualToString: @"author_fb_user_id"])
//				{
//					tempItem.cropped_photo =   [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [xd objectForKey:k]];
//					XQDebug(@"\nCroped photo: %@\n", tempItem.cropped_photo);
//				}else 
					if([k isEqualToString: @"created_at"])
					{
						tempItem.created_at = [xd objectForKey:k];
						XQDebug(@"\nCreated time: %@\n", tempItem.created_at);
						
					}else 
						if([k isEqualToString: @"message"])
						{
							tempItem.message = [xd objectForKey:k];
							XQDebug(@"\nmessage: %@\n", tempItem.message);
							
						}
			}
				
			[iRecords insertObject:tempItem atIndex:i++];
			[tempItem release];
			
		}
	}
	
	if ([iRecords count] == 0) 
	{
		Goody* it = [[Goody alloc] init];
		Question *q =  [[Question alloc] init];
		it.question = q;
		it.question.content = @"";
		it.question.additional_note = @"No Notification Available";
		it.icon = [UIImage imageNamed:@"Placeholder.png"];
		[iRecords insertObject:it atIndex:0];
		[q release];
		[it release];
	}
    
    
    XQDebug(@"\nParse Result: %@\n", iRecords);
	
	if (self.delegate)
	{
		[self.delegate didFinishParsing:iRecords];
	}
	[iRecords release];
	[parser release];	
	[pool drain];

}

-(void)parseItems:(NSString*)data
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray *iRecords = [[NSMutableArray array] retain];
	// Create new SBJSON parser object
	SBJSON *parser = [[SBJSON alloc] init];  
	XQDebug(@"\n------>>>>Content of respone data: %@\n", data);
	NSDictionary *dic = (NSDictionary *) [parser objectWithString:data error:nil];
	Owner *tmp1;
	Question *tmp;
	Goody * tempItem;
	int i=0;
	//NSArray* arr = [dic allKeys];
	if(![[dic objectForKey:@"result"] respondsToSelector:@selector(isEqualToString:)])
	{
		[parser release];
		[iRecords release];
		return;
	}
	
	self.message = (NSString*)[dic objectForKey:@"message"];//list of the items get from web service, have to parse this data to get info of items
	if (!self.message) {
		self.message = @"";
	}
	//XQDebug(@"\nMessage: %@\n", [dic objectForKey:@"result"]);

	if ([[dic objectForKey:@"result"] isEqualToString:@"successful"]) {
		
		//XQDebug(@"\n>>>>>if ([[dic objectForKey:@result] isEqualToString:successful]) {\n");
		NSArray* dic2 =[dic objectForKey:@"items"];//list of the items get from web service, have to parse this data to get info of items
		if (dic2 == nil) {
			dic2 =[dic objectForKey:@"goodies"];
		}
		
		if (dic2 == nil) {
			
			if ([iRecords count] == 0) {
				Goody* it = [[Goody alloc] init];
				
				it.photo = [[[dic objectForKey:@"item"] objectForKey:@"item"] objectForKey:@"photo"];
				
				it.give_opinion_url = [[[dic objectForKey:@"item"] objectForKey:@"item"] objectForKey:@"give_opinion_url"];
				
				it.message = [dic  objectForKey:@"message"];
			//	XQDebug(@"\nMessage is: %@\n", [dic  objectForKey:@"message"]);
			//	XQDebug(@"\nPhoto.>>>>>>>>>:%@\n", it.photo);
				[iRecords insertObject:it atIndex:0];
			//	XQDebug(@"\ncount: %d\n", [iRecords count]);
				[it release];
			}
			
			if (self.delegate) {
				
				[self.delegate didFinishParsing:iRecords];
			}
			[iRecords release];
			[parser release];	
			[pool drain];
			
			return;
		}
		
		//XQDebug(@"\ndic2=%@\n", dic2);
		for (NSObject* x in dic2) {
			NSDictionary* xd = (NSDictionary*)x;
			NSArray* keys = [xd allKeys];
			tempItem = [[Goody alloc] init];

			for (NSString* k in keys) {	
				
				NSDictionary* vd = [xd objectForKey:k];
				tempItem.type = k; 
				NSArray  *allKeys = [vd allKeys];
				for (NSString* kk in allKeys) {
					
					if (![kk respondsToSelector:@selector(isEqualToString:)]) {
						continue;
					}
					
					if([kk isEqualToString: @"give_opinion_url"])
					{
						tempItem.give_opinion_url = [vd objectForKey:kk];
					}else 					
					if([kk isEqualToString: @"number_of_added_to_lookbook"])
					{
						tempItem.number_of_added_to_lookbook = [[vd objectForKey:kk] intValue];
					//	XQDebug(@"\nNumber of added to lookbook: %d\n", tempItem.number_of_added_to_lookbook);
					}else 
					if([kk isEqualToString: @"description"])
					{
						tempItem._description = [vd objectForKey:kk];
                        XQDebug(@"\n-----Description: %@\n", tempItem._description);
					}else
						if([kk isEqualToString: @"title"])
						{
							tempItem.title = [vd objectForKey:kk];
							Question *q = [[Question alloc] init];
							q.content = [vd objectForKey:kk];
                            q.additional_note = [vd objectForKey:@"subtitle"];
							tempItem.question = q;
							[q release];
                            
						}else 
							if([kk isEqualToString: @"photo_url"])
							{
								tempItem.cropped_photo = [vd objectForKey:kk];
							//	XQDebug(@"\nHello world: %@\n", tempItem.cropped_photo);
								tempItem.photo_url = [vd objectForKey:kk];
							}else				
								
								if([kk isEqualToString: @"current_user_lookbook"])
								{	
									tempItem.current_user_lookbook = [((NSString*)[vd objectForKey:kk]) isEqualToString:@"true"]?YES:NO;
									if(tempItem.current_user_lookbook)
									{
								//		XQDebug(@"\n====================current_user_lookbook==>%@==============================\n",[vd objectForKey:kk]);
									}
									
								}else 
									if([kk isEqualToString: @"photo"])
									{
										tempItem.photo = [vd objectForKey:kk];
									//	XQDebug(@"\ntempItem.photo: %@\n", tempItem.photo);
										
									}else 
										if([kk isEqualToString: @"cropped_photo"])
										{
											tempItem.cropped_photo = [vd objectForKey:kk];
											
										//	XQDebug(@"\ncropped_photo: %@\n", tempItem.cropped_photo);
										}else 
											if([kk isEqualToString: @"loading_photo"])
											{
												tempItem.loading_photo = [vd objectForKey:kk];
											//	XQDebug(@"\nloading photo: %@\n", tempItem.loading_photo);
												
											}
											else 
												
												if([kk isEqualToString: @"id"])
												{
													tempItem.itemID = [[vd objectForKey:kk] intValue]; 
													
												}else 
													if([kk isEqualToString: @"number_of_likes"]) 
													{
														tempItem.number_of_likes = [[vd objectForKey:kk] intValue]; 
														if (tempItem.number_of_likes<=0) {
															tempItem.number_of_likes = 0;
															
														}
													}else 
														if([kk isEqualToString:  @"owner"])
														{
															tmp1 = [[Owner alloc] init];
															tmp1.fb_user_id = [[vd objectForKey:kk] objectForKey:@"fb_user_id"];
															tmp1.user_id = [[[vd objectForKey:kk] objectForKey:@"user_id"] intValue];
															tmp1.name = [[vd objectForKey:kk] objectForKey:@"name"];
													//		XQDebug(@"\nName: %@\n", tmp1.name);
															tempItem.owner = tmp1;
															[tmp1 release];
														}else
															if([kk isEqualToString: @"created_at"])
															{
																tempItem.created_at = [vd objectForKey:kk];
															}else 
																if([kk isEqualToString: @"latitude"])
																{
																	tempItem.latitude = [[vd objectForKey:kk] floatValue];
																}else 
																	if([kk isEqualToString: @"current_user_like"])
																	{
																		tempItem.current_user_like = ![[vd objectForKey:kk] isEqualToString:@"false"];
																	}else 
																		if([kk isEqualToString: @"longitude"])
																		{
																			tempItem.longitude = [[vd objectForKey:kk] floatValue];
																		}else 
																			if([kk isEqualToString: @"question"])
																			{
																				tmp = [[Question alloc] init];
																				tmp.additional_note = [[vd objectForKey:kk] objectForKey:@"additional_note"];
																			//	XQDebug(@"\nLength = %@\n", tmp.additional_note);
																				
																				
																				tmp.content = [[vd objectForKey:kk] objectForKey:@"content"];
																				tmp.qID = [[[vd objectForKey:kk] objectForKey:@"id"] intValue];
																				tmp.number_of_opinions = [[[vd objectForKey:kk] objectForKey:@"number_of_opinions"] intValue];
																				tempItem.question = tmp;
																				[tmp release];
																				
																			}	
				}
							
			}

			[iRecords insertObject:tempItem atIndex:i++];
			[tempItem release];
		}
	}
    
	if ([iRecords count] == 0) {
		Goody* it = [[Goody alloc] init];
		Question *q =  [[Question alloc] init];
		it.question = q;
		it.question.content = @"";
		it.question.additional_note = @"No Item Available";
		it.icon = [UIImage imageNamed:@"Placeholder.png"];
		[iRecords insertObject:it atIndex:0];
		[q release];
		[it release];
	}
	if (self.delegate) {

		[self.delegate didFinishParsing:iRecords];
	}
	[iRecords release];
	[parser release];	
	[pool drain];
}

-(void)parseQuestions:(NSString*)data
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray *listOfQuestions = [[NSMutableArray array] retain];
	// Create new SBJSON parser object
	SBJSON *parser = [[SBJSON alloc] init];  
	
	NSDictionary *dic = (NSDictionary *) [parser objectWithString:data error:nil];

	Question *tmp;
	int i=0;
	NSArray* arr = [dic allKeys];
	if ([[dic objectForKey:[arr objectAtIndex:0]] isEqualToString:@"successful"]) {
		NSArray* dic2 =[dic objectForKey:[arr objectAtIndex:1]];//list of the items get from web service, have to parse this data to get info of items
		XQDebug(@"\nList of Question %@\n", [arr objectAtIndex:1]);
		for (NSObject* x in dic2) {
			NSDictionary* xd = (NSDictionary*)x;
			NSArray* keys = [xd allKeys];
			
			for (NSString* k in keys) {	
				XQDebug(@"\n%@\n", k);
				NSDictionary* vd = [xd objectForKey:k];
				NSArray* vdkey = [vd allKeys];
				tmp = [[Question alloc] init];
				for (NSString* kk in vdkey) {
					XQDebug(@"\n%@\n", kk);
					
					if([kk isEqualToString: @"id"])
					{
						
						tmp.qID = [[vd objectForKey:kk] intValue];
						
					}else 
						if([kk isEqualToString: @"content"])
						{
							tmp.content = [vd objectForKey:kk];
						}				
					
				}
				
 				[listOfQuestions insertObject:tmp atIndex:i++];
				[tmp release];
			}
			
		}
	}

	for (int i=0; i<[listOfQuestions count]; i++) {
		Question *t = (Question*)[listOfQuestions objectAtIndex:i];
		XQDebug(@"\nid: %d, content: %@\n", t.qID,t.content);
	}
	
	if (self.delegate) {
		[self.delegate didFinishParsingQuestions:listOfQuestions];	
	}
	[listOfQuestions release];
	[parser release];
	[pool drain];
}

-(void)parseOpinions:(NSString*)data
{
	XQDebug(@"\ndata for parse opinions: %@\n", data);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray *listOfOpinions = [[NSMutableArray array] retain];

	SBJSON *parser = [[SBJSON alloc] init];  
	
	NSDictionary *dic = (NSDictionary *) [parser objectWithString:data error:nil];

	Opinion *tmp;
	int i=0;
	NSArray* arr = [dic allKeys];
	if ([[dic objectForKey:[arr objectAtIndex:0]] isEqualToString:@"successful"]) {
		NSArray* dic2 =[dic objectForKey:[arr objectAtIndex:1]];//list of the items get from web service, have to parse this data to get info of items
		XQDebug(@"\nList of Question %@\n", [arr objectAtIndex:1]);
		for (NSObject* x in dic2) {
			NSDictionary* xd = (NSDictionary*)x;
			NSArray* keys = [xd allKeys];
			
			for (NSString *k in keys) {	
				
				XQDebug(@"\n%@\n", k);
				NSDictionary* vd = [xd objectForKey:k];
				NSArray* vdkey = [vd allKeys];
				tmp = [[Opinion alloc] init];
				for (NSString* kk in vdkey) {
					XQDebug(@"\n%@\n", kk);
					
					if([kk isEqualToString: @"id"])
					{
						
						tmp.ID = [[vd objectForKey:kk] intValue];
						
					}else 
						if([kk isEqualToString: @"content"])
						{
							tmp.content = [vd objectForKey:kk];
							
							NSString *opinion = tmp.content;
							tmp.content = [opinion stringByReplacingOccurrencesOfString:@"<myNewLine>" withString:@"\n"];
							
						}else 
							if([kk isEqualToString: @"posted_at"])
							{
								tmp.posted_at = [vd objectForKey:kk];
							}else 
								if([kk isEqualToString: @"owner"])
								{
									
									NSDictionary *d = [vd objectForKey:kk];
									NSArray *ss = [d allKeys];
									
									Owner *t = [[Owner alloc] init];
									for (NSString *s in ss) {
										
										if([s isEqualToString: @"fb_user_id"])
										{
											XQDebug(@"\nfb_user_id: %@\n", [d objectForKey:s]);
											t.fb_user_id = [d objectForKey:s];
											
										}else if([s isEqualToString: @"user_id"])
										{
											t.user_id = [[d objectForKey:s] intValue];
										}else if([s isEqualToString: @"like_item"])
										{
											t.like_item = ([[d objectForKey:s] isEqualToString:@"false"]?NO:YES);
										}else if([s isEqualToString: @"name"])
										{
											t.name = [d objectForKey:s];
											XQDebug(@"\nName: %@\n", t.name);
										}
									}
									
									tmp.owner = t;
									[t release];
								}				
				}
				
 				[listOfOpinions insertObject:tmp atIndex:i++];
				[tmp release];
			}
			
		}
	}
	
	
	if ([listOfOpinions count] == 0) {
		Opinion* it = [[Opinion alloc] init];
		it.ID = -1111;
		it.content = @"No Opinion Available";
		[listOfOpinions insertObject:it atIndex:0];
		[it release];
	}
	
	for (int i=0; i<[listOfOpinions count]; i++) {
		Opinion *t = (Opinion*)[listOfOpinions objectAtIndex:i];
		XQDebug(@"\nid: %d, content: %@\n", t.ID,t.content);
	}
	
	if (self.delegate) {
		
		[self.delegate didFinishParsing:listOfOpinions];
	}else {
		XQDebug(@"\ndelegate equal NULL\n");
	}

	[listOfOpinions release];
	[parser release];
	[pool drain];
}

-(void)parseGoodies:(NSString*)data
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray* listOfGoodies = [[NSMutableArray array] retain];
	// Create new SBJSON parser object
	SBJSON *parser = [[SBJSON alloc] init];  
	
	NSDictionary *dic = (NSDictionary *) [parser objectWithString:data error:nil];

	Goody *tmp;
	int i=0;
	NSArray* arr = [dic allKeys];
	if ([[dic objectForKey:[arr objectAtIndex:0]] isEqualToString:@"successful"]) {
		NSArray* dic2 =[dic objectForKey:[arr objectAtIndex:1]];//list of the items get from web service, have to parse this data to get info of items
		XQDebug(@"\nList of Question %@\n", [arr objectAtIndex:1]);
		for (NSObject* x in dic2) {
			NSDictionary* xd = (NSDictionary*)x;
			NSArray* keys = [xd allKeys];
			
			for (NSString* k in keys) {	
				XQDebug(@"\n%@\n", k);
				NSDictionary* vd = [xd objectForKey:k];
				NSArray* vdkey = [vd allKeys];
				tmp = [[Goody alloc] init];
				for (NSString* kk in vdkey) {
					XQDebug(@"\n%@\n", kk);
					
					if([kk isEqualToString: @"id"])
					{
						
						tmp.GID = [[vd objectForKey:kk] intValue];
						
					}else 
						if([kk isEqualToString: @"description"])
						{
							tmp._description = [vd objectForKey:kk];
						}else 
							if([kk isEqualToString: @"title"])
							{
								tmp.title = [vd objectForKey:kk];
								Question *q = [[Question alloc] init];
								q.content = [vd objectForKey:kk];
								tmp.question = q;
								[q release];
							}else 
								if([kk isEqualToString: @"photo_url"])
								{
									tmp.cropped_photo = [vd objectForKey:kk];
									tmp.photo = [vd objectForKey:kk];
									XQDebug(@"\nHello world: %@\n", tmp.cropped_photo);
									tmp.photo_url = [vd objectForKey:kk];
								}				
				}
				
 				[listOfGoodies insertObject:tmp atIndex:i++];
				[tmp release];
			}
			
		}
	}
	
	if (self.delegate) {
		
		[self.delegate didFinishParsing:listOfGoodies];
	}
	[listOfGoodies release];
	[parser release];
	[pool drain];
}

#pragma mark-

#pragma mark Dealloc

-(void)dealloc
{
	XQDebug(@"\n================>>>>>>>>>>>>>>>>>>>>>>>>>API dealloc\n");
	[userID release];
	[userName release];
	[request release];
	[currentCity release];
	[message release];
	[super dealloc];
}

#pragma mark-

@end
