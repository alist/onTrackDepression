//
//  EXQIDSManager.h
//  Feel Better: Depression
//
//  Created by Alexander List on 1/5/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXQIDSSubmission.h"
#import "EXAuthor.h"

//posts notificaiton with objectID of EXQIDSSubmission as notification object
static NSString * const newQIDSSubmittedNotification = @"newQIDSSubmittedNotification";

@interface EXQIDSManager : NSObject

@property (nonatomic, strong) NSArray *		questions;
@property (nonatomic, strong) NSString *	version;
@property (nonatomic, strong) NSString *	title;
@property (nonatomic, strong) NSString *	prompt;
@property (nonatomic, strong) NSNumber*		formSpacingInterval;

-(id) init;
-(void) loadFormData; //from file

//when one is incomplete before next one is available for completion
//or when one is available for completion
-(EXQIDSSubmission*) qidsSubmissionForAuthor:(EXAuthor*)author;

//		Enter the highest score on any 1 of the 4 sleep items (items 0 thru 3).
//		Enter the highest score on any 1 of the 4 weight items (items 5 thru 8).
//		Enter the highest score on either of the 2 psychomotor items (14 thru 15).
//		There will be one score for each of the nine MDD symptom domains.
-(BOOL) submitQIDSAsComplete:(EXQIDSSubmission*)submission;

@end
