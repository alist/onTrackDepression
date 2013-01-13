//
//  EXQIDSManager.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/5/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSManager.h"
#import <RestKit/RestKit.h>

@interface EXQIDSManager ()

@end

@implementation EXQIDSManager
@synthesize questions, version,title, prompt;

-(id) init{
	if (self=[super init]){
		
		[self loadFormData];
	}
	return self;
}

-(void) loadFormData{
	NSDictionary *QIDSData = [[NSDictionary alloc]
							 initWithContentsOfFile:
							 [[NSBundle mainBundle] pathForResource:@"QIDS" ofType:@"plist"]];
	
	self.questions = [QIDSData valueForKey:@"questions"];
	self.version = [QIDSData valueForKey:@"version"];
	self.title = [QIDSData valueForKey:@"title"];
	self.prompt = [QIDSData valueForKey:@"prompt"];
	self.formSpacingInterval = [QIDSData valueForKey:@"formSpacingInterval"];
	
}
-(EXQIDSSubmission*) qidsSubmissionForAuthor:(EXAuthor*)author{
	EXQIDSSubmission * lastSubmission = [EXQIDSSubmission findFirstWithPredicate:[NSPredicate predicateWithFormat:@"author == %@",author] sortedBy:@"officialDate" ascending:TRUE];
	
	NSInteger submissionInterval = [[lastSubmission officialDate] timeIntervalSinceNow];
	if (submissionInterval > 0){ //offical due in future
		if ([[lastSubmission isCompleted] boolValue] == FALSE){
			return lastSubmission;
		}else{
			return nil;
		}
	}else{
		//create new one? Yeah, probably!
		EXQIDSSubmission * newSubmission = [EXQIDSSubmission createInContext:[author managedObjectContext]];
		[newSubmission setAuthor:author];
		if (-1*submissionInterval > author.qidsSpacingInterval.intValue || [lastSubmission officialDate] == nil){ //-1*timeCompletedInPast > spaceBTW submissions
			//we're gonna add today's date + the interval
			[newSubmission setOfficialDate:[NSDate dateWithTimeIntervalSinceNow:author.qidsSpacingInterval.intValue]];
		}else{
			//otherwise we're gonna add the interval from the last QIDS taken
			[newSubmission setOfficialDate:[lastSubmission.officialDate dateByAddingTimeInterval:author.qidsSpacingInterval.intValue]];
		}
		[[author managedObjectContext] saveOnlySelfWithCompletion:nil];
		return newSubmission;
	}
}

@end
