//
//  TMGLKViewFrameBuffer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/11/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMFrameBuffer.h"

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// A wrapper for the \c GLKView class that allows it to be treated as a frame-buffer.
@interface TMGLKViewFrameBuffer : NSObject <TMFrameBuffer>

/// Initialize with \c glkView.
- (instancetype)initWithGLKView:(GLKView *)glkView;

@end

NS_ASSUME_NONNULL_END
