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
			self.noteEntrySize = CGSizeMake(self.rowSize.width, 100);
		}else{
			self.rowSize = (CGSize){304, 40};
			self.noteEntrySize = CGSizeMake(self.rowSize.width, 50);
		}
		
		double tableHeight = (deviceIsPad)? 580 : 400;
		self.primaryQTable = [MGBox boxWithSize:CGSizeMake(self.width, tableHeight)];
		double margin = ceil( (self.size.width- self.primaryQTable.width)/2);
		
		double startY = (deviceIsPad)? IPAD_TOP_MARGIN-QUESTION_SPACING : IPHONE_TOP_MARGIN-QUESTION_SPACING;
		[self.primaryQTable setOrigin:CGPointMake(margin, startY)];
		[self.primaryQTable setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin];
		[self addSubview:self.primaryQTable];
	}
	return self;
}

-(void) updateViewWithQIDSSubmission:(EXQIDSSubmission*)submission qidsManager:(EXQIDSManager*)qidsManager pageNumber:(NSInteger)tPageNumber{
	
	[self prepareForReuse];
	
	self.pageNumber = tPageNumber;
	
	
	//text input box
	MGTableBoxStyled *noteBox = [MGTableBoxStyled box];
	[noteBox setTopMargin:30];
	[noteBox setRasterize:TRUE];
	
	double margin = ceil( (self.size.width- self.rowSize.width)/2);
	[noteBox setLeftMargin:margin];
	
	MGLineStyled *head = [MGLineStyled lineWithLeft:NSLocalizedString(@"Standout causes?", @"qids form note-entry prompt") right:nil size:self.rowSize];
	head.font = self.headerFont;
	
	[noteBox.topLines addObject:head];
	
	UITextView * textInput = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, noteEntrySize.width, noteEntrySize.height)];
	[textInput setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
	[textInput setFont:self.noteFont];
	[textInput setTextColor:[UIColor colorWithWhite:.05 alpha:1]];
//	[textInput setContentInset:UIEdgeInsetsMake(0, 10, 10, 10)];
	[textInput setText:@"hello test!"];
	
	__weak MGLineStyled *noteEntryBox = [MGLineStyled lineWithSize:textInput.size];
	noteEntryBox.asyncLayoutOnce = ^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[noteEntryBox addSubview:textInput];
		});
	};
	
	[noteBox.middleLines addObject:noteEntryBox];
	
	[self.primaryQTable.boxes addObject:noteBox];
	
	//submit box
	MGButton * submitButtonBox = [MGButton buttonWithType:UIButtonTypeCustom];
	[submitButtonBox setFrame:CGRectMake(0, 0, self.rowSize.width, self.rowSize.height *3)];
	[submitButtonBox setTopMargin:50];
	[submitButtonBox setTitle:NSLocalizedString(@"Complete!", @"finish button on last page of form-fill-out part of the app") forState:UIControlStateNormal];
	[submitButtonBox setTitleColor:[UIColor colorWithWhite:.5 alpha:.5] forState:UIControlStateNormal];
	[submitButtonBox setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateHighlighted];
	[submitButtonBox.layer setBorderWidth:1];
	[submitButtonBox setLeftMargin:margin];
//	[submitButton addTarget:self action:@selector(finishLaterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self.primaryQTable.boxes addObject:submitButtonBox];
	
	self.formInfoFooterCornerText = [NSDateFormatter localizedStringFromDate:[submission officialDate] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
	
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




@end
