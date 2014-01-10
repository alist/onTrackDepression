//
//  EXDomoConstants.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//




#define DEV_STATE_RESET 1
#define DEV_GEN_DATA  1

#ifdef RELEASE
#ifdef DEV_STATE_RESET
#error "reset mode defined: DEV_STATE_RESET"
#endif
#ifdef DEV_GEN_DATA 
#error "mute mode defined: DEV_GEN_DATA "
#endif
#endif

//for question display
#define IPAD_MAXQUESTIONS_PER_PAGE 2
#define IPHONE_MAXQUESTIONS_PER_PAGE 1

#define IPHONE_TOP_MARGIN 40
#define IPAD_TOP_MARGIN 80
#define QUESTION_SPACING 30
#define EXTRA_IOS7_SPACING 10


#define deviceIsPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define ArrayHasItems(array) (array != nil && [array count] > 0)
#define StringHasText(string) (string != nil && [string length] > 0)
#define SetHasItems(set) (set != nil && [set count] > 0)

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

static NSString * const newQIDSSubmittedNotification = @"newQIDSSubmittedNotification";

//vars
typedef enum{
	domoAppTabNone = 0,
	domoAppTabTrack,
	domoAppTabReview,
	domoAppTabImprove,
	domoAppTabSupport
}domoAppTab;


#define MR_SHORTHAND
#import "CoreData+MagicalRecord.h"
#import "UIViewAdditions+EX.h"
