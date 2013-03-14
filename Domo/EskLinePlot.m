//
//  EskLinePlot.m
//  CorePlotSample
//
//  Created by Ken Wong on 8/9/11.
//  Copyright 2011 Essence Work LLC. All rights reserved.
//

#import "EskLinePlot.h"

//#define kHighPlot @"HighPlot"

@implementation EskLinePlot

@synthesize delegate;
@synthesize displayedDataSeries,displayedDataBySeries;
@synthesize seriesScatterPlots;

- (id)initWithDelegate:(id<EskLinePlotDelegate>)theDelegate
{
    self = [super init];
    if (self) {
		
		self.delegate = theDelegate;		
		[self reloadData];
				
	}
    
    return self;
}

-(void) reloadData{
	self.displayedDataSeries = [delegate displayedSeriesForPlot:self];
	self.displayedDataBySeries = [NSMutableDictionary dictionaryWithCapacity:[self.displayedDataSeries count]];
	
	for (NSNumber * series in self.displayedDataSeries){
		NSArray * seriesData = [delegate dataForSeries:series forPlot:self forWeekRange:[delegate weekRangeForPlot:self]];
		[self.displayedDataBySeries setObject:seriesData forKey:series];
	}
	
}


- (void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme
{    
	@autoreleasepool {
		
		CGRect bounds = layerHostingView.bounds;
		
		// Create the graph and assign the hosting view.
		graph = [[CPTXYGraph alloc] initWithFrame:bounds];
		layerHostingView.hostedGraph = graph;
		[graph applyTheme:theme];
		
		graph.plotAreaFrame.masksToBorder = NO;
		
		// chang the chart layer orders so the axis line is on top of the bar in the chart.
		NSArray *chartLayers = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:CPTGraphLayerTypePlots],
																[NSNumber numberWithInt:CPTGraphLayerTypeMajorGridLines], 
																[NSNumber numberWithInt:CPTGraphLayerTypeMinorGridLines],  
																[NSNumber numberWithInt:CPTGraphLayerTypeAxisLines], 
																[NSNumber numberWithInt:CPTGraphLayerTypeAxisLabels], 
																[NSNumber numberWithInt:CPTGraphLayerTypeAxisTitles], 
																nil];
		graph.topDownLayerOrder = chartLayers;    
		

		// Setup plot space
		CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
		plotSpace.allowsUserInteraction = YES;
		plotSpace.delegate = self;
		plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.1f) length:CPTDecimalFromFloat((float)[delegate weekRangeForPlot:self].length - 1.0f + 0.2f)];//a bit more on right than zero
		plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(30.0f)];

		
		// Setup grid line style
		CPTMutableLineStyle *majorXGridLineStyle = [CPTMutableLineStyle lineStyle];
		majorXGridLineStyle.lineWidth = 1.0f;
		majorXGridLineStyle.lineColor = [[CPTColor grayColor] colorWithAlphaComponent:0.25f];
		
		// Setup x-Axis.
		CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
		CPTXYAxis *x = axisSet.xAxis;
		x.labelingPolicy = CPTAxisLabelingPolicyNone;
		x.majorGridLineStyle = majorXGridLineStyle;
		x.majorIntervalLength = CPTDecimalFromString(@"1");
		x.minorTicksPerInterval = 1;

		x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
