//
//  EXQIDSManager.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/5/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSManager.h"
#import "EXAuthor.h"
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
	EXQIDSSubmission * lastSubmission = [EXQIDSSubmission findFirstWithPredicate:[NSPredicate predicateWithFormat:@"author == %@",author] sortedBy:@"dueDate" ascending:TRUE];
	
	NSInteger submissionInterval = [[lastSubmission dueDate] timeIntervalSinceNow];
	if (submissionInterval > 0){ //offical due in future
		if ([lastSubmission completionDate] == nil){
			return lastSubmission;
		}
	}
	
	//create new one? Yeah, probably!
	EXQIDSSubmission * newSubmission = [EXQIDSSubmission createInContext:[author managedObjectContext]];
	[newSubmission setAuthor:author];
	[newSubmission setDueDate:[NSDate dateWithTimeIntervalSinceNow:author.qidsSpacingInterval.intValue]];
	[[author managedObjectContext] saveOnlySelfWithCompletion:nil];
	
	return newSubmission;
}

-(BOOL) submitQIDSAsComplete:(EXQIDSSubmission*)submission{
	int sleepQualityScore = 0;
	int weightMaintenanceScore = 0;
	int psychomotorScore = 0;
	int totalScore = 0;
	double severityIndex = 0;
	
	for (int qIt = 0; qIt < [self.questions count]; qIt++){
		NSNumber * score = [submission questionResponseForQuesitonNumber:qIt];
		if (score == nil)
			return FALSE;
		
		if (qIt < 4){
			sleepQualityScore = MAX(sleepQualityScore, [score intValue]);
		}else if (qIt < 5){
			totalScore += [score intValue];
		}else if (qIt < 8){
			weightMaintenanceScore = MAX(sleepQualityScore, [score intValue]);
		}else if (qIt < 14){
			totalScore += [score intValue];
		}else if (qIt < 16){
			psychomotorScore = MAX(sleepQualityScore, [score intValue]);
		}else{
			NSLog(@"Whoops-- did we add questions? %i",qIt);
		}
	}
	totalScore += sleepQualityScore + weightMaintenanceScore + psychomotorScore;
	
	severityIndex = (double)totalScore/ 6.75; //to normalize < 5
	
	NSDate * date = [NSDate date];
	[submission setCompletionDate:date];
	[submission setQidsSeverity:@(severityIndex)];
	[submission setQidsValue:@(totalScore)];
	
	if ([[submission author] firstQIDSDate] == nil){
		[[submission author] setFirstQIDSDate:date];
	}
	[[submission author] setLastQIDSDate:date];
	
	[[submission managedObjectContext] saveOnlySelfWithCompletion:nil];
	
	return TRUE;
}

@end
