//
//  UserData.m
//  Stylelogue
//
//  Created by Quang Nguyen on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserData.h"


@implementation UserData

@synthesize name, avatar_url, authentication_token, email, user_id, islogin, password;


- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:avatar_url forKey:@"avatar_url"];
    [encoder encodeObject:authentication_token forKey:@"authentication_token"];
    [encoder encodeObject:email forKey:@"email"];
    [encoder encodeInt:user_id forKey:@"user_id"];
    [encoder encodeBool:islogin forKey:@"islogin"];
    [encoder encodeObject:password forKey:@"password"];
}


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.name = [decoder decodeObjectForKey: @"name"]; 
        self.avatar_url = [decoder decodeObjectForKey: @"avatar_url"]; 
        self.authentication_token = [decoder decodeObjectForKey: @"authentication_token"]; 
        self.email = [decoder decodeObjectForKey: @"email"]; 
        self.user_id = [decoder decodeIntForKey:@"user_id"];
        self.islogin = [decoder decodeBoolForKey:@"islogin"];
        self.password = [decoder decodeObjectForKey:@"password"];
    }
    return self;
}


-(NSString*)description
{
    return [NSString stringWithFormat:@"name: %@, avata: %@, authen: %@, email: %@, userid: %d", name, avatar_url, authentication_token, email, user_id];
}

-(void)dealloc
{
    self.password = nil;
    self.name = nil;
    self.avatar_url = nil;
    self.authentication_token = nil;
    self.email = nil;
    [super dealloc];
}

@end
