//
//  EXAnalyzeVC.m
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXAnalyzeVC.h"

@implementation EXAnalyzeVC

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
		[self setTitle:NSLocalizedString(@"Analyze", @"navigation bar title")];
	}
	return self;
}

-(void)viewDidLoad{
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greyFloral.png"]]];
	
	[super viewDidLoad];
}

@end
