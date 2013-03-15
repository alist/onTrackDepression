//
//  EXSingleQIDSInspectorVC.h
//  onTrack-Depression
//
//  Created by Alexander List on 3/14/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXQIDSSubmission.h"

@interface EXSingleQIDSInspectorVC : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *qidsValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *qidsMaxValueLabel;

@property (strong, nonatomic) IBOutlet UILabel *qidsSeverityLabel;
@property (strong, nonatomic) IBOutlet UILabel *qidsSubmissionFeedbackLabel;

-(void) updateWithQIDSSubmission: (EXQIDSSubmission*)submission;

@end
