//
//  TMTextureFrameBuffer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

#import "TMTexture.h"
#import "TMFrameBuffer.h"

NS_ASSUME_NONNULL_BEGIN

/// A class representing an openGL texture backed frame-buffer.
@interface TMTextureFrameBuffer : NSObject <TMFrameBuffer>

/// Initialize with \c size of the texture the frame buffer should be backed on.
- (instancetype)initWithSize:(CGSize)size;

/// Bind the frame buffer.
- (void)bind;

/// The texture the frame buffer is backed on.
@property (readonly, strong, nonatomic) TMTexture *texture;

@end

NS_ASSUME_NONNULL_END
