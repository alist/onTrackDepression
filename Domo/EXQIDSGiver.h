//
//  EXQIDSGiver.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXQIDSQuestionPage.h"
#import "EXQIDSSubmission.h"
#import "EXQIDSManager.h"
#import "MHPagingScrollView.h"

@interface EXQIDSGiver : UIViewController <MHPagingScrollViewDelegate,EXQIDSQuestionPageDelegate>
@property (nonatomic, strong) EXQIDSSubmission *	activeQIDSSubmission;
@property (nonatomic, strong) EXQIDSManager *		qidsManager;
@property (nonatomic, strong) MHPagingScrollView *	pagingView;

-(NSInteger) pageCount;

-(id) initWithQIDSManager:(EXQIDSManager *)manager submission:(EXQIDSSubmission*)submission;
@end
