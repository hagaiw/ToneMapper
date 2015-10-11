//
//  TMGLKViewFrameBuffer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/11/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMFrameBuffer.h"
@import GLKit;

@interface TMGLKViewFrameBuffer : NSObject <TMFrameBuffer>

- (instancetype)initWithGLKView:(GLKView *)glkView;

@end
