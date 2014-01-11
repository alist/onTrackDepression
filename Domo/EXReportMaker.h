//
//  EXReportMaker.h
//  onTrack-Depression
//
//  Created by Alexander Hoekje List on 1/10/14.
//  Copyright (c) 2014 ExoMachina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXReportMaker : NSObject

/*
preSubMessage is the message that has <"keys"> to replace with values from "substitutions"
 a message with some <creationdate> can have the "creationdate" replaced by substitutions[creationdate]
 
views to render are added to the end of whatever is yeilded

*/
-(id) initWithMessage:(NSString*)preSubMessage substitutionDictionary:(NSDictionary*)substitutions imagesToAttach:(NSArray*)images;


-(void) renderToPDF;

@property (nonatomic, strong) NSString * pdfPath;

@property (nonatomic, strong) NSString* preSubMessage;
@property (nonatomic, strong) NSDictionary* substitutions;
@property (nonatomic, strong) NSArray * renderedImages;

//substituted message
@property (nonatomic, strong) NSString * message;




@end
