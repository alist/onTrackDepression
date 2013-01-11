//
//  EXTabVC.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXTabVC.h"

@implementation EXTabVC
@synthesize objectContext;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)context{
	if (self = [super initWithNibName:nil bundle:nil]){
		self.objectContext = context;
		[self setTitle:NSLocalizedString(@"EXTab", @"holder value")];
	}
	return self;
	
}


-(void)viewDidLoad{
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greyFloral.png"]]];
	
	
	[super viewDidLoad];
}

@end
