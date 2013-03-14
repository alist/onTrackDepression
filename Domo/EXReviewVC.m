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

#define CHART_MARGIN_IPAD 10
#define CHART_SIZE_IPAD_PORTRAIT (CGSize){550, 435}
#define CHART_SIZE_IPAD_LANDSCAPE (CGSize){620, 435}

#define CHART_MARGIN_POD 10
#define CHART_SIZE_POD_PORTRAIT (CGSize){200, 320}
#define CHART_SIZE_POD_LANDSCAPE (CGSize){200, 320}

#define DETAIL_MARGIN_IPAD 37
#define DETAIL_MARGIN_POD 37

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


-(MGTableBox *)qidsExpandedDetailViewForSubmission:(EXQIDSSubmission*)submission{
	MGTableBox * detailBox = [MGTableBoxStyled boxWithSize:self.rowSize];
	[detailBox setLeftMargin:(deviceIsPad)?DETAIL_MARGIN_IPAD:DETAIL_MARGIN_POD];
	
	MGLineStyled *head = [MGLineStyled lineWithLeft:NSLocalizedString(@"QIDS Detail", @"header for extended QIDS detail") right:nil size:self.rowSize];
	head.font = self.headerFont;
	[detailBox.topLines addObject:head];
	
	MGLineStyled *dateLine = [MGLineStyled lineWithLeft:[NSDateFormatter localizedStringFromDate:submission.dueDate dateStyle:NSDateFormatterMediumStyle timeStyle:0] right:nil size:self.rowSize];
	dateLine.font = self.headerFont;
	[dateLine  setBackgroundColor:[UIColor clearColor]];
	[detailBox.middleLines addObject:dateLine];
	
	
	MGLineStyled *qidsValueLine = [MGLineStyled lineWithLeft:NSLocalizedString(@"total score: ", @"qids score label on qids detail") right:[NSString stringWithFormat:NSLocalizedString(@"%i/27", @"qids severity value on qids detail"),submission.qidsValue.intValue] size:self.rowSize];
	qidsValueLine.font = self.headerFont;
	[qidsValueLine  setBackgroundColor:[UIColor clearColor]];
	[detailBox.middleLines addObject:qidsValueLine];
	
	
	MGLineStyled *valueSeverityLine = [MGLineStyled lineWithLeft:NSLocalizedString(@"severity: ", @"qids severity label on qids detail") right:[NSString stringWithFormat:NSLocalizedString(@"%i/4", @"qids severity value display on qids detail"),submission.qidsSeverity.intValue] size:self.rowSize];
	valueSeverityLine.font = self.headerFont;
	[valueSeverityLine  setBackgroundColor:[UIColor clearColor]];
	[detailBox.middleLines addObject:valueSeverityLine];

	return detailBox;
}

-(NSArray*)detailBoxes{
	
	//selection lines
	
	MGTableBox * layout = [MGTableBoxStyled boxWithSize:self.rowSize];
	[layout setLeftMargin:(deviceIsPad)?DETAIL_MARGIN_IPAD:DETAIL_MARGIN_POD];

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
		
		[layout.middleLines addObject:optionLine];

	}
	
	return @[layout];
}

-(NSArray*)primaryContentBoxes{
	
	MGTableBox * layout = MGTableBox.box;
	[layout setLeftMargin:(deviceIsPad)?CHART_MARGIN_IPAD:CHART_MARGIN_POD];
		
	__weak MGLineStyled *chartDisplayBox = [MGLineStyled lineWithSize:(deviceIsPad)?CHART_SIZE_IPAD_PORTRAIT:CHART_SIZE_POD_PORTRAIT];
	[chartDisplayBox setBottomMargin:13];
	chartDisplayBox.asyncLayout = ^{
		int64_t delayInSeconds = .01;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[chartDisplayBox addSubview:self.qidsChart];
		});
	};

	[chartDisplayBox setBackgroundColor:[UIColor clearColor]];
	
	[layout.middleLines addObject:chartDisplayBox];
	
	return @[layout];

}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if (self.dataNeedsRefresh){
		self.dataNeedsRefresh = FALSE;
		[self.qidsChart reloadData];
	}
}

-(void) refreshContent{
	if (_qidsChart)
		[self.qidsChart removeFromSuperview];

	[super refreshGridContent];
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orient
                                         duration:(NSTimeInterval)duration {
	if (self.appearedOnce == FALSE)
		return;
	
	//
	BOOL isPortrait = UIInterfaceOrientationIsPortrait(orient);
	
	CGSize newPrimaryTableSize = deviceIsPad ?
	isPortrait? CHART_SIZE_IPAD_PORTRAIT : CHART_SIZE_IPAD_LANDSCAPE :
	isPortrait? CHART_SIZE_POD_PORTRAIT : CHART_SIZE_POD_LANDSCAPE;
	
	self.primaryTable.width = newPrimaryTableSize.width;
	self.qidsGraphHeader.width = newPrimaryTableSize.width;
	
	self.qidsChart.size = deviceIsPad ?
	isPortrait? CHART_SIZE_IPAD_PORTRAIT : CHART_SIZE_IPAD_LANDSCAPE :
	isPortrait? CHART_SIZE_POD_PORTRAIT : CHART_SIZE_POD_LANDSCAPE;

	[super willAnimateRotationToInterfaceOrientation:orient duration:duration];

}


#pragma mark - setup
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

-(void)_dataUpdated:(id)sender{
	self.dataNeedsRefresh = TRUE;
	
	if ([self.view isDescendantOfView:[[UIApplication sharedApplication] keyWindow]]){
		self.dataNeedsRefresh = FALSE;
		[self.qidsChart reloadData];
	}
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(EXQIDSChart*) qidsChart{
	if (_qidsChart == nil){
		_qidsChart = [[EXQIDSChart alloc] initWithFrame:CGRectMake(0, 0, deviceIsPad? CHART_SIZE_IPAD_PORTRAIT.width: CHART_SIZE_POD_PORTRAIT.width, deviceIsPad?CHART_SIZE_IPAD_PORTRAIT.height:CHART_SIZE_POD_PORTRAIT.height)];
		[_qidsChart setDelegate:self];
	}
	return _qidsChart;
}

#pragma mark - EXQIDSChartDelegate
-(void) qidsChart:(EXQIDSChart*)chart didSelectQIDSSubmission:(EXQIDSSubmission*)submission{
	self.activeQIDSSubmission = submission;
	[self refreshDetailContent:TRUE];
}

-(void) reloadSeriesDisplayFromQIDSChart:(EXQIDSChart*)chart{
	[self refreshDetailContent:TRUE];
}


@end
