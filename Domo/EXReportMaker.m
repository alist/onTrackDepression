//
//  EXReportMaker.m
//  onTrack-Depression
//
//  Created by Alexander Hoekje List on 1/10/14.
//  Copyright (c) 2014 ExoMachina. All rights reserved.
//

#import "EXReportMaker.h"

static CGSize pdfPageSize = {612, 792}; //default letter


@implementation EXReportMaker


-(id) initWithMessage:(NSString*)preSubMessage substitutionDictionary:(NSDictionary*)substitutions imagesToAttach:(NSArray*)images{
    if (self = [super init]){
        self.preSubMessage = preSubMessage;
        self.substitutions = substitutions;
        self.renderedImages = images;
    }
    return self;
}

-(id) init{
    self = [self initWithMessage:nil substitutionDictionary:nil imagesToAttach:nil];
    return self;
}

-(void) renderToPDF{
    [self _beginPDFContext];
    [self _writeTextToPDF];
    [self _writeImagesToPDF];
    [self _endPDFContext];
}



#pragma mark - internals

-(NSString*) message{
    if (_message == nil){
        [self _substituteMessage];
    }
    return _message;
}

-(void) _substituteMessage{
    
    NSMutableString * subd = [self.preSubMessage mutableCopy];
    
    for (NSString * key in self.substitutions){
        [subd replaceOccurrencesOfString:[NSString stringWithFormat:@"<%@>",key] withString:[self.substitutions valueForKey:key] options:NSLiteralSearch range:NSMakeRange(0, [subd length])];
    }
    
    self.message = subd;
}


#pragma mark pdf specifics
-(void) _beginPDFContext{
    NSString *fileName = @"report.pdf";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    self.pdfPath = pdfFileName;
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);

    //new page
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pdfPageSize.width, pdfPageSize.height), nil);

    
}

-(void) _writeTextToPDF{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    double borderInset = 10;
    double marginInset = 10;
    
    NSString *textToDraw = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum.";
    
    UIFont *font = [UIFont systemFontOfSize:12.0];
    
    CGSize stringSize = [textToDraw sizeWithFont:font
                               constrainedToSize:CGSizeMake(pdfPageSize.width - 2*borderInset-2*marginInset, pdfPageSize.height - 2*borderInset - 2*marginInset)
                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect renderingRect = CGRectMake(borderInset + marginInset, borderInset + marginInset + 50.0, pdfPageSize.width - 2*borderInset - 2*marginInset, stringSize.height);
    
    [textToDraw drawInRect:renderingRect
                  withFont:font
             lineBreakMode:NSLineBreakByWordWrapping
                 alignment:NSTextAlignmentLeft];
}

-(void) _writeImagesToPDF{
    if (self.renderedImages.count < 1)
        return; //already done!
    
    //calculate total width, then layout about center
    double imagePadding = 20;
    
    double totalWidth = 0;
    for (UIImage * image in self.renderedImages){
        totalWidth += image.size.width /2;
    }
    totalWidth += imagePadding * self.renderedImages.count -1;
    
    double startingOrigin = ceil((pdfPageSize.width - totalWidth)/2);
    
    double nextOrigin = startingOrigin;
    for (UIImage * image in self.renderedImages){
        [image drawInRect:CGRectMake( nextOrigin , 350, ceilf(image.size.width/2), ceilf(image.size.height/2))];
        nextOrigin += ceilf(image.size.width/2 + imagePadding);
    }
}

-(void) _endPDFContext{
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

@end
