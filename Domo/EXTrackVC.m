//
//  EXTrackVC.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXTrackVC.h"
#import "MNMRadioGroupValue.h"
#import "EXQIDSManager.h"

static const CGRect formQuestionDimensionsPortrait = {{0,0},{325, 250}};
static const CGRect formQuestionDimensionsLandscape = {{0,0},{400, 200}};

@interface EXTrackVC ()
@end

@implementation EXTrackVC
@synthesize currentQuestionnaire, questionTileController,qidsGiver = _qidsGiver;

#pragma mark - content 
-(NSArray*)detailBoxes{
	// make the table
	MGTableBoxStyled *layout = MGTableBoxStyled.box;
	
	// header
	MGLineStyled *head = [MGLineStyled lineWithLeft:NSLocalizedString(@"Tracking Mood", @"track tab header for tracking options") right:nil size:self.rowSize];
	[layout.topLines addObject:head];
	head.font = self.headerFont;
	
	//need to add author
	MGLineStyled *grids = [MGLineStyled lineWithLeft:NSLocalizedString(@"Start Form Series", @"track tab text for beginning regimine") right:[UIImage imageNamed:@"disclosureArrow"] size:self.rowSize];
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

-(void)viewDidLoad{
	[super viewDidLoad];
}


-(EXQIDSGiver*)qidsGiver{
	if (_qidsGiver == nil){
		_qidsGiver = [[EXQIDSGiver alloc] initWithQIDSManager:self.qidsManager submission:[self.qidsManager qidsSubmissionForAuthor:[EXAuthor authorForLocalUser]]];
	}
	return _qidsGiver;
}


@end
