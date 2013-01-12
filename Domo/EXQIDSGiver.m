//
//  EXQIDSGiver.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSGiver.h"


@implementation EXQIDSGiver
@synthesize qidsManager;


#pragma mark - delegation
- (NSUInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView{
		
	return self.pageCount;
}

-(NSInteger) pageCount{
	double questionPageCount	= ceil([[[self qidsManager] questions] count]/ ((double)(deviceIsPad)?IPAD_MAXQUESTIONS_PER_PAGE:IPHONE_MAXQUESTIONS_PER_PAGE));
	NSInteger totalCount		= (int)questionPageCount + 1; //1 page for comments and done button

	return totalCount;
}

- (UIView *)pagingScrollView:(MHPagingScrollView *)pagingScrollView pageForIndex:(NSUInteger)index{
	
	UIView * page = nil;
	
	if (self.pageCount < index +1 ){
		
		EXQIDSQuestionPage * qidsPage = nil;
		
		UIView * dequed = [pagingScrollView dequeueReusablePage];
		if ([dequed isKindOfClass:[EXQIDSQuestionPage class]]){
			qidsPage  = (EXQIDSQuestionPage*)qidsPage;
		}
		
	}
	
	return nil;
}

@end
