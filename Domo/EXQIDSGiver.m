//
//  EXQIDSGiver.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSGiver.h"


@implementation EXQIDSGiver
@synthesize qidsManager, pagingView, activeQIDSSubmission;
-(id) initWithQIDSManager:(EXQIDSManager *)manager submission:(EXQIDSSubmission*)submission{
	if (self = [super initWithNibName:nil bundle:nil]){
		self.modalPresentationStyle = UIModalPresentationPageSheet;
		self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		
		self.qidsManager			= manager;
		self.activeQIDSSubmission	= submission;
	}
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
	
	self.pagingView = [[MHPagingScrollView alloc] initWithFrame:self.view.bounds];
	[self.pagingView setPagingDelegate:self];
	[self.pagingView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
	[self.view addSubview:self.pagingView];
	[self.pagingView reloadPages];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

#pragma mark - delegation
#pragma mark pagecntrl
- (NSUInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView{
		
	return self.pageCount;
}

-(NSInteger) pageCount{
	double questionPageCount	= ceil([[[self qidsManager] questions] count]/ ((double)(deviceIsPad)?IPAD_MAXQUESTIONS_PER_PAGE:IPHONE_MAXQUESTIONS_PER_PAGE));
	NSInteger totalCount		= (int)questionPageCount + 1; //1 page for comments and done button

	return totalCount;
}

- (UIView *)pagingScrollView:(MHPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index{
		
	if (index +1 < self.pageCount){
		
		EXQIDSQuestionPage * qidsPage = nil;
		
		UIView * dequed = [pagingScrollView dequeueReusablePage];
		if ([dequed isKindOfClass:[EXQIDSQuestionPage class]]){
			qidsPage  = (EXQIDSQuestionPage*)qidsPage;
		}
		if (qidsPage == nil){
			qidsPage = [[EXQIDSQuestionPage alloc] initWithDelegate:self frame:self.view.bounds];
		}
		
		[qidsPage updateViewWithQIDSSubmission:self.activeQIDSSubmission qidsManager:self.qidsManager pageNumber:index];
		
		return qidsPage;
		
	}else if (index +1 < self.pageCount){
		return [[UIView alloc] initWithFrame:self.view.bounds];
	}
	
	return nil;
}

#pragma mark QIDSPage 
-(void)QIDSQuestionPage:(EXQIDSQuestionPage*)qPage didChangeValueOfQuestionNumber:(NSInteger)qNumber{
	//if last question in sheet, then autoflip
}

@end
