//
//  EXAnalyzeVC.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXReviewVC.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "EXQIDSManager.h"


#define IPHONE_TABLES_GRID_PORTRAIT     (CGSize){320, 0}
#define IPAD_TABLES_GRID_PORTRAIT       (CGSize){600, 0}

#define CHART_MARGIN_IPAD 20
#define CHART_SIZE_IPAD_PORTRAIT (CGSize){550, 435}
#define CHART_SIZE_IPAD_LANDSCAPE (CGSize){620, 435}

#define CHART_MARGIN_POD 20
#define CHART_SIZE_POD_PORTRAIT (CGSize){200, 320}
#define CHART_SIZE_POD_LANDSCAPE (CGSize){200, 320}

#define OPTIONS_SIZE_IPAD_PORTRAIT (CGSize){550, 435}
#define OPTIONS_SIZE_POD_PORTRAIT (CGSize){200, 435}

#define DETAIL_MARGIN_IPAD 42
#define DETAIL_MARGIN_POD 42

@interface EXReviewVC ()
//because we have the primaryTable.sizingMode = MGResizingShrinkWrap;
@property (strong, nonatomic) MGLineStyled *qidsGraphHeader;
@end

@implementation EXReviewVC
@synthesize qidsChart = _qidsChart;
@synthesize activeQIDSSubmission;
@synthesize qidsGraphHeader;
@synthesize dataNeedsRefresh;

#pragma mark - content


-(void) refreshEverything{
	
	[self refreshChartBox];
	[self refreshOptionsGrid];
	
	// animate
	[self.superTableBox layoutWithSpeed:0.3 completion:nil];
	
}

-(void) refreshChartBox{
	if (_qidsChart)
		[self.qidsChart removeFromSuperview];
	
	[[self.chartBox boxes] removeAllObjects];
	
	__weak MGLineStyled *chartDisplayBox = [MGLineStyled lineWithSize:(deviceIsPad)?CHART_SIZE_IPAD_PORTRAIT:CHART_SIZE_POD_PORTRAIT];
	[chartDisplayBox setBottomMargin:13];
	[chartDisplayBox setBackgroundColor:[UIColor clearColor]];
	[[self.chartBox boxes] addObject:chartDisplayBox];
	
	chartDisplayBox.asyncLayout = ^{
		int64_t delayInSeconds = .01;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[self.chartBox addSubview:self.qidsChart];
		});
	};
	
}

-(void) refreshOptionsGrid{
	[[self.optionsGrid boxes] removeAllObjects];
	[[self.optionsGrid boxes] addObjectsFromArray:[self optionsBoxes]];
}



