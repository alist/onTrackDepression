//
//  EXAnalyzeVC.h
//  Feel Better: Depression
//
//  Created by Alexander List on 1/4/13.
//  Copyright (c) 2013 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTabVC.h"
#import "CorePlot-CocoaTouch.h"
#import "EskBarPlot.h"
#import "EskLinePlot.h"

@interface EXReviewVC : EXTabVC{
	EskLinePlot *linePlot;
}
@property (nonatomic, retain) CPTGraphHostingView *lineHostingView;

@end
