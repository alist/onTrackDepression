//
//  EXQIDSSubmission.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/5/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSSubmission.h"


@implementation EXQIDSSubmission

@dynamic dateLastEdited;
@dynamic isCompleted;
@dynamic officialDate;
@dynamic note;
@dynamic q0;
@dynamic q1;
@dynamic q2;
@dynamic q3;
@dynamic q4;
@dynamic q5;
@dynamic q6;
@dynamic q7;
@dynamic q8;
@dynamic q9;
@dynamic q10;
@dynamic q11;
@dynamic q12;
@dynamic q13;
@dynamic q14;
@dynamic q15;
@dynamic author;
@dynamic qidsValue;
@dynamic qidsSeverity;
@dynamic wasMissed;


-(void) setQuestionResponse:(NSNumber*)response forQuesitonNumber:(NSInteger)questionNumber{
	[self setValue:response forKey:[NSString stringWithFormat:@"Q%i",questionNumber]];
}
-(NSNumber*) questionResponseForQuesitonNumber:(NSInteger)questionNumber{
	return [self valueForKey:[NSString stringWithFormat:@"Q%i",questionNumber]];
}


-(void)awakeFromInsert{
	[super awakeFromInsert];
	
	[self setIsCompleted:@(FALSE)];
	[self setDateLastEdited:[NSDate date]];
}

@end
