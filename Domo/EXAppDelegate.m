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
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize authorForCurrentUser = _authorForCurrentUser, userComManager;

@synthesize trackVC, analyzeVC, improveVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self.userComManager = [EXUserComManager sharedUserComManager];
	[self.userComManager setAuthor:	self.authorForCurrentUser];
	
	self.trackVC = [[EXTrackVC alloc] initWithManagedObjectContext:self.managedObjectContext];
	self.analyzeVC = [[EXAnalyzeVC alloc] init];
	self.improveVC = [[EXImproveVC alloc] init];
	
	
	NSArray * VCs = @[self.trackVC, self.analyzeVC,self.improveVC];
	
	if (deviceIsPad){
		self.navSideBarPad	= [[CKSideBarController alloc] init];
		[self.navSideBarPad setViewControllers:VCs];
		[self.window setRootViewController:self.navSideBarPad];

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
	
	EXAuthor * newAuthor = [[EXAuthor alloc] initWithEntity:[NSEntityDescription entityForName:@"EXAuthor" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
	
	[newAuthor setAuthorID:userID];
	[newAuthor setDisplayName:@"newAuthor 101"];
	[newAuthor setIsOnboarding:@(TRUE)];
	
	[[NSUserDefaults standardUserDefaults] setValue:[newAuthor authorID] forKey:@"localAuthorUserID"];
	
	[self.managedObjectContext save:nil];
	return newAuthor;
}




#pragma mark - app junk

-(void) dealloc{
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Saves changes in the application's managed object context before the application terminates.
	[self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Feel_Better__Depression" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Feel_Better__Depression.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end