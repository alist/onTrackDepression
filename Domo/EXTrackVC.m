//
//  EXTrackVC.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXTrackVC.h"
#import "EXQIDSManager.h"

static const CGRect formQuestionDimensionsPortrait = {{0,0},{325, 250}};
static const CGRect formQuestionDimensionsLandscape = {{0,0},{400, 200}};

static const CGSize treatmentPromptSizePAD = {470, 290};
static const CGSize infoFeedbackGridSizePAD = {675, 130};
static const CGSize infoFeedbackGridItemSizePAD = {300, 190};
static const CGSize landingPageSuperBoxSizePAD = {675, 690};


static const CGSize treatmentPromptSizePOD = {470, 290};
static const CGSize infoFeedbackGridSizePOD = {675, 130};
static const CGSize infoFeedbackGridItemSizePOD = {300, 130};
static const CGSize landingPageSuperBoxSizePOD = {675, 800};

static const double rowHeight = 44;


@interface EXTrackVC ()
@end

@implementation EXTrackVC
@synthesize currentQuestionnaire,qidsGiver = _qidsGiver;

#pragma mark - boxes and content
-(MGBox*)treatmentPromptBox{
	if (_treatmentPromptBox == nil){
		_treatmentPromptBox = [MGBox boxWithSize:treatmentPromptSizePAD];
		double leftMargin = ceil(landingPageSuperBoxSizePAD.width/2-(treatmentPromptSizePAD.width + _treatmentPromptBox.leftMargin)/2 );
		[_treatmentPromptBox setLeftMargin:leftMargin];
	}
	return _treatmentPromptBox;
}

-(MGBox*)infoFeedbackGridBox{
	if (_infoFeedbackGridBox == nil){
		_infoFeedbackGridBox = [MGBox boxWithSize:infoFeedbackGridSizePAD];
		_infoFeedbackGridBox.contentLayoutMode = MGLayoutGridStyle;
	}
	return _infoFeedbackGridBox;
}

-(void) refreshEverything{
	[self refreshTreatmentPromptBox];
	[self refreshInfoFeedbackGrid];
	
	// animate
	[self.superTableBox layoutWithSpeed:0.3 completion:nil];
}

-(void) refreshTreatmentPromptBox{
	[_treatmentPromptBox.boxes removeAllObjects];
	
	MGTableBoxStyled *promptBox = [MGTableBoxStyled boxWithSize:treatmentPromptSizePAD];
	[promptBox setLeftMargin:0];
	
	// header
	MGLineStyled *head = [MGLineStyled lineWithLeft:NSLocalizedString(@"Tracking Mood via QIDS", @"track tab header for tracking options") right:nil size:CGSizeMake(treatmentPromptSizePAD.width, rowHeight)];
	head.font = self.headerFont;
	[promptBox.topLines addObject:head];
	
	
	MGLineStyled * qidsDescription = [MGLineStyled multilineWithText:NSLocalizedString(@"The QIDS (SR-16) is validated form used by therapists and clinicians for determining and tracking depression levels over time.\n\nYou may find it useful to track your own mood levels- once a week is what it's designed for.", @"QIDS Description") font:self.defaultFont width:treatmentPromptSizePAD.width padding:UIEdgeInsetsMake(16, 16, 16, 16)];
	[qidsDescription setMinHeight:(treatmentPromptSizePAD.height - rowHeight*2)];
	
	[[promptBox topLines] addObject:qidsDescription];
	
	//need to add author
	NSString * qidsCalloutText = nil;
	if ([[[EXAuthor authorForLocalUser] qidsSubmissions] count] == 0){
		qidsCalloutText = NSLocalizedString(@"Start First QIDS Form", @"track tab text for beginning regimine");
	}else {
		
		EXQIDSSubmission * submission = [self.qidsManager qidsSubmissionForAuthor:[EXAuthor authorForLocalUser]];
		
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EEEE MMd" options:0 locale:[NSLocale currentLocale]]];
		
		if ([submission dateLastEdited] == nil){
			qidsCalloutText = [NSString stringWithFormat:NSLocalizedString(@"Begin QIDS for %@", @"defines when form is due on track page"),[formatter stringFromDate:[submission dueDate]]];
		}else{
			qidsCalloutText = [NSString stringWithFormat:NSLocalizedString(@"Continue QIDS for %@", @"defines when form is due on track page"),[formatter stringFromDate:[submission dueDate]]];
		}
	}
	
	MGLineStyled *qidsPrompt = [MGLineStyled lineWithLeft:qidsCalloutText right:[UIImage imageNamed:@"disclosureArrow"] size:CGSizeMake(treatmentPromptSizePAD.width, rowHeight)];
	qidsPrompt.onTap = ^{
		if ([self.childViewControllers containsObject:self.qidsGiver] == NO){
			[self presentViewController:self.qidsGiver animated:TRUE completion:nil];
		}
	};
	[promptBox.topLines addObject:qidsPrompt];
	
	

	[_treatmentPromptBox.boxes addObject:promptBox];
}
-(void) refreshInfoFeedbackGrid{
	[_infoFeedbackGridBox.boxes removeAllObjects];
	
	[_infoFeedbackGridBox.boxes addObjectsFromArray:[self infoFeedbackBoxes]];
}

