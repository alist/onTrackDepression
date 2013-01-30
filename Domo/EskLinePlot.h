//
//  EskLinePlot.h
//  Display the line chart that allow user select the plot symbol on the line
//  and slide left or right and the chart will display the value while the user
//  is moving the line along the chart.
//
//  Created by Ken Wong on 8/9/11.
//  Copyright 2011 Essence Work LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "EXQIDSSubmission.h"

@class EskLinePlot;

// Delegate to notify the view controller that the location of the line has changed.
@protocol EskLinePlotDelegate <NSObject>

- (void)linePlot:(EskLinePlot *)plot indexLocation:(NSUInteger)index;

//array of tuples
-(NSArray*) dataForSeries:(NSNumber*)dataSeries forPlot:(EskLinePlot*)plot forWeekRange:(NSRange)weekRange;

//returns integer NSNumber array of displayed data series
-(NSArray*) displayedSeriesForPlot:(EskLinePlot*)plot;

-(UIColor*) colorFordisplayedSeriesNumber:(NSNumber*)seriesNum forPlot:(EskLinePlot*)plot;

@end


//this plot overlays multiple line plots

@interface EskLinePlot : NSObject <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate>
{
  @private
    CPTGraph *graph;
	
	// array of	CPTScatterPlot *
	
		
}

@property (nonatomic, strong) id<EskLinePlotDelegate> delegate;

@property (nonatomic, strong)	NSArray * seriesScatterPlots;

//loc = weeks in past; len = additional weeks in past starting at loc
@property (nonatomic, assign) NSRange	displayedWeekRange;

//{series <NSNumber>: array[datapoints for series]} each datapoint array elements of 2 element array--> containing[0]-> the timestamp for datapoint in days past, [1]-> y value for that point in the series
@property (nonatomic, strong) NSMutableDictionary * displayedDataBySeries;

//integers of data-series in the order of display, where series 0 = total value, and should appear at index 0
@property (nonatomic, strong) NSArray * displayedDataSeries;

//will reload displayed series of stacking charts
-(void) reloadData;

// Render the chart on the hosting view from the view controller with the default theme.
- (void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme;

//delegate required
- (id)initWithDelegate:(id<EskLinePlotDelegate>)theDelegate;

@end