//		x.title = @"scores by weeks ago";
		x.timeOffset = 30.0f;
		NSArray *exclusionRanges = [NSArray arrayWithObjects:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(0)], nil];
		x.labelExclusionRanges = exclusionRanges;
		
		// Use custom x-axis label so it will display year 2010, 2011, 2012, ... instead of 1, 2, 3, 4
		NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:[delegate weekRangeForPlot:self].length];
		for (int i = [delegate weekRangeForPlot:self].location; i < [delegate weekRangeForPlot:self].location + [delegate weekRangeForPlot:self].length; i++){
			CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i",i] textStyle:x.labelTextStyle];
			label.tickLocation = CPTDecimalFromInt(i);
			label.offset = 5.0f;
			[labels addObject:label];
		}
		x.axisLabels = [NSSet setWithArray:labels];
		
		// Setup y-Axis.
		CPTMutableLineStyle *majorYGridLineStyle = [CPTMutableLineStyle lineStyle];
		majorYGridLineStyle.lineWidth = 1.0f;
		majorYGridLineStyle.dashPattern =  [NSArray arrayWithObjects:[NSNumber numberWithFloat:5.0f], [NSNumber numberWithFloat:5.0f], nil];
		majorYGridLineStyle.lineColor = [[CPTColor lightGrayColor] colorWithAlphaComponent:0.25];
		
		
		CPTXYAxis *y = axisSet.yAxis;
		y.majorGridLineStyle = majorYGridLineStyle;
		y.majorIntervalLength = CPTDecimalFromString(@"5");
		y.minorTicksPerInterval = 1;
		y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
		y.title = nil;// @"Consumer Spending";
		NSArray *yExlusionRanges = [NSArray arrayWithObjects:
									[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(0.0)],
									nil];
		y.labelExclusionRanges = yExlusionRanges;
		
		NSMutableArray * plots = [NSMutableArray array];
		for (NSNumber * seriesNum in self.displayedDataSeries ){
			CPTScatterPlot *highPlot = [[CPTScatterPlot alloc] init];
			highPlot.identifier = seriesNum;
			
			BOOL greyMode = FALSE;
			
			CPTMutableLineStyle *highLineStyle = [highPlot.dataLineStyle mutableCopy];
			highLineStyle.lineWidth = 2.f;
			//    highLineStyle.interpolation = CPTScatterPlotInterpolationCurved;
			if (greyMode){
				highLineStyle.lineColor = [CPTColor colorWithCGColor:[[UIColor colorWithWhite:.4 alpha:.1] CGColor]];
			}else{
				if ([self.displayedDataSeries indexOfObject:seriesNum]  == 0){ //only line on top layer
					highLineStyle.lineColor = [CPTColor colorWithCGColor:[[[self delegate] colorFordisplayedSeriesNumber:seriesNum forPlot:self] CGColor]];
				}else{
					highLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor.clearColor CGColor]];
//					highLineStyle.lineColor = [CPTColor colorWithCGColor:[[[[self delegate] colorFordisplayedSeriesNumber:seriesNum forPlot:self] colorWithAlphaComponent:.2] CGColor]];

				}
			}
			highPlot.dataLineStyle = highLineStyle;
			
			highPlot.dataSource = self;
			highPlot.delegate = self;
			
			if ([self.displayedDataSeries indexOfObject:seriesNum] == 0){
				highPlot.plotSymbolMarginForHitDetection = 15.0f;
				CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
				plotSymbol.fill               = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[UIColor colorWithWhite:.9 alpha:1] CGColor]]];
				plotSymbol.size               = CGSizeMake(4.0, 4.0);
				highPlot.plotSymbol = plotSymbol;
			}

			
			CPTFill *areaFill = nil;
			
			if (greyMode){
				areaFill = 	[CPTFill fillWithColor:[CPTColor colorWithCGColor:[[UIColor colorWithWhite:.4 alpha:.4] CGColor]]];
			}else{
				//areaFill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.50f green:0.67f blue:0.65f alpha:0.4f]];
				UIColor * color = [[[self delegate] colorFordisplayedSeriesNumber:seriesNum forPlot:self] colorWithAlphaComponent:.4];
				areaFill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[color CGColor]]];

			}
			
			highPlot.areaFill = areaFill;
			highPlot.areaBaseValue = CPTDecimalFromString(@"0");
			[graph addPlot:highPlot];
			[plots addObject:highPlot];
		}
		self.seriesScatterPlots = plots;
    
	}

}

