//
//  EXQIDSChartDatasource.h
//  Domo Depression
//
//  Created by Alexander List on 1/16/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXAuthor.h"
#import "CorePlot-CocoaTouch.h"

@interface EXQIDSChartDatasource : NSObject
@property (nonatomic, strong)EXAuthor * currentAuthor;


//after calling this lastFetchedQIDSSubmissions is set to resultant
-(NSArray*) QIDSSubmissionsToDisplayBetweenOlderDate:(NSDate*)olderDate newerDate:(NSDate*)newerDate;

-(NSTimeInterval) secondsSinceFirstQIDSSubmission;

-(EXQIDSSubmission*)displayedQIDSSubmissionAtIndex:(NSInteger) displayIndex;

@property (nonatomic, strong) NSArray* lastFetchedQIDSSubmissions;
@end
