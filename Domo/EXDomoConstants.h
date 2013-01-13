//
//  EXDomoConstants.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#define deviceIsPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define ArrayHasItems(array) (array != nil && [array count] > 0)
#define StringHasText(string) (string != nil && [string length] > 0)
#define SetHasItems(set) (set != nil && [set count] > 0)


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
