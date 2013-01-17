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
		self.linePlot = [[EskLinePlot alloc] init];
		[self.linePlot setDelegate:self];
		[linePlot renderInLayer:self withTheme:defaultTheme];
	}
	return self;
}


#pragma mark - EskLinePlotDelegate

- (void)linePlot:(EskLinePlot *)plot indexLocation:(NSUInteger)index{
	[[self delegate] qidsChart:self didSelectQIDSSubmission:[[[EXQIDSManager alloc]init] lastCompletedQIDSSubmissionForAuthor:[EXAuthor authorForLocalUser]]];
}

@end
