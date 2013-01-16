//
//  EXAppDelegate.h
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKSideBarController.h"
#import "EXTrackVC.h"
#import "EXReviewVC.h"
#import "EXImproveVC.h"
#import "MagicalRecord.h"
#import "EXAuthor.h"
#import "EXUserComManager.h"
#import "EXQIDSManager.h"

@interface EXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic)	UITabBarController *	navTabBarPod; //possibly JBTabBarController later
@property (strong, nonatomic)	CKSideBarController *	navSideBarPad;
@property (strong, nonatomic)	EXTrackVC *				trackVC;
@property (strong, nonatomic)	EXReviewVC *			analyzeVC;
@property (strong, nonatomic)	EXImproveVC *			improveVC;


@property (nonatomic, strong) EXAuthor* authorForCurrentUser;
@property (nonatomic, strong) EXUserComManager * userComManager;
@property (nonatomic, strong) EXQIDSManager * qidsManager;
@end
