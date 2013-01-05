//
//  EXTrackVC.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXTrackVC.h"
#import "MNMRadioGroupValue.h"

@implementation EXTrackVC
@synthesize currentQuestionnaire, questionTileController;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
		[self setTitle:NSLocalizedString(@"Track", @"navigation bar title")];
	}
	return self;
}


-(void)viewDidLoad{
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greyFloral.png"]]];
	
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
-(UIView*)tileViewAtIndex:(NSInteger)tileIndex forTiledContentController:(exoTiledContentViewController*)tileController{
	if (self.currentQuestionnaire == EXQuestionnaireTypeQIDS){
		MNMRadioGroup * radioView = [[MNMRadioGroup alloc] initWithFrame:CGRectMake(0, 0, 295, 200) andValues:[MNMRadioGroupValue ]];
	}
	return nil;
}

#pragma mark MNMRadioGroupDelegate
-(void)MNMRadioGroupValueSelected:(MNMRadioGroupValue *)value{
	
}
@end
