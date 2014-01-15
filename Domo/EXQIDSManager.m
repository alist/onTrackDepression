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


#define EXQIDSManager_Generated_QIDS_Count 100
#define EXQIDSManager_Generated_QIDS_Time_Spacing 18*60*60

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
	/* old version commented out Jan 2014 by aho
     
     NSDictionary *QIDSData = [[NSDictionary alloc]
							 initWithContentsOfFile:
							 [[NSBundle mainBundle] pathForResource:@"QIDS" ofType:@"plist"]];
     */
    
    NSDictionary *QIDSData = [[NSDictionary alloc]
                              initWithContentsOfFile:
                              [[NSBundle mainBundle] pathForResource:@"QIDS_form" ofType:@"plist"]];
	
	self.questions = [QIDSData valueForKey:@"questions"];
    self.itemtypes = [QIDSData valueForKey:@"itemtypes"]; // added by aho 2014
	self.version = [QIDSData valueForKey:@"version"];
	self.title = [QIDSData valueForKey:@"title"];
	self.prompt = [QIDSData valueForKey:@"prompt"];
	self.formSpacingInterval = [QIDSData valueForKey:@"formSpacingInterval"];
	self.completionSubmissionPrompt = [QIDSData valueForKey:@"completionSubmissionPrompt"];
	
}
-(EXQIDSSubmission*) qidsSubmissionForAuthor:(EXAuthor*)author{
	EXQIDSSubmission * lastSubmission = [EXQIDSSubmission findFirstWithPredicate:[NSPredicate predicateWithFormat:@"author == %@",author] sortedBy:@"dueDate" ascending:FALSE];
	
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
	
	BOOL complete = [self processQIDSSubmissionForComplete:submission];
	if (!complete)
		return FALSE;
	
	NSDate * date = [NSDate date];

	[submission setCompletionDate:date];

	if ([[submission author] firstQIDSDate] == nil){
		[[submission author] setFirstQIDSDate:date];
	}
	[[submission author] setLastQIDSDate:date];
	
	[[submission managedObjectContext] saveOnlySelfWithCompletion:nil];
	
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:newQIDSSubmittedNotification object:[submission objectID]]];
	
	return TRUE;
}

-(BOOL)processQIDSSubmissionForComplete:(EXQIDSSubmission*)submission{
	int sleepQualityScore = 0;
	int weightMaintenanceScore = 0;
	int psychomotorScore = 0;
	int totalScore = 0;
	double severityIndex = 0;
	
    // QIDS scoring
	for (int qIt = 0; qIt < [self.questions count]; qIt++){
		NSNumber * score;
        score = [[NSNumber alloc] initWithInt:[[submission questionResponseForQuesitonNumber:qIt] intValue]];
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
	
	severityIndex = (double)totalScore/ 5.5; //to normalize < 5
	
	[submission setQidsSeverity:@(severityIndex)];
	[submission setQidsValue:@(totalScore)];

	return TRUE;
}


-(EXQIDSSubmission*) lastCompletedQIDSSubmissionForAuthor:(EXAuthor*)author{
	EXQIDSSubmission * lastSubmission = [EXQIDSSubmission findFirstWithPredicate:[NSPredicate predicateWithFormat:@"author == %@ AND completionDate != nil",author] sortedBy:@"dueDate" ascending:FALSE];
	
	return lastSubmission;

}

-(void) generateDataSetForAuthor:(EXAuthor*)author{

	for (int i= 0; i< EXQIDSManager_Generated_QIDS_Count; i++) {
		EXQIDSSubmission * newSubmission = [EXQIDSSubmission createInContext:[author managedObjectContext]];
		[newSubmission setAuthor:author];
		for (NSInteger q = 0; q < self.questions.count; q++){
			NSString* response = [[NSString alloc] initWithFormat:@"%i", arc4random()%4];
			[newSubmission setQuestionResponse:response forQuesitonNumber:q];
		}
		[self processQIDSSubmissionForComplete:newSubmission];
		
		double timeInterval = (double)(EXQIDSManager_Generated_QIDS_Time_Spacing * -1 * i);
		NSDate * qidsDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
		[newSubmission setDueDate:qidsDate];
		[newSubmission setCompletionDate:qidsDate];
		
		//gen random text
		NSArray const * randomStrings = @[@"",@"This is a short feedback.",@"rend.", @"This feedback gets a pretty long vibe to it when you really check it out-- it's pretty nice. But I like it too!",@"Here\n is a test of \n newlines"];
		NSInteger feedbackInt = arc4random()%[randomStrings count];
		[newSubmission setNote:[randomStrings objectAtIndex:feedbackInt]];
		
	}
	[[author managedObjectContext] saveOnlySelfWithCompletion:nil];
	
}

@end
