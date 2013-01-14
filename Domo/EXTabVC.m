//
//  EXTabVC.m
//  Domo Depression
//
//  Created by Alexander List on 1/11/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import "EXTabVC.h"
#import "EXUserComManager.h"

@implementation EXTabVC
@synthesize rowSize, headerFont;
@synthesize scroller;
@synthesize tablesGrid, primaryTable, detailTable;

#define IPHONE_TABLES_GRID     (CGSize){320, 0}
#define IPAD_TABLES_GRID       (CGSize){624, 0}

#pragma mark - subclass

-(id)initWithPresentedAppTab:(domoAppTab)presentedTab{
	if (self = [super initWithNibName:nil bundle:nil]){
		[self setTitle:NSLocalizedString(@"EXTab", @"holder value")];
		
		self.headerFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
		self.rowSize = (CGSize){304, 44};
		
		self.presentedTab = presentedTab;
		
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
	
	CGSize loadSize = self.view.bounds.size;
	self.scroller = [MGScrollView scrollerWithSize:loadSize];
	[self.scroller setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	// setup the main scroller (using a grid layout)
	self.scroller.contentLayoutMode = MGLayoutGridStyle;
	self.scroller.bottomPadding = 8;
	[self.view addSubview:self.scroller];
	
	
	CGSize tablesGridSize = deviceIsPad ? IPAD_TABLES_GRID: IPHONE_TABLES_GRID;
	tablesGrid = [MGBox boxWithSize:tablesGridSize];
	tablesGrid.contentLayoutMode = MGLayoutGridStyle;
	[self.scroller.boxes addObject:tablesGrid];
	
	// the features table
	self.primaryTable = [MGBox box];
	[tablesGrid.boxes addObject:self.primaryTable];
	self.primaryTable.sizingMode = MGResizingShrinkWrap;
	
	// the subsections table
	self.detailTable = [MGBox box];
	[tablesGrid.boxes addObject:self.detailTable];
	self.detailTable.sizingMode = MGResizingShrinkWrap;
	
	[self refreshContent];
}


//this code is from MGBoxDemo and seems to work to refresh size quanitites after first load of view (before the boxes could horrizontal scroll)
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation
										   duration:1];
	[self didRotateFromInterfaceOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)o {
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orient
                                         duration:(NSTimeInterval)duration {
//	
//	BOOL portrait = UIInterfaceOrientationIsPortrait(orient);
	
	//update the objects to displaay here
	// relayout the sections
	[self.scroller layoutWithSpeed:duration completion:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orient {
	//finished
}

#pragma mark - content
-(void) refreshContent{
	[self.primaryTable.boxes removeAllObjects];
	[self.detailTable.boxes removeAllObjects];
	
	NSMutableArray * primaryBoxes = [NSMutableArray array];
	[primaryBoxes addObjectsFromArray:[self headerPrimaryMessageBoxes]];
	[primaryBoxes addObjectsFromArray:[self primaryContentBoxes]];
	[primaryBoxes addObjectsFromArray:[self footerPrimaryMessageBoxes]];
	[self.primaryTable.boxes addObjectsFromArray:primaryBoxes];
	
	NSMutableArray * detailBoxes = [NSMutableArray array];
	[detailBoxes addObjectsFromArray:[self detailBoxes]];
	[self.detailTable.boxes addObjectsFromArray:detailBoxes];

	// animate
//	[self.detailTable layoutWithSpeed:0.3 completion:nil];
	[self.scroller layoutWithSpeed:0.3 completion:nil];
	
	// scroll
	if ([primaryBoxes count] > 0)
		[self.scroller scrollToView:[primaryBoxes objectAtIndex:0] withMargin:8];
}

-(NSArray*)	headerPrimaryMessageBoxes{
	NSMutableArray * boxes = [NSMutableArray array];
	for (NSDictionary * messageDict in[[EXUserComManager sharedUserComManager]  messagesForUIAppTab:self.presentedTab]){
		[boxes addObject:[self boxFromMessageDict:messageDict]];
	}
	return boxes;
}
-(NSArray*)	footerPrimaryMessageBoxes{
	return nil;
}
-(NSArray*)	primaryContentBoxes{
	return nil;
}
-(NSArray*)	detailBoxes{
	return nil;
}

-(MGBox*)boxFromMessageDict:(NSDictionary*)dict{
	// make the section
	MGTableBoxStyled *section = MGTableBoxStyled.box;
	
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


- (void)loadAnimatedLayoutSection {
	
	// empty self.detailTable out
	[self.detailTable.boxes removeAllObjects];
	
	// make the section
	MGTableBoxStyled *section = MGTableBoxStyled.box;
	[self.detailTable.boxes addObject:section];
	
	// header
	MGLineStyled *head = [MGLineStyled lineWithLeft:@"Animated Layout" right:nil
											   size:self.rowSize];
	[section.topLines addObject:head];
	head.font = self.headerFont;
	
	id waffle = @"**MGBox** and **MGScrollView** provide **layout** and "
	"**layoutWithSpeed:completion:** methods.\n\n"
	"**layout** automatically positions all child boxes according to their "
	"**margin**, **padding**, and **boxLayoutMode** values.\n\n"
	"**layoutWithSpeed:completion:** does the same, with the addition of "
	"fading in new boxes, fading out removed boxes, and animating existing "
	"boxes from old position to new.\n\n"
	"This allows effortless animation of changes to grids, tables, "
	"table sections, or any arbitrary tree of **MGBLayoutBox** objects.|mush";
	
	// stuff
	MGLineStyled *line = [MGLineStyled multilineWithText:waffle font:nil width:304
												 padding:UIEdgeInsetsMake(16, 16, 16, 16)];
	[section.topLines addObject:line];
	
	// animate
	[self.detailTable layoutWithSpeed:0.3 completion:nil];
	[self.scroller layoutWithSpeed:0.3 completion:nil];
	
	// scroll
	[self.scroller scrollToView:section withMargin:8];
}



@end
