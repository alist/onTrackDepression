//
//  EXQIDSSubmission.h
//  Feel Better: Depression
//
//  Created by Alexander List on 1/5/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EXQIDSSubmission : NSManagedObject

@property (nonatomic, retain) NSDate * dateLastEdited;
@property (nonatomic, retain) NSDate * officialDate;
@property (nonatomic, retain) NSNumber * isCompleted;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * q0;
@property (nonatomic, retain) NSNumber * q1;
@property (nonatomic, retain) NSNumber * q2;
@property (nonatomic, retain) NSNumber * q3;
@property (nonatomic, retain) NSNumber * q4;
@property (nonatomic, retain) NSNumber * q5;
@property (nonatomic, retain) NSNumber * q6;
@property (nonatomic, retain) NSNumber * q7;
@property (nonatomic, retain) NSNumber * q8;
@property (nonatomic, retain) NSNumber * q9;
@property (nonatomic, retain) NSNumber * q10;
@property (nonatomic, retain) NSNumber * q11;
@property (nonatomic, retain) NSNumber * q12;
@property (nonatomic, retain) NSNumber * q13;
@property (nonatomic, retain) NSNumber * q14;
@property (nonatomic, retain) NSNumber * q15;
@property (nonatomic, retain) NSNumber * qidsSeverity;
@property (nonatomic, retain) NSNumber * qidsValue;
@property (nonatomic, retain) NSNumber * wasMissed;


@property (nonatomic, retain) NSManagedObject *author;

-(void) setQuestionResponse:(NSNumber*)response forQuesitonNumber:(NSInteger)questionNumber;
-(NSNumber*) questionResponseForQuesitonNumber:(NSInteger)questionNumber;

@end
