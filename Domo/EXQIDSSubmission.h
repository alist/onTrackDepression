//
//  EXQIDSSubmission.h
//  Feel Better: Depression
//
//  Created by Alexander List on 1/5/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EXAuthor.h"

@interface EXQIDSSubmission : NSManagedObject

@property (nonatomic, retain) NSDate * completionDate;
@property (nonatomic, retain) NSDate * dateLastEdited;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * q0;
@property (nonatomic, retain) NSString * q1;
@property (nonatomic, retain) NSString * q2;
@property (nonatomic, retain) NSString * q3;
@property (nonatomic, retain) NSString * q4;
@property (nonatomic, retain) NSString * q5;
@property (nonatomic, retain) NSString * q6;
@property (nonatomic, retain) NSString * q7;
@property (nonatomic, retain) NSString * q8;
@property (nonatomic, retain) NSString * q9;
@property (nonatomic, retain) NSString * q10;
@property (nonatomic, retain) NSString * q11;
@property (nonatomic, retain) NSString * q12;
@property (nonatomic, retain) NSString * q13;
@property (nonatomic, retain) NSString * q14;
@property (nonatomic, retain) NSString * q15;
@property (nonatomic, retain) NSNumber * qidsSeverity;
@property (nonatomic, retain) NSNumber * qidsValue;
@property (nonatomic, retain) NSNumber * wasMissed;



@property (nonatomic, retain) EXAuthor *author;

-(void) setQuestionResponse:(NSString*)response forQuesitonNumber:(NSInteger)questionNumber;
-(NSString*) questionResponseForQuesitonNumber:(NSInteger)questionNumber;

-(BOOL) isComplete;


@end
