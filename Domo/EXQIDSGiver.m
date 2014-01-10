//
//  EXQIDSGiver.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSGiver.h"


@implementation EXQIDSGiver
@synthesize qidsManager, pagingScrollView, activeQIDSSubmission = _activeQIDSSubmission, pageControl;
-(id) initWithQIDSManager:(EXQIDSManager *)manager{
	if (self = [super initWithNibName:nil bundle:nil]){
		self.modalPresentationStyle = UIModalPresentationFullScreen;
		self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		
		self.qidsManager			= manager;
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
	[self.pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];

	double margin = ceil( (self.view.size.width- self.pageControl.width)/2);
	[self.pageControl setOrigin:CGPointMake(margin, self.view.height - self.pageControl.height)];
	[self.pageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
	self.pageControl.numberOfPages = [self pageCount];
	self.pageControl.currentPage = 0;
	[self.view addSubview:pageControl];
	
	
	UIButton * finishLaterButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[finishLaterButton setFrame:CGRectMake(9, 9, 25, 25)];
    if (IS_OS_7_OR_LATER){
        finishLaterButton.origin = CGPointMake(finishLaterButton.origin.x, finishLaterButton.origin.y + EXTRA_IOS7_SPACING);
    }
    
	[finishLaterButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
	[finishLaterButton setBackgroundColor:[UIColor clearColor]];
	[finishLaterButton setTitle:@"X" forState:UIControlStateNormal];
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

-(void) setActiveQIDSSubmission:(EXQIDSSubmission *)activeQIDSSubmission{
	if (_activeQIDSSubmission != activeQIDSSubmission){
		_activeQIDSSubmission = activeQIDSSubmission;
		
		[self.pagingScrollView selectPageAtIndex:0 animated:NO];
	}
}


#pragma mark interaction

-(void)flipToNextPage{
	NSUInteger newIndex = self.pagingScrollView.indexOfSelectedPage + 1;
	if (newIndex <= [self pageCount])
		[self.pagingScrollView selectPageAtIndex:newIndex animated:YES];
}

-(void)pageControlChanged:(id)sender{
	[self.pagingScrollView selectPageAtIndex:self.pageControl.currentPage animated:YES];
}

-(void)finishLaterButtonPressed:(id)sender{
	[self dismissForm];
}


-(void) dismissForm{
	[self.activeQIDSSubmission.managedObjectContext saveOnlySelfWithCompletion:^(BOOL success, NSError *error){
		if (error)
			NSLog(@"Save err for qids %@",[error description]);
	}];
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

- (NSInteger) questionsOnPage:(NSInteger)pageNumber{
	if (pageNumber < self.pageCount -1){ //(what's the last page index?) the last page has no questions
		if (pageNumber < self.pageCount -2){
			//middle pages contain max quantity of qs
			return ((deviceIsPad)?IPAD_MAXQUESTIONS_PER_PAGE:IPHONE_MAXQUESTIONS_PER_PAGE);
		}else{
			//last page of questions
			NSInteger questions = ([[[self qidsManager] questions] count] - (self.pageCount -2)*((deviceIsPad)?IPAD_MAXQUESTIONS_PER_PAGE:IPHONE_MAXQUESTIONS_PER_PAGE));
			return questions;
		}
	}else{
		return 0;
	}
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


#pragma mark multipagecntrl
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
		
	}else if (index +1 == self.pageCount){
		//last page
		EXQIDSNoteSubmitPage* submitPage = [[EXQIDSNoteSubmitPage alloc] initWithDelegate:self frame:self.view.bounds];
		
		[submitPage updateViewWithQIDSSubmission:self.activeQIDSSubmission qidsManager:self.qidsManager pageNumber:index];

		return submitPage;
	}
	
	return nil;
}

#pragma mark QIDSPage 
-(void)qidsQuestionPage:(EXQIDSQuestionPage*)qPage didChangeValueOfQuestionNumber:(NSInteger)qNumber toValue:(NSInteger)value{
	
	[self.activeQIDSSubmission setQuestionResponse:@(value) forQuesitonNumber:qNumber];
	
	NSInteger maxQPPage = ((deviceIsPad)?IPAD_MAXQUESTIONS_PER_PAGE:IPHONE_MAXQUESTIONS_PER_PAGE);
	//if last question in sheet, then autoflip
	NSInteger thisPage =(int)floor(qNumber/(double)maxQPPage);
	NSInteger zeroIndexedFromPageStart = qNumber - thisPage* maxQPPage;
	if (zeroIndexedFromPageStart +1 == [self questionsOnPage:thisPage]){
		
		BOOL shouldAutoFlip = TRUE;
		for (int qChecker = thisPage*maxQPPage; qChecker <= qNumber; qChecker ++){
			if ([self.activeQIDSSubmission questionResponseForQuesitonNumber:qChecker] == nil)
				shouldAutoFlip = FALSE;
		}
		 if (shouldAutoFlip){
			[self flipToNextPage];
		 }
	}
		
}

#pragma QIDSSubmitPage 
-(void)qidsNoteSubmitPage:(EXQIDSNoteSubmitPage*)qPage didUpdateNoteToText:(NSString*)noteText{
	[self.activeQIDSSubmission setNote:noteText];
}

-(void)qidsNoteSubmitPageDidSubmitWithPage:(EXQIDSNoteSubmitPage*)qPage{
	[self.activeQIDSSubmission.managedObjectContext saveOnlySelfWithCompletion:^(BOOL success, NSError *error){
		if (error)
			NSLog(@"Save err for qids %@",[error description]);
	}];
	
	if ([self.qidsManager submitQIDSAsComplete:self.activeQIDSSubmission]){
		[self dismissForm];
	}
}

@end
