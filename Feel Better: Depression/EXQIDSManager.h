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

@interface EXQIDSManager : NSObject

@property (nonatomic, strong) NSArray *	 questions;
@property (nonatomic, strong) NSString * version;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * prompt;
@property (nonatomic, strong) NSManagedObjectContext * objectContext;

-(id) initWithManagedObjectContext:(NSManagedObjectContext*)context;
-(void) loadFormData; //from file

//when one is incomplete before next one is available for completion
//or when one is available for completion
-(BOOL) QIDSSubmissionsAvailableForAuthor:(EXAuthor*)author;
-(BOOL) QIDSSubmissionForAuthor:(EXAuthor*)author;

@end