// Assign different color to the touchable line symbol.
- (void)applyTouchPlotColor
{
    CPTColor *touchPlotColor = [CPTColor orangeColor];
    
    CPTMutableLineStyle *savingsPlotLineStyle = [CPTMutableLineStyle lineStyle];
    savingsPlotLineStyle.lineColor = touchPlotColor;
    
    CPTPlotSymbol *touchPlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    touchPlotSymbol.fill = [CPTFill fillWithColor:touchPlotColor];
    touchPlotSymbol.lineStyle = savingsPlotLineStyle;
    touchPlotSymbol.size = CGSizeMake(15.0f, 15.0f); 
    
    
    
    CPTMutableLineStyle *touchLineStyle = [CPTMutableLineStyle lineStyle];
    touchLineStyle.lineColor = [CPTColor orangeColor];
    touchLineStyle.lineWidth = 5.0f;
    
    
}

// Highlight the touch plot when the user holding tap on the line symbol.
- (void)applyHighLightPlotColor:(CPTScatterPlot *)plot
{
    CPTColor *selectedPlotColor = [CPTColor redColor];
    
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = selectedPlotColor;
    
    CPTPlotSymbol *plotSymbol = nil;
    plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:selectedPlotColor];
    plotSymbol.lineStyle = symbolLineStyle;
    plotSymbol.size = CGSizeMake(15.0f, 15.0f); 
    
    plot.plotSymbol = plotSymbol;
    
    CPTMutableLineStyle *selectedLineStyle = [CPTMutableLineStyle lineStyle];
    selectedLineStyle.lineColor = [CPTColor yellowColor];
    selectedLineStyle.lineWidth = 5.0f;
    
    plot.dataLineStyle = selectedLineStyle;
}

#pragma mark - CPPlotSpace Delegate Methods
// This implementation of this method will put the line graph in a fix position so it won't be scrollable.
-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate 
{
    
    if (coordinate == CPTCoordinateY) {
        return ((CPTXYPlotSpace *)space).yRange;
    }
    else
    {
        return ((CPTXYPlotSpace *)space).xRange;
    }
}

// This method is call when user touch & drag on the plot space.
- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(id)event atPoint:(CGPoint)point
{
    // Convert the touch point to plot area frame location
    CGPoint pointInPlotArea = [graph convertPoint:point toLayer:graph.plotAreaFrame];
    
    NSDecimal newPoint[2];
    [graph.defaultPlotSpace plotPoint:newPoint forPlotAreaViewPoint:pointInPlotArea];
    NSDecimalRound(&newPoint[0], &newPoint[0], 0, NSRoundPlain);
    int x = [[NSDecimalNumber decimalNumberWithDecimal:newPoint[0]] intValue];
    
    if (x < 0)
    {
        x = 0;
    }
    else if (x > [[self.displayedDataBySeries objectForKey:[self.displayedDataSeries objectAtIndex:0]] count])
    {
        x = [[self.displayedDataBySeries objectForKey:[self.displayedDataSeries objectAtIndex:0]] count];
    }
    
    
    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(id)event 
          atPoint:(CGPoint)point
{
    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point
{
    // Restore the vertical line plot to its initial color.
    [self applyTouchPlotColor];
    return YES;
}

#pragma mark - 
#pragma mark Scatter plot delegate methods

- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)index
{
//	if ([(NSNumber *)plot.identifier isEqualToNumber:@(0)]){
		if ([delegate respondsToSelector:@selector(linePlot:indexLocation:)])
            [delegate linePlot:self indexLocation:index];
}



#pragma mark -
#pragma mark Plot Data Source Methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot 
{
	NSNumber * plotIdent = (NSNumber*) plot.identifier;
	return [[self.displayedDataBySeries objectForKey:plotIdent] count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
	NSNumber * plotIdent = (NSNumber*) plot.identifier;

    NSNumber *num = nil;
	NSDictionary * recordDict = [[self.displayedDataBySeries objectForKey:plotIdent] objectAtIndex:index];
	if ( fieldEnum == CPTScatterPlotFieldY )
	{
		//autostacked in qidsChart
		num = [recordDict objectForKey:@"value"];
	} 
	else if (fieldEnum == CPTScatterPlotFieldX) 
	{
		num = [recordDict objectForKey:@"weekspast"];
	}

    return num;
}


@end
