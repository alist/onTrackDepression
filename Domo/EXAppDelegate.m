//
//  EXAppDelegate.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXAppDelegate.h"

@interface EXAppDelegate ()
-(EXAuthor*) generateLocalUser;
@end

@implementation EXAppDelegate

@synthesize navSideBarPad, navTabBarPod;
@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize authorForCurrentUser = _authorForCurrentUser, userComManager,qidsManager;

@synthesize trackVC, analyzeVC, improveVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    static NSString * storeName = @"onTrack-depression.sqlite";
	//	[MagicalRecord setupCoreDataStackWithiCloudContainer:@"A7426L9B95.com.exomachina.domodepression.ubiquitycoredata" localStoreNamed:storeName];
    
	#if DEV_STATE_RESET == 1
    NSURL *url = [NSPersistentStore MR_urlForStoreName:storeName];
	NSError * deleteErr = nil;
    [[NSFileManager new] removeItemAtURL:url error:&deleteErr];
	if (deleteErr)
		NSLog(@"db didn't exist or something %@",deleteErr);
	#endif
    
	[MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:storeName];
	self.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
	
	self.qidsManager = [[EXQIDSManager alloc] init];
	#if DEV_STATE_RESET == 1
	#if DEV_GEN_DATA == 1
	[self.qidsManager generateDataSetForAuthor:self.authorForCurrentUser];
	#endif
	#endif
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self.userComManager = [EXUserComManager sharedUserComManager];
	[self.userComManager setAuthor:	self.authorForCurrentUser];
	
	self.trackVC	= [[EXTrackVC alloc] init];
	[self.trackVC setQidsManager:qidsManager];
	self.analyzeVC	= [[EXReviewVC alloc] init];
	self.improveVC	= [[EXImproveVC alloc] init];
	
	UINavigationController * trackNavVC = [[UINavigationController alloc] initWithRootViewController:self.trackVC];
	UINavigationController * analyzeNavVC = [[UINavigationController alloc] initWithRootViewController:self.analyzeVC];
	
	[[trackNavVC navigationBar] setTintColor:[UIColor colorWithRed:1 green:0 blue:.3 alpha:1]];
	[[analyzeNavVC navigationBar] setTintColor:[UIColor colorWithRed:1 green:0 blue:.3 alpha:1]];
	
	NSArray * VCs = @[trackNavVC, analyzeNavVC];
	
	
	if (deviceIsPad){
		self.navSideBarPad	= [[CKSideBarController alloc] init];
		[self.navSideBarPad setViewControllers:VCs];
		[self.window setRootViewController:self.navSideBarPad];

		[self.navSideBarPad setSelectedIndex:1];

	}else{
		self.navTabBarPod	= [[UITabBarController alloc] init];
		[self.navTabBarPod setViewControllers:VCs];		
		[self.window setRootViewController:self.navTabBarPod];
	}
	
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - user data
-(EXAuthor*)authorForCurrentUser{
	if (_authorForCurrentUser != nil && [NSThread isMainThread]){
		return _authorForCurrentUser;
	}else {
		EXAuthor * author = nil;
		NSString* userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"localAuthorUserID"];
		if (userID >0 ){
			NSArray * authors = [self.managedObjectContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"EXAuthor"] error:nil]; //[EXAuthor objectsWithPredicate:[NSPredicate predicateWithFormat:@"authorID == %@", userID]];
			
			if ([authors count] > 0){
				author = [authors objectAtIndex:0];
			}else{
				author = [self generateLocalUser];
			}
		}else{
			author = [self generateLocalUser];
		}
		
		if (_authorForCurrentUser == nil && [NSThread isMainThread]){
			_authorForCurrentUser = author;
			[self setAuthorForCurrentUser:author];
			return _authorForCurrentUser;
		}else{
			return author;
		}
	}
}

-(EXAuthor*) generateLocalUser{
	NSString* userID = @"101";
	
	EXAuthor * newAuthor = [EXAuthor createInContext:[NSManagedObjectContext contextForCurrentThread]];
	
	[newAuthor setAuthorID:userID];
	[newAuthor setDisplayName:@"newAuthor 101"];
	[newAuthor setQidsSpacingInterval:self.qidsManager.formSpacingInterval];
	[newAuthor setIsOnboarding:@(TRUE)];
	
	[[NSUserDefaults standardUserDefaults] setValue:[newAuthor authorID] forKey:@"localAuthorUserID"];
	
	[self.managedObjectContext saveOnlySelfWithCompletion:nil];
	
	return newAuthor;
}




#pragma mark - app junk

- (void)applicationWillResignActive:(UIApplication *)application{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[[self managedObjectContext] saveToPersistentStoreAndWait];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
}

- (void)applicationWillTerminate:(UIApplication *)application{
	[MagicalRecord cleanUp];
}

@end
