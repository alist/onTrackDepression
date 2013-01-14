//
//  EXAuthor.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXAuthor.h"
#import "EXQIDSSubmission.h"
#import "EXAppDelegate.h"

@implementation EXAuthor
@dynamic accessToken;
@dynamic authorID;
@dynamic displayName;
@dynamic firstQIDSDate;
@dynamic isOnboarding;
@dynamic lastQIDSDate;
@dynamic qidsSpacingInterval;
@dynamic qidsSubmissions;



+(EXAuthor*) authorForLocalUser{
	return [(EXAppDelegate*)[[UIApplication sharedApplication] delegate] authorForCurrentUser];
}
@end
