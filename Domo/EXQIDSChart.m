//
//  EXQIDSChart.m
//  Domo Depression
//
//  Created by Alexander List on 1/16/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSChart.h"
#import "EXQIDSManager.h"
#import "EXQIDSSubmission.h"

@implementation EXQIDSChart
@synthesize datasource,delegate;
@synthesize linePlot;
@synthesize displayedDataStartDate, displayedDataTimeLength;

-(id) initWithFrame:(CGRect)frame {
	if (self= [super initWithFrame:frame]){
		self.datasource = [[EXQIDSChartDatasource alloc] init];
		
		EskPlotTheme *defaultTheme = [[EskPlotTheme alloc] init];
		self.linePlot = [[EskLinePlot alloc] initWithDelegate:self];
		[self.linePlot setDisplayedWeekRange:NSMakeRange(0, 7)];
		[linePlot renderInLayer:self withTheme:defaultTheme];
		
	}
	return self;
}

-(void) reloadData{
	
	[self.linePlot reloadData];
}

#pragma mark - EskLinePlotDelegate

- (void)linePlot:(EskLinePlot *)plot indexLocation:(NSUInteger)index{
	[[self delegate] qidsChart:self didSelectQIDSSubmission:[[[EXQIDSManager alloc]init] lastCompletedQIDSSubmissionForAuthor:[EXAuthor authorForLocalUser]]];
}

-(NSArray*) dataForSeries:(NSNumber*)dataSeries forPlot:(EskLinePlot*)plot forWeekRange:(NSRange)weekRange{

	double displayedTimeInterval = 60*60*24 * (double)weekRange.length * 7;
	double displayedDataStartInterval = 60*60*24 * 7* (weekRange.length + weekRange.location);
	self.displayedDataStartDate = [NSDate dateWithTimeIntervalSinceNow:(-1*displayedDataStartInterval)];
	self.displayedDataTimeLength = displayedTimeInterval;
	
	if ([dataSeries intValue] == 0){
		
		NSArray * qidsSubmissions = [datasource QIDSSubmissionsBetweenOlderDate:self.displayedDataStartDate newerDate:[self.displayedDataStartDate dateByAddingTimeInterval:self.displayedDataTimeLength]];
		
		
		NSMutableArray * qidsValueArray = [NSMutableArray array];
		
		for (EXQIDSSubmission * qids in qidsSubmissions){
			double weeksPast = [[qids completionDate] timeIntervalSinceNow] * -1 * 1.0/(60*60*24*7);
			
			[qidsValueArray addObject:@{@"value" : [qids qidsValue], @"weekspast": @(weeksPast)}];
		}
		
        return qidsValueArray;
        

	}	
	return nil;
}

//returns integer NSNumber array of displayed data series
-(NSArray*) displayedSeriesForPlot:(EskLinePlot*)plot{
	return @[@(0)];
}

@end
