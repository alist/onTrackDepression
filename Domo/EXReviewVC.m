//
//  EXAnalyzeVC.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXReviewVC.h"
#import "MGTableBoxStyled.h"

#define GRAPH_MARGIN_IPAD 40

@implementation EXReviewVC
@synthesize lineHostingView;

#pragma mark - content
-(NSArray*)detailBoxes{
	MGTableBox * layout = MGTableBox.box;
	
	MGLineStyled *head = [MGLineStyled lineWithLeft:NSLocalizedString(@"Review Progress", @"review tab header for reviewing progress on graph") right:nil size:self.rowSize];
	head.font = self.headerFont;
	[layout.topLines addObject:head];
	
}

#pragma mark - setup
-(id)init{
	if (self = [super initWithPresentedAppTab:domoAppTabReview]){
		[self setTitle:NSLocalizedString(@"Review", @"navigation bar title")];
		
	}
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
}

@end
