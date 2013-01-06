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
@property (nonatomic, strong) EXQIDSManager	* qidsManager;
@end

@implementation EXTrackVC
@synthesize currentQuestionnaire, questionTileController;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)context{
	if (self = [super initWithNibName:nil bundle:nil]){
		self.objectContext = context;
		[self setTitle:NSLocalizedString(@"Track", @"navigation bar title")];
		
		self.qidsManager = [[EXQIDSManager alloc] initWithManagedObjectContext:self.objectContext];
	}
	return self;

}

-(void)viewDidLoad{
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greyFloral.png"]]];
	
	self.currentQuestionnaire = EXQuestionnaireTypeQIDS;//	temp
	
	CGRect formRect = self.view.bounds;
	formRect.origin = CGPointMake(0, 85);
	formRect.size.height -= formRect.origin.y;
	CGRect formQuestionDimensions = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))?(formQuestionDimensionsPortrait):(formQuestionDimensionsLandscape);
	self.questionTileController = [[exoTiledContentViewController alloc] initWithDisplayFrame:formRect tileContentControllerDelegate:self withCenteredTilesSized:formQuestionDimensions.size andMargins:CGSizeMake(15, 20)];
	[self.view addSubview:self.questionTileController.view];
	
	[super viewDidLoad];
}



#pragma mark -
#pragma mark exoTiledContentViewControllerContentDelegate
-(NSInteger)tileCountForTiledContentController:(exoTiledContentViewController*)tileContentController{
	switch (self.currentQuestionnaire) {
		case EXQuestionnaireTypeNone:
			return 0;
			break;
		case EXQuestionnaireTypeQIDS:
			return 16;
			break;
		default:
			return 0;
			break;
	}
}
-(UIView*)tileViewAtIndex:(NSInteger)tileIndex orientation:(UIDeviceOrientation)orientation forTiledContentController:(exoTiledContentViewController *)tileController{
	if (self.currentQuestionnaire == EXQuestionnaireTypeQIDS){
		
		NSArray * quesitons = [[[self.qidsManager questions] objectAtIndex:tileIndex] objectForKey:@"values"];
		
		CGRect formQuestionDimensions = (UIInterfaceOrientationIsPortrait(orientation))?(formQuestionDimensionsPortrait):(formQuestionDimensionsLandscape);
		MNMRadioGroup * radioView = [[MNMRadioGroup alloc] initWithFrame:formQuestionDimensions textColor:[UIColor colorWithWhite:.05 alpha:1] textFont:[UIFont fontWithName:@"Helvetica-Light" size:14] andValues:quesitons];
		[radioView setBackgroundColor:[UIColor colorWithWhite:.9 alpha:.5]];
		[radioView setIdentifier:@(tileIndex)];
		[radioView setDelegate:self];
		return radioView;
	}
	return nil;
}

-(BOOL) shouldReLayoutViewsForNewOrientaion: (UIDeviceOrientation)orientation forTiledContentController:(exoTiledContentViewController*)tileContentController{
	
	CGRect formQuestionDimensions = (UIInterfaceOrientationIsPortrait(orientation))?(formQuestionDimensionsPortrait):(formQuestionDimensionsLandscape);
	[self.questionTileController setParamsFromCenteredTilesSized:formQuestionDimensions.size andMargins:CGSizeMake(15, 20)];
	return true;
}

#pragma mark MNMRadioGroupDelegate
-(void)MNMRadioGroupValueSelected:(MNMRadioGroupValue *)value fromRadioGroup:(MNMRadioGroup *)group{
	
}
@end