-(NSArray *)infoFeedbackBoxes{
	
	MGTableBoxStyled *goalSection = [MGTableBoxStyled boxWithSize:infoFeedbackGridItemSizePAD];
	// header
	MGLineStyled *goalHead = [MGLineStyled lineWithLeft:NSLocalizedString(@"Our goal", @"header for our goal") right:nil size:CGSizeMake(infoFeedbackGridItemSizePAD.width, rowHeight)];
	goalHead.font = self.headerFont;
	[goalSection.topLines addObject:goalHead];
	
	// stuff
	MGLineStyled *goalLine = [MGLineStyled multilineWithText:NSLocalizedString(@"It's our goal to make and develop and discover the most effective techniques for promoting self-improvement of mood and depression.", @"be-in touch description text") font:nil width:infoFeedbackGridItemSizePAD.width padding:UIEdgeInsetsMake(16, 16, 16, 16)];
	[goalSection.topLines addObject:goalLine];

	
	MGTableBoxStyled *feedBackSection = [MGTableBoxStyled boxWithSize:infoFeedbackGridItemSizePAD];
	
	double feedbackItemMargin = infoFeedbackGridSizePAD.width - infoFeedbackGridItemSizePAD.width * 2 - feedBackSection.leftMargin - goalSection.leftMargin;
	[feedBackSection setLeftMargin:feedbackItemMargin];
	
	// header
	MGLineStyled *feedbackHead = [MGLineStyled lineWithLeft:NSLocalizedString(@"Be in touch", @"header for be-in touch") right:nil size:CGSizeMake(infoFeedbackGridItemSizePAD.width, rowHeight)];
	feedbackHead.font = self.headerFont;
	[feedBackSection.topLines addObject:feedbackHead];
	
	// stuff
    MGLineStyled * contactButton = [MGLineStyled ]
    
	MGLineStyled *feedbackLine = [MGLineStyled multilineWithText:NSLocalizedString(@"It's our goal to make and develop and discover the most effective techniques for promoting self-improvement of mood and depression..", @"be-in touch description text") font:nil width:infoFeedbackGridItemSizePAD.width padding:UIEdgeInsetsMake(16, 16, 16, 16)];
	[feedBackSection.topLines addObject:feedbackLine];
	
	return @[goalSection, feedBackSection];

}


#pragma mark - setup
-(void)viewDidLoad{
	[super viewDidLoad];
	
	CGSize superTableBoxSize = deviceIsPad ? landingPageSuperBoxSizePAD: landingPageSuperBoxSizePOD;
	self.superTableBox = [MGBox boxWithSize:superTableBoxSize];
	self.superTableBox.contentLayoutMode = MGLayoutTableStyle;
	
	[[self.superTableBox boxes] addObject:self.treatmentPromptBox];
	[[self.superTableBox boxes] addObject:self.infoFeedbackGridBox];
	[self.infoFeedbackGridBox setTopMargin:superTableBoxSize.height-self.treatmentPromptBox.height - self.infoFeedbackGridBox.height - 80];//20 px margin
	
	
	[self.superTableBox setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
	CGPoint boxOrigin = CGPointMake(floor(self.view.width/2 - self.superTableBox.width/2), 0);
	[self.superTableBox setOrigin:boxOrigin];
	[self.view addSubview:self.superTableBox];
	
	[self refreshEverything];
	
}

-(id)init{
	if (self = [super initWithPresentedAppTab:domoAppTabTrack]){
		[self setTitle:NSLocalizedString(@"Track", @"navigation bar title")];
		self.navigationItem.title = NSLocalizedString(@"onTrack: Depression", @"review tab header for entire page");
		
	}
	return self;

}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}



-(EXQIDSGiver*)qidsGiver{
	
	if (_qidsGiver == nil){
		_qidsGiver = [[EXQIDSGiver alloc] initWithQIDSManager:self.qidsManager];
	}
	[_qidsGiver setActiveQIDSSubmission:[self.qidsManager qidsSubmissionForAuthor:[EXAuthor authorForLocalUser]]];
	return _qidsGiver;
}


@end
