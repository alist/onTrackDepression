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


#define deviceIsPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define ArrayHasItems(array) (array != nil && [array count] > 0)
#define StringHasText(string) (string != nil && [string length] > 0)
#define SetHasItems(set) (set != nil && [set count] > 0)

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
