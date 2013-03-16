//
//  EXTabVC.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXTabVC.h"
#import "EXUserComManager.h"

@implementation EXTabVC{
}
@synthesize rowSize, headerFont;
@synthesize appearedOnce;

#define IPHONE_TABLES_GRID_PORTRAIT     (CGSize){320, 0}
#define IPHONE_TABLES_GRID_LANDSCAPE    (CGSize){320, 0}
#define IPAD_TABLES_GRID_PORTRAIT       (CGSize){680, 0}
#define IPAD_TABLES_GRID_LANDSCAPE		(CGSize){930, 0}


#pragma mark - subclass

-(id)initWithPresentedAppTab:(domoAppTab)presentedTab{
	if (self = [super initWithNibName:nil bundle:nil]){
		[self setTitle:NSLocalizedString(@"EXTab", @"holder value")];
		
		self.headerFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
		self.rowSize = (CGSize){304, 44};
		
		self.presentedTab = presentedTab;
		
		self.appearedOnce = FALSE;
		
	}
	return self;	
}

-(id)init{
	if (self = [self initWithPresentedAppTab:domoAppTabNone]){
		
	}
	return self;

}


-(void)viewDidLoad{
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greyfloral"]]];
	
//	CGSize loadSize = self.view.bounds.size;
//	self.scroller = [MGScrollView scrollerWithSize:loadSize];
//	[self.scroller setAutoresizingMask:UIViewAutoresizingNone];
//	// setup the main scroller (using a grid layout)
//	self.scroller.contentLayoutMode = MGLayoutGridStyle;
//	self.scroller.bottomPadding = 8;
//	[self.view addSubview:self.scroller];
	
	
//	CGSize tablesGridSize = deviceIsPad ? IPAD_TABLES_GRID_PORTRAIT: IPHONE_TABLES_GRID_PORTRAIT;
//	tablesGrid = [MGBox boxWithSize:tablesGridSize];
//	tablesGrid.contentLayoutMode = MGLayoutGridStyle;
//	[self.scroller.boxes addObject:tablesGrid];
	
	// the features table
//	self.primaryTable = [MGBox box];
//	[tablesGrid.boxes addObject:self.primaryTable];
//	self.primaryTable.sizingMode = MGResizingShrinkWrap;
//	
//	// the subsections table
//	self.detailTable = [MGBox box];
//	[tablesGrid.boxes addObject:self.detailTable];
//	self.detailTable.sizingMode = MGResizingShrinkWrap;
	
//	[self refreshGridContent];
	
}


//this code is from MGBoxDemo and seems to work to refresh size quanitites after first load of view (before the boxes could horrizontal scroll)
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (!appearedOnce){
		appearedOnce = TRUE;

		[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation
											   duration:1];
		[self didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
	}
}

#pragma mark rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)o {
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orient
                                         duration:(NSTimeInterval)duration {
////	
//	BOOL isPortrait = UIInterfaceOrientationIsPortrait(orient);
//	
//	tablesGrid.size = deviceIsPad ?
//	isPortrait? IPAD_TABLES_GRID_PORTRAIT : IPAD_TABLES_GRID_LANDSCAPE :
//	isPortrait? IPHONE_TABLES_GRID_PORTRAIT : IPHONE_TABLES_GRID_LANDSCAPE;
//	
//	//update the objects to displaay here
//	// relayout the sections
//	[self.scroller layoutWithSpeed:duration completion:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orient {
	//finished
}

#pragma mark - content
//-(void) refreshGridContent{
//	
//	[self refreshDetailContent:FALSE];
//	[self refreshPrimaryContent:FALSE];
//	
//
//	// animate
//	[self.scroller layoutWithSpeed:0.3 completion:nil];
//	
//	// scroll
//	if ([self.primaryTable.boxes count] > 0)
//		[self.scroller scrollToView:[self.primaryTable.boxes objectAtIndex:0] withMargin:8];
//}
//
//-(void) refreshDetailContent:(BOOL)layout{
//	[self.detailTable.boxes removeAllObjects];
//	
//	NSMutableArray * detailBoxes = [NSMutableArray array];
//	[detailBoxes addObjectsFromArray:[self detailBoxes]];
//	[self.detailTable.boxes addObjectsFromArray:detailBoxes];
//	
//	if (layout)
//		[self.detailTable layoutWithSpeed:0.3 completion:nil];
//}
//
//-(void) refreshPrimaryContent:(BOOL)layout{
//	[self.primaryTable.boxes removeAllObjects];
//	
//	NSMutableArray * primaryBoxes = [NSMutableArray array];
//	[primaryBoxes addObjectsFromArray:[self headerPrimaryMessageBoxes]];
//	[primaryBoxes addObjectsFromArray:[self primaryContentBoxes]];
//	[primaryBoxes addObjectsFromArray:[self footerPrimaryMessageBoxes]];
//	[self.primaryTable.boxes addObjectsFromArray:primaryBoxes];
//	
//	if (layout)
//		[self.primaryTable layoutWithSpeed:0.3 completion:nil];
//}
//
//-(NSArray*)	headerPrimaryMessageBoxes{
//	NSMutableArray * boxes = [NSMutableArray array];
//	for (NSDictionary * messageDict in[[EXUserComManager sharedUserComManager]  messagesForUIAppTab:self.presentedTab]){
//		[boxes addObject:[self boxFromMessageDict:messageDict]];
//	}
//	return boxes;
//}
//-(NSArray*)	footerPrimaryMessageBoxes{
//	return nil;
//}
//-(NSArray*)	primaryContentBoxes{
//	return nil;
//}
//-(NSArray*)	detailBoxes{
//	return nil;
//}

-(MGBox*)boxFromMessageDict:(NSDictionary*)dict{
	// make the section
	MGTableBoxStyled *section = MGTableBoxStyled.box;
	[section setBackgroundColor:[UIColor clearColor]];
	
	UIImageView * sourceImageView = nil;
	if ([dict objectForKey:@"imageURI"]){
		sourceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
		[sourceImageView setImage:[UIImage imageNamed:[dict objectForKey:@"imageURI"]]];
	}
	// header
	MGLineStyled *head = [MGLineStyled lineWithLeft:[dict valueForKey:@"title"] right:sourceImageView size:self.rowSize];
	[section.topLines addObject:head];
	head.font = self.headerFont;

	// stuff
	MGLineStyled *line = [MGLineStyled multilineWithText:[dict valueForKey:@"message"] font:nil width:rowSize.width padding:UIEdgeInsetsMake(16, 16, 16, 16)];
	[section.topLines addObject:line];
		
	return section;
}




@end
