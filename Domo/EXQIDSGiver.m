//
//  EXQIDSGiver.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSGiver.h"


@implementation EXQIDSGiver
@synthesize qidsManager, pagingScrollView, activeQIDSSubmission, pageControl;
-(id) initWithQIDSManager:(EXQIDSManager *)manager submission:(EXQIDSSubmission*)submission{
	if (self = [super initWithNibName:nil bundle:nil]){
		self.modalPresentationStyle = UIModalPresentationFullScreen;
		self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		
		self.qidsManager			= manager;
		self.activeQIDSSubmission	= submission;
	}
	return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	[self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.view setAutoresizesSubviews:TRUE];
	[self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
	
	self.pagingScrollView = [[MHPagingScrollView alloc] initWithFrame:self.view.bounds];
	[self.pagingScrollView setPagingDelegate:self];
	[self.pagingScrollView setDelegate:self];
	[self.pagingScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:self.pagingScrollView];
	[self.pagingScrollView reloadPages];

	self.pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
	if (deviceIsPad){
		[self.pageControl setPageIndicatorImage:[UIImage imageNamed:@"pageDot"]];
		[self.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"currentPageDot"]];
	}else{
		[self.pageControl setPageIndicatorImage:[UIImage imageNamed:@"pageDot-small"]];
		[self.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"currentPageDot-small"]];
		[self.pageControl setIndicatorMargin:7];
	}

	double margin = ceil( (self.view.size.width- self.pageControl.width)/2);
	[self.pageControl setOrigin:CGPointMake(margin, self.view.height - self.pageControl.height)];
	[self.pageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
	self.pageControl.numberOfPages = [self pageCount];
	self.pageControl.currentPage = 0;
	[self.view addSubview:pageControl];
	
	
	UIButton * finishLaterButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[finishLaterButton setFrame:CGRectMake(9, 9, 25, 25)];
	[finishLaterButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
	[finishLaterButton setBackgroundColor:[UIColor clearColor]];
	[finishLaterButton setTitle:NSLocalizedString(@"X", @"on form-fill-out part of the app") forState:UIControlStateNormal];
	[[finishLaterButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
	[finishLaterButton setTitleColor:[UIColor colorWithWhite:.5 alpha:.5] forState:UIControlStateNormal];
	[finishLaterButton setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateHighlighted];
	[finishLaterButton addTarget:self action:@selector(finishLaterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:finishLaterButton];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation
										   duration:1];
	[self didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
}

-(void)finishLaterButtonPressed:(id)sender{
	[self dismissModalViewControllerAnimated:TRUE];
}


#pragma mark - View Controller Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.pagingScrollView beforeRotation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.pagingScrollView afterRotation];
}

#pragma mark - delegation

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
	self.pageControl.currentPage = [self.pagingScrollView indexOfSelectedPage];
	[self.pagingScrollView scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
//	if ([self.pagingScrollView indexOfSelectedPage]){
//		
//	}
}


#pragma mark pagecntrl
- (NSUInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView{
		
	return self.pageCount;
}

-(NSInteger) pageCount{
	double questionPageCount	= ceil([[[self qidsManager] questions] count]/ ((double)(deviceIsPad)?IPAD_MAXQUESTIONS_PER_PAGE:IPHONE_MAXQUESTIONS_PER_PAGE));
	NSInteger totalCount		= (int)questionPageCount + 1; //1 page for comments and done button

	return totalCount;
}

- (UIView *)pagingScrollView:(MHPagingScrollView *)scrollView pageForIndex:(NSUInteger)index{
		
	if (index +1 < self.pageCount){
		
		EXQIDSQuestionPage * qidsPage = nil;		
		UIView * dequed = [scrollView dequeueReusablePage];
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