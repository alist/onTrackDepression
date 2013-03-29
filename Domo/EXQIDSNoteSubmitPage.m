//
//  EXQIDSNoteSubmitPage.m
//  Domo Depression
//
//  Created by Alexander List on 1/13/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSNoteSubmitPage.h"
#import "MGLineStyled.h"
#import "MGTableBoxStyled.h"
#import "MGButton.h"

@interface EXQIDSNoteSubmitPage ()
@property (nonatomic, strong) UITextView * displayedTextInput;

@end

@implementation EXQIDSNoteSubmitPage
@synthesize pageNumber, formInfoHeaderText,formInfoFooterCornerText;
@synthesize primaryQTable;
@synthesize rowSize,noteEntrySize, headerFont,noteFont;
@synthesize delegate;

-(id)initWithDelegate:(id<EXQIDSNoteSubmitPageDelegate>) tDelegate frame:(CGRect)frame{
	if (self =[super initWithFrame:frame]){
		[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		
		self.delegate = tDelegate;
		
		self.headerFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
		self.noteFont	= [UIFont fontWithName:@"HelveticaNeue" size:15];
		
		[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"crisp_paper_ruffles"]]];
		
		if (deviceIsPad){
			self.rowSize = (CGSize){400, 50};
			self.noteEntrySize = CGSizeMake(self.rowSize.width, 60);
		}else{
			self.rowSize = (CGSize){304, 40};
			self.noteEntrySize = CGSizeMake(self.rowSize.width, 50);
		}
		
		double tableHeight = (deviceIsPad)? 580 : 400;
		double tableWidth = self.width;
		self.primaryQTable = [MGBox boxWithSize:CGSizeMake(tableWidth, tableHeight)];
		double margin = ceil( (self.size.width- self.primaryQTable.width)/2);
		
		double startY = (deviceIsPad)? IPAD_TOP_MARGIN-QUESTION_SPACING : IPHONE_TOP_MARGIN-QUESTION_SPACING;
		[self.primaryQTable setOrigin:CGPointMake(margin, startY)];
		[self.primaryQTable setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin];
		[self addSubview:self.primaryQTable];
	}
	return self;
}

-(MGTableBoxStyled*) noteBox{
	
	if (_noteBox == nil){
		//text input box
		MGTableBoxStyled *theNoteBox = [MGTableBoxStyled box];
		[theNoteBox setTopMargin:30];
		[theNoteBox setLeftPadding:0];
		[theNoteBox setRasterize:TRUE];
		 
		MGLineStyled *head = [MGLineStyled lineWithLeft:NSLocalizedString(@"Thoughts to remember?", @"qids form note-entry prompt") right:nil size:self.rowSize];
		head.font = self.headerFont;

		[theNoteBox.topLines addObject:head];

		UITextView * textInput = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, noteEntrySize.width, noteEntrySize.height)];
		[textInput setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
		[textInput setFont:self.noteFont];
		[textInput setTextColor:[UIColor colorWithWhite:.05 alpha:1]];
		[textInput setDelegate:self];
		self.displayedTextInput = textInput;
		
		__weak MGLineStyled *noteEntryBox = [MGLineStyled lineWithSize:textInput.size];
		noteEntryBox.asyncLayoutOnce = ^{
		dispatch_async(dispatch_get_main_queue(), ^{
		[noteEntryBox addSubview:textInput];
		});
		};

		[theNoteBox.middleLines addObject:noteEntryBox];

		_noteBox = theNoteBox;
	}

	return _noteBox;
}

-(void) updateViewWithQIDSSubmission:(EXQIDSSubmission*)submission qidsManager:(EXQIDSManager*)qidsManager pageNumber:(NSInteger)tPageNumber{
	
	[self prepareForReuse];
	
	self.pageNumber = tPageNumber;
		 	
	double promptWidth = ceil(self.primaryQTable.width * .9);
	double promptMargin = ceil( (self.primaryQTable.width- promptWidth)/2);
	
	MGLineStyled * submitPromptLabel = [MGLineStyled multilineWithText:qidsManager.completionSubmissionPrompt font:self.headerFont width:promptWidth padding:UIEdgeInsetsMake(10, 10, 10, 10)];
	[submitPromptLabel setBackgroundColor:[UIColor clearColor]];
	[submitPromptLabel setLeftMargin:promptMargin];
	[submitPromptLabel setLeftItemsTextAlignment:NSTextAlignmentCenter];
	
	[self.primaryQTable.boxes addObject:submitPromptLabel];

	MGBox * theNoteBox = [self noteBox];
	[self.displayedTextInput setText:[submission note]];
	double margin = ceil( (self.size.width- self.rowSize.width)/2);
	[theNoteBox setLeftMargin:margin];
	[self.primaryQTable.boxes addObject:theNoteBox];
		
	//submit box
	UIImage * submissionButtonEnabledImage = [UIImage imageNamed:@"submissionButton-enabled.png"];
	UIImage * submissionButtonDisabledImage = [UIImage imageNamed:@"submissionButton-disabled.png"];
	double submitMargin = ceil( (self.size.width- submissionButtonEnabledImage.size.width)/2);
	self.submitButtonBox = [MGButton buttonWithType:UIButtonTypeCustom];
	CGRect buttonRect = CGRectZero;
	buttonRect.size = submissionButtonEnabledImage.size;
	[self.submitButtonBox setFrame:buttonRect];
	[self.submitButtonBox setTopMargin:50];
	[self.submitButtonBox setTitle:NSLocalizedString(@"All done!", @"finish button on last page of form-fill-out part of the app") forState:UIControlStateNormal];
	[self.submitButtonBox setTitle:NSLocalizedString(@"Not quite done!", @"finish button on last page of form-fill-out part of the app when user didn't finish") forState:UIControlStateDisabled];
	[self.submitButtonBox setTitleColor:[UIColor colorWithWhite:.4 alpha:.9] forState:UIControlStateNormal];
	[self.submitButtonBox setTitleColor:[UIColor colorWithWhite:.5 alpha:.5] forState:UIControlStateDisabled];
	[self.submitButtonBox setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateHighlighted];
	[self.submitButtonBox setBackgroundImage:submissionButtonEnabledImage forState:UIControlStateNormal];
	[self.submitButtonBox setBackgroundImage:submissionButtonDisabledImage forState:UIControlStateHighlighted];
	[self.submitButtonBox setBackgroundImage:submissionButtonDisabledImage forState:UIControlStateDisabled];
	[self.submitButtonBox setLeftMargin:submitMargin];
	[self.submitButtonBox addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.submitButtonBox setEnabled:[submission isComplete]];
	
	[self.primaryQTable.boxes addObject:self.submitButtonBox];
	
	self.formInfoFooterCornerText = [NSDateFormatter localizedStringFromDate:[submission dueDate] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
	
	if (self.pageNumber == 0){
		self.formInfoHeaderText = [qidsManager title];
	}
	
	[self updatePageUI:FALSE];
}

-(void) updatePageUI:(BOOL)animate{
	[self.primaryQTable layoutWithSpeed:((animate)?.5: 0) completion:nil];
	//and then do traditional labels, if we include them.
}

-(void) prepareForReuse{
	[self.primaryQTable.boxes removeAllObjects];
	self.formInfoHeaderText = nil;
	self.formInfoFooterCornerText = nil;
}

#pragma mark - interactions
-(void) submitPressed:(id)sender{
	[self.delegate qidsNoteSubmitPageDidSubmitWithPage:self];
}

- (void)textViewDidChange:(UITextView *)textView{
	[self.delegate qidsNoteSubmitPage:self didUpdateNoteToText:textView.text];
}
@end
