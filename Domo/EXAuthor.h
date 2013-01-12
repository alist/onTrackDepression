//
//  EXAuthor.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EXQIDSSubmission;

@interface EXAuthor : NSManagedObject

@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSString * authorID;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSDate * firstQIDSDate;
@property (nonatomic, retain) NSNumber * isOnboarding;
@property (nonatomic, retain) NSDate * lastQIDSDate;
@property (nonatomic, retain) NSDate * nextQIDSDate;
@property (nonatomic, retain) NSNumber * qidsSpacingInterval;
@property (nonatomic, retain) NSSet *qidsSubmissions;

+(EXAuthor*) authorForLocalUser;
@end

@interface EXAuthor (CoreDataGeneratedAccessors)

- (void)addQidsSubmissionsObject:(EXQIDSSubmission *)value;
- (void)removeQidsSubmissionsObject:(EXQIDSSubmission *)value;
- (void)addQidsSubmissions:(NSSet *)values;
- (void)removeQidsSubmissions:(NSSet *)values;

@end
