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
#import "EXAnalyzeVC.h"
#import "EXImproveVC.h"
#import "MagicalRecord.h"
#import "EXAuthor.h"
#import "EXUserComManager.h"

@interface EXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic)	UITabBarController *	navTabBarPod; //possibly JBTabBarController later
@property (strong, nonatomic)	CKSideBarController *	navSideBarPad;
@property (strong, nonatomic)	EXTrackVC *				trackVC;
@property (strong, nonatomic)	EXAnalyzeVC *			analyzeVC;
@property (strong, nonatomic)	EXImproveVC *			improveVC;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, strong) EXAuthor* authorForCurrentUser;
@property (nonatomic, strong) EXUserComManager * userComManager;
@end
