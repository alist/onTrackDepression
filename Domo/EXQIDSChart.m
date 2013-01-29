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
@synthesize displayedSeries, seriesOptions = _seriesOptions;

-(id) initWithFrame:(CGRect)frame {
	if (self= [super initWithFrame:frame]){
		self.datasource = [[EXQIDSChartDatasource alloc] init];
		
		EskPlotTheme *defaultTheme = [[EskPlotTheme alloc] init];
		
		self.displayedSeries = [@[@(0)] mutableCopy];
		self.linePlot = [[EskLinePlot alloc] initWithDelegate:self];
		[self.linePlot setDisplayedWeekRange:NSMakeRange(0, 7)];
		
		[linePlot renderInLayer:self withTheme:defaultTheme];
		
	}
	return self;
}

-(void) reloadData{
	
	[self.linePlot reloadData];
}


-(NSArray*) seriesOptions{
	if ( _seriesOptions == nil){
		NSMutableArray * options = [NSMutableArray array];
		[options addObject:@{@"title":NSLocalizedString(@"QIDS Score", @"series options selection"), @"objkey":@"qidsValue", @"color": [UIColor colorWithRed:0.22f green:0.55f blue:0.71f alpha:1.0f]}];
		[options addObject:@{@"title":NSLocalizedString(@"severity", @"series options selection"), @"objkey":@"qidsSeverity", @"color": [UIColor colorWithRed:.2 green:0 blue:.5 alpha:.7]}];
		[options addObject:@{@"title":NSLocalizedString(@"waking up", @"series options selection"), @"objkey":@"q1", @"color": [UIColor colorWithRed:0 green:.7 blue:.1 alpha:.7]}];
		_seriesOptions = options;
	}
	return _seriesOptions;
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
	return self.displayedSeries;
}

-(void) toggleSeriesDisplay:(NSUInteger)series{
	NSUInteger displayLoc = [self.displayedSeries indexOfObject:@(series)];
	if (displayLoc == NSNotFound){
		for (int i = 0; i <= [self.displayedSeries count]; i ++){
			
			if ([self.displayedSeries count] == i){
				[self.displayedSeries insertObject:@(series) atIndex:i];
				break;
			}else
			
			if (series < [[self.displayedSeries objectAtIndex:i] intValue]){
				[self.displayedSeries insertObject:@(series) atIndex:i];
				break;
			}
		}
	}else{
		[self.displayedSeries removeObject:@(series)];
	}
	
	[self.delegate reloadSeriesDisplayFromQIDSChart:self];
}


@end
