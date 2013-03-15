//
//  EXSingleQIDSInspectorVC.m
//  onTrack-Depression
//
//  Created by Alexander List on 3/14/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXSingleQIDSInspectorVC.h"

@interface EXSingleQIDSInspectorVC ()

@end

@implementation EXSingleQIDSInspectorVC


-(void) updateWithQIDSSubmission: (EXQIDSSubmission*)submission{
	NSNumberFormatter * qidsValueNumberFormatter = [NSNumberFormatter new];
	[qidsValueNumberFormatter setMaximumFractionDigits:0];
	[self.qidsValueLabel setText:[qidsValueNumberFormatter stringFromNumber:[submission qidsValue]]];
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
	[super viewDidUnload];
}
@end
