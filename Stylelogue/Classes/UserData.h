//
//  UserData.h
//  Stylelogue
//
//  Created by Quang Nguyen on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage-NSCoding.h"

///{"name":"quangnguyen","avatar_url":"http://stylelogue85.com/users/avatars/4/public.jpg?1309853649","result":"successful","user_id":4,"authentication_token":"xy0Lr0pZ2wERhPPlQuid","email":"vietquangdcs_2004@yahoo.com"}
@interface UserData : NSObject<NSCoding> {
    
    NSString *name;
    NSString *avatar_url;
    NSString *authentication_token;
    NSString *email;
    NSString  *password;
    int user_id;
    BOOL islogin;

}

@property(nonatomic, retain) NSString  *password;
@property(nonatomic, readwrite)     BOOL islogin;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *avatar_url;
@property(nonatomic, retain) NSString *authentication_token;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, readwrite) int user_id;

@end
