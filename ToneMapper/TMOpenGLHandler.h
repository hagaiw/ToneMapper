//
//  TMOpenGLHandler.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMImageProgram.h"


@import GLKit;

@interface TMOpenGLHandler : NSObject

@property (readonly, strong, nonatomic) EAGLContext *context;
@property (readonly, strong, nonatomic) TMImageProgram *imageProgram;

- (void)initializeOpenGL;
- (void)drawInRect:(CGRect)rect;

@end
