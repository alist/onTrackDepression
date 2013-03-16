//
//  EXSingleQIDSInspectorVC.m
//  onTrack-Depression
//
//  Created by Alexander List on 3/14/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

const CGSize defaultQIDSInspectorSize = {170, 130};

#import "EXSingleQIDSInspectorVC.h"

@interface EXSingleQIDSInspectorVC ()

@end

@implementation EXSingleQIDSInspectorVC


-(void) updateWithQIDSSubmission: (EXQIDSSubmission*)submission{
	NSNumberFormatter * qidsValueNumberFormatter = [NSNumberFormatter new];
	[qidsValueNumberFormatter setMaximumFractionDigits:0];
	[self.qidsValueLabel setText:[qidsValueNumberFormatter stringFromNumber:[submission qidsValue]]];
	
	NSString * severityString = nil;
	NSInteger qidsValue = [[submission qidsValue] integerValue];
	
	if (qidsValue < 6){
		severityString = NSLocalizedString(@"NON-CLINICAL\nDEPRESSION", @"string for depression severity label");
	}else if (qidsValue < 11){
		severityString = NSLocalizedString(@"MILD\nDEPRESSION", @"string for depression severity label");
	}else if (qidsValue < 16){
		severityString = NSLocalizedString(@"MODERATE\nDEPRESSION", @"string for depression severity label");
	}else if (qidsValue < 21){
		severityString = NSLocalizedString(@"SEVERE\nDEPRESSION", @"string for depression severity label");
	}else{
		severityString = NSLocalizedString(@"MOST SEVERE\nDEPRESSION", @"string for depression severity label");
	}
	[self.qidsSeverityLabel setText:severityString];
	
	NSString * feedbackString = [submission note];
	[self.qidsSubmissionFeedbackLabel setText:feedbackString];
	
	CGSize viewSize = defaultQIDSInspectorSize;
	
	if ([feedbackString length] <= 0){
		self.qidsFeedbackQuotesLabel.hidden = TRUE;
		self.qidsSubmissionFeedbackLabel.hidden = TRUE;
	}else{
		self.qidsFeedbackQuotesLabel.hidden = FALSE;
		self.qidsSubmissionFeedbackLabel.hidden = FALSE;
		
		CGSize feedbackSize = [feedbackString sizeWithFont:self.qidsSubmissionFeedbackLabel.font constrainedToSize:CGSizeMake(self.qidsSubmissionFeedbackLabel.width, 400) lineBreakMode:NSLineBreakByWordWrapping];
		
		feedbackSize.width = self.qidsSubmissionFeedbackLabel.width;
		[self.qidsSubmissionFeedbackLabel setSize:feedbackSize];
		
		viewSize.height += feedbackSize.height + 10;
	}
	
	self.view.size = viewSize;
	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lightpaperfibers.png"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setQidsValueLabel:nil];
	[self setQidsSeverityLabel:nil];
	[self setQidsSubmissionFeedbackLabel:nil];
	[self setQidsMaxValueLabel:nil];
	[self setQidsFeedbackQuotesLabel:nil];
	[super viewDidUnload];
}
@end
