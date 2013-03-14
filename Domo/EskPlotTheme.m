//
//  EskPlotTheme.m
//  CorePlotSample
//
//  Created by Ken Wong on 8/7/11.
//  Copyright 2011 Essence Work LLC. All rights reserved.
//

#import "EskPlotTheme.h"

@implementation EskPlotTheme

+(NSString *)defaultName 
{
	return @"EskBlogSampleTheme";
}

//-(void)applyThemeToBackground:(CPTGraph *)graph;

-(void)applyThemeToAxisSet:(CPTXYAxisSet *)axisSet 
{
	CPTColor * offBlack = [CPTColor blackColor];
	
    CPTMutableTextStyle *titleText = [CPTMutableTextStyle textStyle];
    titleText.color = [CPTColor blackColor];
    titleText.fontSize = 18;
    titleText.fontName = @"Times New Roman";
    
    CPTMutableLineStyle *majorLineStyle = [CPTMutableLineStyle lineStyle];
    majorLineStyle.lineCap = kCGLineCapRound;
    majorLineStyle.lineColor = offBlack;
    majorLineStyle.lineWidth = 1.0;
    
    CPTMutableLineStyle *minorLineStyle = [CPTMutableLineStyle lineStyle];
    minorLineStyle.lineColor = offBlack;
    minorLineStyle.lineWidth = 3.0;
    
    CPTMutableLineStyle *majorTickLineStyle = [CPTMutableLineStyle lineStyle];
    majorTickLineStyle.lineWidth = 1.0f;
    majorTickLineStyle.lineColor = offBlack;
    
    CPTMutableLineStyle *minorTickLineStyle = [CPTMutableLineStyle lineStyle];
    minorTickLineStyle.lineWidth = 0.0f;
    minorTickLineStyle.lineColor = offBlack;
    
    // Create grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1.0f;
    majorGridLineStyle.lineColor = [offBlack colorWithAlphaComponent:0.25];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 1.0f;
    minorGridLineStyle.lineColor = [offBlack colorWithAlphaComponent:0.15];    
    //minorGridLineStyle.dashPattern = [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:5.0f], nil];
    
	
    CPTMutableTextStyle *xLabelTextStyle = [CPTMutableTextStyle textStyle];
    xLabelTextStyle.color = offBlack;
    xLabelTextStyle.fontSize = 16;
    xLabelTextStyle.fontName = @"Times New Roman";
    
    CPTMutableTextStyle *yLabelTextStyle = [CPTMutableTextStyle textStyle];
    yLabelTextStyle.color = offBlack;
    yLabelTextStyle.fontSize = 16;
    yLabelTextStyle.fontName = @"Times New Roman";
    
    CPTXYAxis *x = axisSet.xAxis;
	CPTMutableTextStyle *whiteTextStyle = [[CPTMutableTextStyle alloc] init];
	whiteTextStyle.color = offBlack;
	whiteTextStyle.fontSize = 14.0;
	CPTMutableTextStyle *minorTickWhiteTextStyle = [[CPTMutableTextStyle alloc] init] ;
	minorTickWhiteTextStyle.color = [CPTColor blackColor];
	minorTickWhiteTextStyle.fontSize = 12.0;
	
    x.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    x.majorIntervalLength = CPTDecimalFromDouble(0.5);
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
	x.tickDirection = CPTSignNone;
    x.minorTicksPerInterval = 4;
    x.majorTickLineStyle = majorTickLineStyle;
    x.minorTickLineStyle = minorTickLineStyle;
    x.axisLineStyle = majorLineStyle;
    x.majorTickLength = 7.0;
    x.minorTickLength = 5.0;
	x.labelTextStyle = xLabelTextStyle; 
	x.minorTickLabelTextStyle = whiteTextStyle; 
	x.titleTextStyle = titleText;
	
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    y.majorIntervalLength = CPTDecimalFromDouble(0.5);
    y.minorTicksPerInterval = 4;
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
	y.tickDirection = CPTSignNone;
    y.majorTickLineStyle = majorTickLineStyle;
    y.minorTickLineStyle = minorTickLineStyle;
    y.axisLineStyle = majorLineStyle;
    y.majorTickLength = 15.0;
    y.minorTickLength = 5.0;
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
	y.labelTextStyle = yLabelTextStyle;
	y.minorTickLabelTextStyle = minorTickWhiteTextStyle; 
	y.titleTextStyle = titleText;
    y.titleOffset = 58.0f;
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencyFormatter setGroupingSeparator:@","];
    [currencyFormatter setGroupingSize:3];
    [currencyFormatter setMaximumFractionDigits:0];

    y.labelFormatter = currencyFormatter;
    
}


@end
