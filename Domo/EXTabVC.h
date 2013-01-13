//
//  EXTabVC.h
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"

@interface EXTabVC : UIViewController
@property (nonatomic, assign) domoAppTab						presentedTab;

@property (nonatomic, strong) UIFont *							headerFont;
@property (nonatomic, assign) CGSize							rowSize;

@property (nonatomic, strong) MGScrollView *scroller;
@property (nonatomic, strong) MGBox *tablesGrid, *primaryTable, *detailTable;


//this one is called by subclass in implementation of initWithManagedObjectContext:.
-(id)initWithPresentedAppTab:(domoAppTab)presentedTab;

//this one is called by users of the class
-(id)init;

-(void)		refreshContent;

//these come from UserComManager
-(NSArray*)	headerPrimaryMessageBoxes;

//these come from app tab controller
-(NSArray*)	footerPrimaryMessageBoxes;

//these come from app tab controller
//-- eg, the FIQR display
-(NSArray*)	primaryContentBoxes;

//these come from UserComManager
//-- eg, the FIQR prompt box
-(NSArray*)	detailBoxes;
@end
