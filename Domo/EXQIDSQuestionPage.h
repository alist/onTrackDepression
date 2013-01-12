//
//  EXQIDSQuestionPage.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXQIDSSubmission.h"
#import "EXQIDSManager.h"
#import "MGBox.h"

#define IPAD_MAXQUESTIONS_PER_PAGE 2
#define IPHONE_MAXQUESTIONS_PER_PAGE 1

#define IPHONE_TOP_MARGIN 50
#define IPAD_TOP_MARGIN 80
#define QUESTION_SPACING 30

@class EXQIDSQuestionPage;

@protocol EXQIDSQuestionPageDelegate <NSObject>

//qnumbers are relative to total count of q numbers in form
-(void)QIDSQuestionPage:(EXQIDSQuestionPage*)qPage didChangeValueOfQuestionNumber:(NSInteger)qNumber;
@end

@interface EXQIDSQuestionPage : UIView

@property (nonatomic, weak) id<EXQIDSQuestionPageDelegate> delegate;

@property (nonatomic, strong) MGBox *	primaryQTable;
@property (nonatomic, strong) UIFont *	headerFont;
@property (nonatomic, assign) CGSize	rowSize;


@property (nonatomic, assign) NSInteger	pageNumber;
/*
 [{  prompt: NSString_PromptQ0, currentResponse: Integer, values: [NSString_Answer0,NSString_Answer1, etc.]  },Qetc...]
 
 currentResponse indicates which values have already been checked off. 
 */
@property (nonatomic, strong) NSArray *	questionValues;

/*
 Set this if you want to display some text in the header of the form page.
 */
@property (nonatomic, strong) NSString*	formInfoHeaderText;

/*
 Corner text useful for conveying create date of form.
 */
@property (nonatomic, strong) NSString*	formInfoFooterCornerText;

/*
 Just pass the QIDS, the qids manager, page #, and have a fully-updated view. No nead to call update.
 */
-(void) updateViewWithQIDSSubmission:(EXQIDSSubmission*)submission qidsManager:(EXQIDSManager*)qidsManager pageNumber:(NSInteger)pageNumber;

/*
 hopefully only ever need to call this once!
 this page should be reused.
 */
-(id)initWithDelegate:(id<EXQIDSQuestionPageDelegate>) delegate frame:(CGRect)frame;

/*
 Set question range, set questionValues, then call to draw out the UI.
 */
-(void) updatePageUI;

/*
 Call this before reusing the page to clear all its properties.
 */
-(void) prepareForReuse;

/*
 Used internally to generate boxes to display on screen.
 */
-(MGBox*) generateQuestionBoxWithTitle:(NSString*)title qNumber:(NSInteger)qNumber responseValues:(NSArray*)responseVals;

@end
