//
//  EXQIDSQuestionPage.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSQuestionPage.h"
#import "MGLineStyled.h"
#import "MGTableBoxStyled.h"

@implementation EXQIDSQuestionPage
@synthesize pageNumber, formInfoHeaderText,formInfoFooterCornerText;
@synthesize primaryQTable;
@synthesize rowSize, headerFont;
@synthesize delegate;

-(id)initWithDelegate:(id<EXQIDSQuestionPageDelegate>) tDelegate frame:(CGRect)frame{
	if (self =[super initWithFrame:frame]){
		[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		
		self.delegate = tDelegate;
		
		self.headerFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
		
		[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"crisp_paper_ruffles"]]];
		

		if (deviceIsPad){
			self.rowSize = (CGSize){400, 50};
		}else{
			self.rowSize = (CGSize){304, 40};
		}
		
		double tableHeight = (deviceIsPad)? 580 : 400;
		self.primaryQTable = [MGBox boxWithSize:CGSizeMake(self.width, tableHeight)];
		double margin = ceil( (self.size.width- self.primaryQTable.width)/2);

		double startY = (deviceIsPad)? IPAD_TOP_MARGIN-QUESTION_SPACING : IPHONE_TOP_MARGIN-QUESTION_SPACING;
        if (IS_OS_7_OR_LATER){
            startY = startY + EXTRA_IOS7_SPACING;
        }

		[self.primaryQTable setOrigin:CGPointMake(margin, startY)];
		[self.primaryQTable setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin];
		[self addSubview:self.primaryQTable];
	}
	return self;
}


/* to become obsolete
-(MGBox*) _generateQuestionBoxWithTitle:(NSString*)title qNumber:(NSInteger)qNumber responseValues:(NSArray*)responseVals selectedValue:(NSNumber*)selectedValue{
	MGTableBoxStyled *newBox = [MGTableBoxStyled box];
	[newBox setTopMargin:30];
	[newBox setRasterize:TRUE];
	[newBox setTag:qNumber]; // debugging purposes
	
	double margin = ceil( (self.size.width- self.rowSize.width)/2);
	[newBox setLeftMargin:margin];
		
    // displays question
	MGLineStyled *head = [MGLineStyled lineWithLeft:title right:nil size:self.rowSize];
	[newBox.topLines addObject:head];
	head.font = self.headerFont;
	
    // displays response options
	for (NSString * response in responseVals){		
		UIImage * selectedImage = (selectedValue && [responseVals indexOfObject:response] == [selectedValue intValue])? [UIImage imageNamed:@"MNMRadioGroupSelected"]:[UIImage imageNamed:@"MNMRadioGroupUnselected"];
		
		MGLineStyled * responseLine = [MGLineStyled lineWithLeft:selectedImage multilineRight:response width:self.rowSize.width minHeight:self.rowSize.height];
		[responseLine setTopPadding:5];
		[responseLine setBottomPadding:5];
		[responseLine setRightItemsTextAlignment:NSTextAlignmentRight];
		[responseLine setTag:[responseVals indexOfObject:response]];//debug purposes
		[newBox.middleLines addObject:responseLine];
		
		__weak MGLineStyled *responseL = responseLine;
		responseLine.onTap = ^{
			[self tappedLine:responseL withQuestionNumber:qNumber];
		};
	}
	
	return newBox;
}
*/




//extended on Jan 2014 aho to support itemtype
-(MGBox*) _generateQuestionBoxWithTitle:(NSString*)title qNumber:(NSInteger)qNumber responses:(NSDictionary*)responses selectedValue:(NSNumber*)selectedValue{
	MGTableBoxStyled *newBox = [MGTableBoxStyled box];
	[newBox setTopMargin:30];
	[newBox setRasterize:TRUE];
	[newBox setTag:qNumber]; // debugging purposes
	
	double margin = ceil( (self.size.width- self.rowSize.width)/2);
	[newBox setLeftMargin:margin];
    
    // displays question
	MGLineStyled *head = [MGLineStyled lineWithLeft:title right:nil size:self.rowSize];
	[newBox.topLines addObject:head];
	head.font = self.headerFont;
	
    // displays response options
    //NSLog(@"responses --> %@", [responses description]);
    
    // will add support for other response actions in the future
    if ([[responses valueForKey:@"action"] isEqual:@"pickone"])
    {
    NSArray * choices = [responses valueForKey:@"choices"];
    
	for (NSDictionary * choice in choices){

		UIImage * selectedImage = (selectedValue && [choices indexOfObject:choice] == [selectedValue intValue])? [UIImage imageNamed:@"MNMRadioGroupSelected"]:[UIImage imageNamed:@"MNMRadioGroupUnselected"];
		NSString * choiceText = [choice valueForKey:@"choice"];
    
        NSLog(@"choiceText --> %@", [choiceText description]); //debug purposes
        
		MGLineStyled * responseLine = [MGLineStyled lineWithLeft:selectedImage multilineRight:choiceText width:self.rowSize.width minHeight:self.rowSize.height];
		[responseLine setTopPadding:5];
		[responseLine setBottomPadding:5];
		[responseLine setRightItemsTextAlignment:NSTextAlignmentRight];
		[responseLine setTag:[choices indexOfObject:choice]];//debug purposes
		[newBox.middleLines addObject:responseLine];
        
		__weak MGLineStyled *responseL = responseLine;
		responseLine.onTap = ^{
			[self tappedLine:responseL withQuestionNumber:qNumber withChoices:choices]; //added choice to tappedLine to allow translation from selectedValue to choice or code
		};
        
    };
	}
	
	return newBox;
}
 

