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

@protocol EskLinePlotDelegate;

//this plot overlays multiple line plots

@interface EskLinePlot : NSObject <CPTPlotSpaceDelegate, CPTPlotDataSource, CPTScatterPlotDelegate>
{
  @private
    CPTGraph *graph;
    CPTScatterPlot *linePlot;
    CPTScatterPlot *touchPlot;
    NSUInteger selectedCoordination;
    BOOL touchPlotSelected;
}

@property (nonatomic, strong) id<EskLinePlotDelegate> delegate;
@property (nonatomic, strong) NSArray *	displayedWeeks;

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


// Delegate to notify the view controller that the location of the line has changed.
@protocol EskLinePlotDelegate <NSObject> 

- (void)linePlot:(EskLinePlot *)plot indexLocation:(NSUInteger)index;

//array of tuples
//BUT
//V1 has simple array of NSNumbers
//dataSeries is integer representing which chart is displayed
-(NSArray*) dataForSeries:(NSNumber*)dataSeries forPlot:(EskLinePlot*)plot;

//returns integer NSNumber array of displayed data series
-(NSArray*) displayedSeriesForPlot:(EskLinePlot*)plot;

@end
