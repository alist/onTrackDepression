//
//  EXTabVC.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXTabVC : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *			objectContext;

-(id)initWithManagedObjectContext:(NSManagedObjectContext*)context;

@end
