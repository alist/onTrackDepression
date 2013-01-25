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
@end

@interface EXQIDSChart : CPTGraphHostingView <EskLinePlotDelegate>
-(id) initWithFrame:(CGRect)frame;

-(void) reloadData;

@property (nonatomic, retain) EXQIDSChartDatasource * datasource;
@property (nonatomic, weak) id<EXQIDSChartDelegate> delegate;
@property (nonatomic, strong) NSDate * displayedDataStartDate;
@property (nonatomic, assign) NSTimeInterval displayedDataTimeLength; //in seconds


///eventually we'll have an entrie line plot array or dictionary to house all the plots, and the plot will be colored if just one, and grey if there are overlayed plots
@property (nonatomic, retain) EskLinePlot * linePlot;
@end
