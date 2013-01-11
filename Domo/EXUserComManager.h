//
//  EXUserComManager.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXAuthor.h"

/*
 Notificaiton:
 userinfo includes tab=EXDomoAppTab as NSNumber
 
 response:
 UI should call messagesForUIAppTab: if it's that tab
 */
static NSString * const EXUserComManagerChangedUIText = @"EXUserComManagerChangedUIText";

@interface EXUserComManager : NSObject

@property (nonatomic, strong) EXAuthor * author;

/*
 Returns array of dictionaries to display on EXTabVC subclass.
 each dictionary:
 headerText:
 stylizedText:
 isDomo:Bool
*/ 
-(NSArray*) messagesForUIAppTab:(domoAppTab)appTab;


//app delegate should set author on finished launching
+(EXUserComManager*) sharedUserComManager;

@end 