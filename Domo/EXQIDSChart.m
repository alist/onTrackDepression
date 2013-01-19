//
//  EXQIDSChart.m
//  Domo Depression
//
//  Created by Alexander List on 1/16/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSChart.h"
#import "EXQIDSManager.h"

@implementation EXQIDSChart
@synthesize datasource,delegate;
@synthesize linePlot;

-(id) initWithFrame:(CGRect)frame {
	if (self= [super initWithFrame:frame]){
		self.datasource = [[EXQIDSChartDatasource alloc] init];
		
		EskPlotTheme *defaultTheme = [[EskPlotTheme alloc] init];
		self.linePlot = [[EskLinePlot alloc] initWithDelegate:self];
		[linePlot renderInLayer:self withTheme:defaultTheme];
	}
	return self;
}


#pragma mark - EskLinePlotDelegate

- (void)linePlot:(EskLinePlot *)plot indexLocation:(NSUInteger)index{
	[[self delegate] qidsChart:self didSelectQIDSSubmission:[[[EXQIDSManager alloc]init] lastCompletedQIDSSubmissionForAuthor:[EXAuthor authorForLocalUser]]];
}

-(NSArray*) dataForSeries:(NSNumber*)dataSeries forPlot:(EskLinePlot*)plot{
	if ([dataSeries intValue] == 0){
        return [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:24],
                                                      [NSNumber numberWithInt:20],
                                                      [NSNumber numberWithInt:15],
                                                      [NSNumber numberWithInt:19],
                                                      [NSNumber numberWithInt:13],
                                                      [NSNumber numberWithInt:10],
                                                      [NSNumber numberWithInt:3], nil];
        

	}	
	return nil;
}

//returns integer NSNumber array of displayed data series
-(NSArray*) displayedSeriesForPlot:(EskLinePlot*)plot{
	return @[@(0)];
}

@end
