//
//  EXTrackVC.h
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTabVC.h"
#import "EXQIDSGiver.h"

typedef enum{
	EXQuestionnaireTypeNone,
	EXQuestionnaireTypeQIDS
} EXQuestionnaireType;

@interface EXTrackVC : EXTabVC

@property (nonatomic, assign) EXQuestionnaireType				currentQuestionnaire;
@property (nonatomic, strong) EXQIDSGiver *						qidsGiver;
@property (nonatomic, strong) EXQIDSManager	*					qidsManager;

@end
