//
//  EXQIDSManager.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/5/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXQIDSManager.h"

@interface EXQIDSManager ()

@end

@implementation EXQIDSManager
@synthesize objectContext;
@synthesize questions, version,title, prompt;

-(id) initWithManagedObjectContext:(NSManagedObjectContext*)context{
	if (self=[super init]){
		self.objectContext = context;
		
		[self loadFormData];
	}
	return self;
}

-(void) loadFormData{
	NSDictionary *QIDSData = [[NSDictionary alloc]
							 initWithContentsOfFile:
							 [[NSBundle mainBundle] pathForResource:@"QIDS" ofType:@"plist"]];
	
	self.questions = [QIDSData valueForKey:@"questions"];
	self.version = [QIDSData valueForKey:@"version"];
	self.title = [QIDSData valueForKey:@"title"];
	self.prompt = [QIDSData valueForKey:@"prompt"];
	

}

@end
