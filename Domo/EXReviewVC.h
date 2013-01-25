//
//  EXAnalyzeVC.h
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTabVC.h"
#import "EXQIDSChart.h"
#import "EXQIDSChartDatasource.h"
#import "EXQIDSSubmission.h"

@interface EXReviewVC : EXTabVC <EXQIDSChartDelegate>
@property (nonatomic, retain) EXQIDSChart *qidsChart;
@property (nonatomic, strong) EXQIDSSubmission * activeQIDSSubmission;
@property (nonatomic, assign) BOOL dataNeedsRefresh;

@end
