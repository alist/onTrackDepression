//
//  EXSingleQIDSInspectorVC.m
//  onTrack-Depression
//
//  Created by Alexander List on 3/14/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXSingleQIDSInspectorVC.h"

@interface EXSingleQIDSInspectorVC ()

@end

@implementation EXSingleQIDSInspectorVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lightpaperfibers.png"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
