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
#define CHART_SIZE_IPAD_PORTRAIT (CGSize){500, 435}
#define CHART_SIZE_IPAD_LANDSCAPE (CGSize){620, 435}

#define CHART_MARGIN_POD 10
#define CHART_SIZE_POD_PORTRAIT (CGSize){200, 320}
#define CHART_SIZE_POD_LANDSCAPE (CGSize){200, 320}

@implementation EXReviewVC
@synthesize qidsChart = _qidsChart;
@synthesize activeQIDSSubmission;

#pragma mark - content
-(NSArray*)detailBoxes{
	MGTableBox * layout = [MGTableBoxStyled boxWithSize:self.rowSize];
	[layout setLeftMargin:(deviceIsPad)?CHART_MARGIN_IPAD:CHART_MARGIN_POD];

	MGLineStyled *head = [MGLineStyled lineWithLeft:NSLocalizedString(@"QIDS Detail", @"header for extended QIDS detail") right:nil size:self.rowSize];
	head.font = self.headerFont;
	[layout.topLines addObject:head];

	MGLineStyled *dateLine = [MGLineStyled lineWithLeft:[NSDateFormatter localizedStringFromDate:self.activeQIDSSubmission.dueDate dateStyle:NSDateFormatterMediumStyle timeStyle:0] right:nil size:self.rowSize];
	dateLine.font = self.headerFont;
	[dateLine  setBackgroundColor:[UIColor clearColor]];
	[layout.middleLines addObject:dateLine];
	

	MGLineStyled *qidsValueLine = [MGLineStyled lineWithLeft:NSLocalizedString(@"total score: ", @"qids score label on qids detail") right:[NSString stringWithFormat:NSLocalizedString(@"%i/27", @"qids severity value on qids detail"),self.activeQIDSSubmission.qidsValue.intValue] size:self.rowSize];
	qidsValueLine.font = self.headerFont;
	[qidsValueLine  setBackgroundColor:[UIColor clearColor]];
	[layout.middleLines addObject:qidsValueLine];

	
	MGLineStyled *valueSeverityLine = [MGLineStyled lineWithLeft:NSLocalizedString(@"severity: ", @"qids severity label on qids detail") right:[NSString stringWithFormat:NSLocalizedString(@"%i/4", @"qids severity value display on qids detail"),self.activeQIDSSubmission.qidsSeverity.intValue] size:self.rowSize];
	valueSeverityLine.font = self.headerFont;
	[valueSeverityLine  setBackgroundColor:[UIColor clearColor]];
	[layout.middleLines addObject:layout];

	
	return @[layout];
}

-(NSArray*)primaryContentBoxes{
	
	MGTableBox * layout = MGTableBox.box;
	[layout setLeftMargin:(deviceIsPad)?CHART_MARGIN_IPAD:CHART_MARGIN_POD];
	
	MGLineStyled *head = [MGLineStyled lineWithLeft:NSLocalizedString(@"Review Progress", @"review tab header for reviewing progress on graph") right:nil size:CGSizeMake(CHART_SIZE_IPAD_PORTRAIT.width ,self.rowSize.height)];
	head.font = self.headerFont;
	[layout.topLines addObject:head];
	
	__weak MGLineStyled *chartDisplayBox = [MGLineStyled lineWithSize:(deviceIsPad)?CHART_SIZE_IPAD_PORTRAIT:CHART_SIZE_POD_PORTRAIT];
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

-(void) refreshContent{
	if (_qidsChart)
		[self.qidsChart removeFromSuperview];
	
	[super refreshContent];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orient
                                         duration:(NSTimeInterval)duration {
	//
	BOOL isPortrait = UIInterfaceOrientationIsPortrait(orient);
	
	self.primaryTable.size = deviceIsPad ?
	isPortrait? CHART_SIZE_IPAD_PORTRAIT : CHART_SIZE_IPAD_LANDSCAPE :
	isPortrait? CHART_SIZE_POD_PORTRAIT : CHART_SIZE_POD_LANDSCAPE;
	
	self.qidsChart.size = deviceIsPad ?
	isPortrait? CHART_SIZE_IPAD_PORTRAIT : CHART_SIZE_IPAD_LANDSCAPE :
	isPortrait? CHART_SIZE_POD_PORTRAIT : CHART_SIZE_POD_LANDSCAPE;

	[super willAnimateRotationToInterfaceOrientation:orient duration:duration];

}


#pragma mark - setup
-(id)init{
	if (self = [super initWithPresentedAppTab:domoAppTabReview]){
		[self setTitle:NSLocalizedString(@"Review", @"navigation bar title")];
		self.rowSize =  (CGSize){225, 44};
	}
	return self;
}

-(EXQIDSChart*) qidsChart{
	if (_qidsChart == nil){
		_qidsChart = [[EXQIDSChart alloc] initWithFrame:CGRectMake(0, 0, deviceIsPad? CHART_SIZE_IPAD_PORTRAIT.width: CHART_SIZE_POD_PORTRAIT.width, deviceIsPad?CHART_SIZE_IPAD_PORTRAIT.height:CHART_SIZE_POD_PORTRAIT.height)];
		[_qidsChart setDelegate:self];
		
		self.activeQIDSSubmission = [[[EXQIDSManager alloc] init] lastCompletedQIDSSubmissionForAuthor:[EXAuthor authorForLocalUser]];
	}
	return _qidsChart;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
	
}

#pragma mark - EXQIDSChartDelegate
-(void) qidsChart:(EXQIDSChart*)chart didSelectQIDSSubmission:(EXQIDSSubmission*)submission{
	self.activeQIDSSubmission = submission;
	[self refreshDetailContent:TRUE];
}


@end
