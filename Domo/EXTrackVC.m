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

@interface EXTrackVC ()
@end

@implementation EXTrackVC
@synthesize currentQuestionnaire,qidsGiver = _qidsGiver;

#pragma mark - content 
-(NSArray*)detailBoxes{
	// make the table
	MGTableBoxStyled *layout = MGTableBoxStyled.box;
	
	// header
	MGLineStyled *head = [MGLineStyled lineWithLeft:NSLocalizedString(@"Tracking Mood", @"track tab header for tracking options") right:nil size:self.rowSize];
	head.font = self.headerFont;
	[layout.topLines addObject:head];
	
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
	
	MGLineStyled *grids = [MGLineStyled lineWithLeft:qidsCalloutText right:[UIImage imageNamed:@"disclosureArrow"] size:self.rowSize];
	[layout.topLines addObject:grids];
	grids.onTap = ^{
		if ([self.childViewControllers containsObject:self.qidsGiver] == NO){
			[self presentViewController:self.qidsGiver animated:TRUE completion:nil];
		}
	};
	
	return @[layout];
}

#pragma mark - setup
-(id)init{
	if (self = [super initWithPresentedAppTab:domoAppTabTrack]){
		[self setTitle:NSLocalizedString(@"Track", @"navigation bar title")];
		
	}
	return self;

}

-(void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self refreshContent];
}

-(void)viewDidLoad{
	[super viewDidLoad];
}


-(EXQIDSGiver*)qidsGiver{
	
	if (_qidsGiver == nil){
		_qidsGiver = [[EXQIDSGiver alloc] initWithQIDSManager:self.qidsManager];
	}
	[_qidsGiver setActiveQIDSSubmission:[self.qidsManager qidsSubmissionForAuthor:[EXAuthor authorForLocalUser]]];
	return _qidsGiver;
}


@end
