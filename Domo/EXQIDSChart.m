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

@implementation EXQIDSChart{
	EskPlotTheme *defaultTheme;
}
@synthesize datasource,delegate;
@synthesize linePlot;
@synthesize displayedDataStartDate, displayedDataTimeLength;
@synthesize displayedSeries, seriesOptions = _seriesOptions;

-(id) initWithFrame:(CGRect)frame {
	if (self= [super initWithFrame:frame]){
		self.datasource = [[EXQIDSChartDatasource alloc] init];
		
		defaultTheme = [[EskPlotTheme alloc] init];
		
		
		NSInteger weekRange = (int) ceil([self.datasource secondsSinceFirstQIDSSubmission] * -1 /(7 * 24 * 60 * 60)) +1;

		self.displayedWeekRange = NSMakeRange(0, weekRange);
		
		self.displayedSeries = [@[@(0)] mutableCopy];
		self.linePlot = [[EskLinePlot alloc] initWithDelegate:self];
		
		[linePlot renderInLayer:self withTheme:defaultTheme];
		
	}
	return self;
}

-(void) reloadData{
	
	
	
	[self.linePlot reloadData];

	//reload plot
	CPTGraphHostingView * plotView = self;
	[UIView animateWithDuration:.1 animations:^{
		plotView.alpha = .5;
	} completion:^(BOOL finished) {
		if (finished){
			[linePlot renderInLayer:plotView withTheme:defaultTheme];
		}
		[UIView animateWithDuration:.3 animations:^{
			plotView.alpha = 1;
		}];
	}];
}


-(NSArray*) seriesOptions{
	if ( _seriesOptions == nil){
		NSMutableArray * options = [NSMutableArray array];
		[options addObject:@{@"title":NSLocalizedString(@"QIDS Score", @"series options selection"), @"objkey":@"qidsValue", @"color": [UIColor colorWithRed:0.22f green:0.55f blue:0.71f alpha:1.0f]}];
		[options addObject:@{@"title":NSLocalizedString(@"concentration", @"series options selection"), @"objkey":@"q9", @"color": [UIColor colorWithRed:.2 green:0 blue:.5 alpha:.7], @"stacks":@(YES)}];
		[options addObject:@{@"title":NSLocalizedString(@"energy level", @"series options selection"), @"objkey":@"q13", @"color": [UIColor colorWithRed:0 green:.7 blue:.1 alpha:.7], @"stacks":@(YES)}];
		[options addObject:@{@"title":NSLocalizedString(@"general interest", @"series options selection"), @"objkey":@"q12", @"color": [UIColor colorWithRed:.8 green:0 blue:.1 alpha:.7], @"stacks":@(YES)}];
		_seriesOptions = options;
	}
	return _seriesOptions;
}

-(NSNumber*) stackedValueForSubmission:(EXQIDSSubmission*)submission forSeriesNumber:(NSNumber*)seriesNum{
	NSDictionary * options = [self.seriesOptions objectAtIndex:[seriesNum intValue]];
	double cumulative = [[submission valueForKey:[options valueForKey:@"objkey"]] doubleValue];
	if ([[options valueForKey:@"stacks"] boolValue] == YES){
		for (NSNumber * otherSeries in self.displayedSeries){
			if ([otherSeries isEqualToNumber:seriesNum] == FALSE && [otherSeries intValue] > [seriesNum intValue]){
				NSDictionary * otherSeriesOptions = [self.seriesOptions objectAtIndex:[otherSeries intValue]];
				if ([[otherSeriesOptions valueForKey:@"stacks"] boolValue] == YES){
					cumulative += [[submission valueForKey:[otherSeriesOptions valueForKey:@"objkey"]] doubleValue];
				}
			}
		}
	}
	return @(cumulative);
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
	
	NSArray * qidsSubmissions = [datasource QIDSSubmissionsBetweenOlderDate:self.displayedDataStartDate newerDate:[self.displayedDataStartDate dateByAddingTimeInterval:self.displayedDataTimeLength]];
	NSMutableArray * submissionValueArray = [NSMutableArray array];
	
//	NSNumber * (^extractValueBlock)(EXQIDSSubmission * a) = nil;
//	NSString* dataKeypath = [[[self seriesOptions] objectAtIndex:[dataSeries intValue]] valueForKey:@"objkey"];
//	if (dataKeypath){
//		extractValueBlock = ^NSNumber * (EXQIDSSubmission * a){
//			return [a valueForKey:dataKeypath];
//		};
//	}
	
	for (EXQIDSSubmission * qids in qidsSubmissions){
		double weeksPast = [[qids completionDate] timeIntervalSinceNow] * -1 * 1.0/(60*60*24*7);
		
		NSNumber * scaledValue = [self stackedValueForSubmission:qids forSeriesNumber:dataSeries];
		
		[submissionValueArray addObject:@{@"value" : scaledValue, @"weekspast": @(weeksPast)}];
	}
	
	return submissionValueArray;
}

-(UIColor*) colorFordisplayedSeriesNumber:(NSNumber*)seriesNum forPlot:(EskLinePlot*)plot{
	NSDictionary* options =  [self.seriesOptions objectAtIndex:seriesNum.intValue];
	return [options valueForKey:@"color"];
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
	[self reloadData];
}

-(NSRange) weekRangeForPlot:(EskLinePlot*)plot{
	return self.displayedWeekRange;
}


@end
