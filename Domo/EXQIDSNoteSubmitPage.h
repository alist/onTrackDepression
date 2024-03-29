//
//  EXQIDSNoteSubmitPage.h
//  Domo Depression
//
//  Created by Alexander List on 1/13/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXQIDSSubmission.h"
#import "EXQIDSManager.h"
#import "MGBox.h"
#import "MGTableBoxStyled.h"
#import "MGButton.h"



@class EXQIDSNoteSubmitPage;

@protocol EXQIDSNoteSubmitPageDelegate <NSObject>

-(void)qidsNoteSubmitPage:(EXQIDSNoteSubmitPage*)qPage didUpdateNoteToText:(NSString*)noteText;

-(void)qidsNoteSubmitPageDidSubmitWithPage:(EXQIDSNoteSubmitPage*)qPage;
@end



@interface EXQIDSNoteSubmitPage : UIView <UITextViewDelegate>
@property (nonatomic, weak) id<EXQIDSNoteSubmitPageDelegate> delegate;

@property (nonatomic, strong) MGBox *	primaryQTable;
@property (nonatomic, strong) UIFont *	headerFont;
@property (nonatomic, strong) UIFont *	noteFont;
@property (nonatomic, assign) CGSize	rowSize;
@property (nonatomic, assign) CGSize	noteEntrySize;

//the button
@property (nonatomic, strong) MGButton * submitButtonBox;

//the note box
@property (nonatomic, strong) MGTableBoxStyled* noteBox;

@property (nonatomic, strong) UITextView * noteEntryTextView;

@property (nonatomic, strong) UILabel * completionNoticeLabel;

//this page #
@property (nonatomic, assign) NSInteger	pageNumber;

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
-(void) updateViewWithQIDSSubmission:(EXQIDSSubmission*)submission qidsManager:(EXQIDSManager*)qidsManager pageNumber:(NSInteger)pageNumber ;

/*
 hopefully only ever need to call this once!
 this page should be reused.
 */
-(id)initWithDelegate:(id<EXQIDSNoteSubmitPageDelegate>) delegate frame:(CGRect)frame;

/*
 Set question range, set questionValues, then call to draw out the UI.
 */
-(void) updatePageUI:(BOOL)animate;
/*
 Call this before reusing the page to clear all its properties.
 */
-(void) prepareForReuse;


@end