-(void) updateViewWithQIDSSubmission:(EXQIDSSubmission*)submission qidsManager:(EXQIDSManager*)qidsManager pageNumber:(NSInteger)tPageNumber{
	
	[self prepareForReuse];
	
	self.pageNumber = tPageNumber;
	
	NSInteger questionsPerPage = (deviceIsPad)?IPAD_MAXQUESTIONS_PER_PAGE:IPHONE_MAXQUESTIONS_PER_PAGE;
	NSInteger startQNumber = tPageNumber*questionsPerPage;
	NSRange qRange = NSMakeRange(startQNumber, MIN(questionsPerPage, [[qidsManager questions] count]-startQNumber));
	
	NSArray * pageQuestions = [[qidsManager questions] subarrayWithRange:qRange];
    NSDictionary * formItemtypes = [qidsManager itemtypes]; // new
    
	
	for (NSDictionary * question in pageQuestions){
        
        
        // new code that uses the itemtypes specified in plist
        
        NSInteger qNumber=(startQNumber + [pageQuestions indexOfObject:question]);
        
        MGBox * box = [self _generateQuestionBoxWithTitle:[question valueForKey:@"prompt"]
                                                  qNumber:qNumber
                                       responses:[formItemtypes valueForKey:[question valueForKey:@"itemtype"]] //retrieves all possible responses for this one question
                                            selectedValue:[submission questionResponseForQuesitonNumber:[qidsManager.questions indexOfObject:question]]];
        
		[self.primaryQTable.boxes addObject:box];
	}
	
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

#pragma mark - interaction
-(void) tappedLine:(MGLineStyled*)lineBox withQuestionNumber:(NSInteger)qNumber withChoices:(NSArray *)choices{
	
	MGTableBoxStyled *qBox =	(MGTableBoxStyled*)[lineBox parentBox];
	NSInteger selectionValue = -1;
	if ([qBox isKindOfClass:[MGTableBoxStyled class]]){
		assert([qBox tag] == qNumber);
		selectionValue = [[qBox middleLines] indexOfObject:lineBox];
		
		for (MGLineStyled * line in [qBox middleLines]){
			[line.leftItems removeAllObjects];
			[line.leftItems addObject:[UIImage imageNamed:@"MNMRadioGroupUnselected"]];
		}
	}
	
	[lineBox.leftItems removeAllObjects];
	[lineBox.leftItems addObject:[UIImage imageNamed:@"MNMRadioGroupSelected"]];
	[self updatePageUI:TRUE];
    

    // translate selectionValue to code, for purpose of storage
    // NSLog(@"selectionValue --> %i", selectionValue);
    // NSLog(@"selectedCode --> %@", [[[choices objectAtIndex:selectionValue] valueForKey:@"code"] description]);
    //NSLog(@"selectedChoice --> %@", [[[choices objectAtIndex:selectionValue] valueForKey:@"choice"] description]);
    
    NSString *savedValue;
    if ([[[choices objectAtIndex:selectionValue] valueForKey:@"code"] description])
    {savedValue=[[[choices objectAtIndex:selectionValue] valueForKey:@"code"] description];}
    else
     {savedValue=[[[choices objectAtIndex:selectionValue] valueForKey:@"choice"] description];}
   
    // NSLog(@"savedValue --> %@", savedValue);
    
	[self.delegate qidsQuestionPage:self didChangeValueOfQuestionNumber:qNumber toValue:savedValue];
}

@end
