//
//  EXQIDSChart.h
//  Domo Depression
//
//  Created by Alexander List on 1/16/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXQIDSChartDatasource.h"
#import "CorePlot-CocoaTouch.h"
#import "EskLinePlot.h"
#import "EskPlotTheme.h"

@class EXQIDSChart, EXQIDSSubmission;

@protocol EXQIDSChartDelegate <NSObject>
-(void) qidsChart:(EXQIDSChart*)chart didSelectQIDSSubmission:(EXQIDSSubmission*)submission;

-(void) reloadSeriesDisplayFromQIDSChart:(EXQIDSChart*)chart;

@end

@interface EXQIDSChart : CPTGraphHostingView <EskLinePlotDelegate>
-(id) initWithFrame:(CGRect)frame;

-(void) reloadData;

@property (nonatomic, retain) EXQIDSChartDatasource * datasource;
@property (nonatomic, weak) id<EXQIDSChartDelegate> delegate;
@property (nonatomic, strong) NSDate * displayedDataStartDate;
@property (nonatomic, assign) NSTimeInterval displayedDataTimeLength; //in seconds


//nsarray of prioritized series ID NSNumbers
@property (nonatomic, strong) NSMutableArray *	displayedSeries;

//array of {title: (localized)NSString, objKey: NSString, color: UIColor}
@property(nonatomic, strong) NSArray *	seriesOptions;

///eventually we'll have an entrie line plot array or dictionary to house all the plots, and the plot will be colored if just one, and grey if there are overlayed plots
@property (nonatomic, retain) EskLinePlot * linePlot;

//will place in order of seriesOptions array to have appropiate layout
-(void) toggleSeriesDisplay:(NSUInteger)series;
@end