-(NSArray*)optionsBoxes{
	
	//selection lines
	
	MGTableBox * qidsCategories = [MGTableBoxStyled boxWithSize:self.rowSize];
	
	for (NSDictionary * dict in [self.qidsChart seriesOptions]){
		NSUInteger index = [[self.qidsChart seriesOptions] indexOfObject:dict];
		
		UILabel * lineStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
		[lineStyleLabel setFont:[UIFont fontWithName:@"Courier" size:18]];
		[lineStyleLabel setText:@"–––"];
		[lineStyleLabel setTextColor:[dict valueForKey:@"color"]];
		[lineStyleLabel setBackgroundColor:[UIColor clearColor]];
		
		UILabel * seriesTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
		[seriesTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
		[seriesTitle setText:[dict valueForKey:@"title"]];
		[seriesTitle setBackgroundColor:[UIColor clearColor]];
		
		
		if ([self.qidsChart.displayedSeries containsObject:@(index)]){
			[seriesTitle setTextColor:[UIColor colorWithWhite:.05 alpha:1]];
		}else{
			[seriesTitle setTextColor:[UIColor lightGrayColor]];
			[lineStyleLabel setTextColor:[UIColor lightGrayColor]];
		}
		
		MGLineStyled *optionLine = [MGLineStyled lineWithLeft:lineStyleLabel right:seriesTitle size:self.rowSize];
		[optionLine  setBackgroundColor:[UIColor clearColor]];
		EXQIDSChart *chart = self.qidsChart;
		optionLine.onTap = ^{
			[chart toggleSeriesDisplay:index];
		};
		
		[qidsCategories.middleLines addObject:optionLine];
		
	}
	
	MGTableBox * qidsBreakdownCharacteristics = [MGTableBoxStyled boxWithSize:self.rowSize];
	[qidsBreakdownCharacteristics setLeftMargin:(deviceIsPad)?CHART_MARGIN_IPAD:CHART_MARGIN_POD];
	
	for (NSDictionary * dict in [self.qidsChart seriesOptions]){
		NSUInteger index = [[self.qidsChart seriesOptions] indexOfObject:dict];
		
		UILabel * lineStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
		[lineStyleLabel setFont:[UIFont fontWithName:@"Courier" size:18]];
		[lineStyleLabel setText:@"–––"];
		[lineStyleLabel setTextColor:[dict valueForKey:@"color"]];
		[lineStyleLabel setBackgroundColor:[UIColor clearColor]];
		
		UILabel * seriesTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
		[seriesTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
		[seriesTitle setText:[dict valueForKey:@"title"]];
		[seriesTitle setBackgroundColor:[UIColor clearColor]];
		
		
		if ([self.qidsChart.displayedSeries containsObject:@(index)]){
			[seriesTitle setTextColor:[UIColor colorWithWhite:.05 alpha:1]];
		}else{
			[seriesTitle setTextColor:[UIColor lightGrayColor]];
			[lineStyleLabel setTextColor:[UIColor lightGrayColor]];
		}
		
		MGLineStyled *optionLine = [MGLineStyled lineWithLeft:lineStyleLabel right:seriesTitle size:self.rowSize];
		[optionLine  setBackgroundColor:[UIColor clearColor]];
		EXQIDSChart *chart = self.qidsChart;
		optionLine.onTap = ^{
			[chart toggleSeriesDisplay:index];
		};
		
		[qidsBreakdownCharacteristics.middleLines addObject:optionLine];
		
	}

	
	return @[qidsCategories, qidsBreakdownCharacteristics];
}



#pragma mark - member vars

-(MGBox*) chartBox{
	if (_chartBox == nil){
		_chartBox = [MGBox boxWithSize:(deviceIsPad)?CHART_SIZE_IPAD_PORTRAIT:CHART_SIZE_POD_PORTRAIT];
		[_chartBox setLeftMargin:(deviceIsPad)?CHART_MARGIN_IPAD:CHART_MARGIN_POD];
	}return _chartBox;
}

-(MGBox*) optionsGrid{
	if (_optionsGrid == nil){
		_optionsGrid = [MGBox boxWithSize:((deviceIsPad)?OPTIONS_SIZE_IPAD_PORTRAIT:OPTIONS_SIZE_POD_PORTRAIT)];
		_optionsGrid.contentLayoutMode = MGLayoutGridStyle;
		[_optionsGrid setLeftPadding:(deviceIsPad)?DETAIL_MARGIN_IPAD:DETAIL_MARGIN_POD];
	}
	return _optionsGrid;
}

-(void)_dataUpdated:(id)sender{
	self.dataNeedsRefresh = TRUE;
	
	if ([self.view isDescendantOfView:[[UIApplication sharedApplication] keyWindow]]){
		self.dataNeedsRefresh = FALSE;
		[self.qidsChart reloadData];
	}
}

-(EXQIDSChart*) qidsChart{
	if (_qidsChart == nil){
		_qidsChart = [[EXQIDSChart alloc] initWithFrame:CGRectMake(0, 0, deviceIsPad? CHART_SIZE_IPAD_PORTRAIT.width: CHART_SIZE_POD_PORTRAIT.width, deviceIsPad?CHART_SIZE_IPAD_PORTRAIT.height:CHART_SIZE_POD_PORTRAIT.height)];
		[_qidsChart setDelegate:self];
	}
	return _qidsChart;
}

-(UIPopoverController*) extendedDataPopover{
	if (_extendedDataPopover == nil){
		_extendedDataPopover = [[UIPopoverController alloc] initWithContentViewController:self.singleQIDSInspectorVC];
		[_extendedDataPopover setPopoverContentSize:self.singleQIDSInspectorVC.view.size];
	}
	return _extendedDataPopover;
}

-(EXSingleQIDSInspectorVC*) singleQIDSInspectorVC{
	if (_singleQIDSInspectorVC == nil){
		_singleQIDSInspectorVC = [[EXSingleQIDSInspectorVC alloc] init];
	}
	return _singleQIDSInspectorVC;
	
}

#pragma mark - setup

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if (self.dataNeedsRefresh){
		self.dataNeedsRefresh = FALSE;
		[self.qidsChart reloadData];
	}
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orient
                                         duration:(NSTimeInterval)duration {

	[super willAnimateRotationToInterfaceOrientation:orient duration:duration];

}

-(id)init{
	if (self = [super initWithPresentedAppTab:domoAppTabReview]){
		[self setTitle:NSLocalizedString(@"Review", @"navigation bar title")];
		self.navigationItem.title = NSLocalizedString(@"progress by weeks ago", @"review tab header for reviewing progress on graph");
		
		self.rowSize =  (CGSize){225, 44};
		
		self.dataNeedsRefresh = FALSE; //automatically fresh on first run
		
		self.activeQIDSSubmission = [[[EXQIDSManager alloc] init] lastCompletedQIDSSubmissionForAuthor:[EXAuthor authorForLocalUser]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_dataUpdated:) name:newQIDSSubmittedNotification object:nil];
	}
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	CGSize superTableBoxSize = deviceIsPad ? IPAD_TABLES_GRID_PORTRAIT: IPHONE_TABLES_GRID_PORTRAIT;
	self.superTableBox = [MGBox boxWithSize:superTableBoxSize];
	self.superTableBox.contentLayoutMode = MGLayoutTableStyle;
	
	[[self.superTableBox boxes] addObject:self.chartBox];
	[[self.superTableBox boxes] addObject:self.optionsGrid];
	
	
	[self.superTableBox setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
	CGPoint boxOrigin = CGPointMake(floor(self.view.width/2 - self.superTableBox.width/2), 0);
	[self.superTableBox setOrigin:boxOrigin];
	[self.view addSubview:self.superTableBox];
	
	[self refreshEverything];
	
}
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - EXQIDSChartDelegate
-(void) qidsChart:(EXQIDSChart*)chart didSelectQIDSSubmission:(EXQIDSSubmission*)submission atPoint:(CGPoint)selectionPoint{
	[self.singleQIDSInspectorVC updateWithQIDSSubmission:submission];
	[_extendedDataPopover setPopoverContentSize:self.singleQIDSInspectorVC.view.size animated:TRUE];
	[[self extendedDataPopover] presentPopoverFromRect:CGRectMake(selectionPoint.x, selectionPoint.y,1,1) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:FALSE];
	self.activeQIDSSubmission = submission;
}

-(void) reloadSeriesDisplayFromQIDSChart:(EXQIDSChart*)chart{
	[self refreshOptionsGrid];
	// animate
	[self.superTableBox layoutWithSpeed:0.3 completion:nil];
}


@end
