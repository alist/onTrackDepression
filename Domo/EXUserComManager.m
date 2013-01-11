//
//  EXUserComManager.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXUserComManager.h"


@implementation EXUserComManager
@synthesize author;

+(EXUserComManager*) sharedUserComManager{
	static EXUserComManager* sharedManager;
	
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken, ^{
		sharedManager = [[EXUserComManager alloc] init];
	});	
	return sharedManager;
}


-(NSArray*) messagesForUIAppTab:(domoAppTab)appTab{
	NSMutableArray * messages = [NSMutableArray array];
	
	if ([[self.author isOnboarding] boolValue]){
		[messages addObjectsFromArray:[self onboardingMessagesForUIAppTab:appTab]];
	}
	
	if (appTab == domoAppTabTrack){
		//author progress
		
		//if missing a lot, leave message -- based on time interval
		//if on track, have domo message
	}
	
	return messages;
}

-(NSArray*) onboardingMessagesForUIAppTab:(domoAppTab)appTab{
	if (appTab == domoAppTabTrack){
		return @[@{@"message" : NSLocalizedString(@"You must measure and understand to improve.\nIt would be wise to begin with a diagnostic.",@"domo's onboard-track-tab message"), @"title":NSLocalizedString(@"Welcome to Domo",@"onboard-track-tab message header"), @"imageURI":@"domoMessage.png"}];
	}
	return nil;
}

@end
