//
//  TMTextureDisplayer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMTexture.h"
#import "TMGLKViewFrameBuffer.h"
#import "TMTextureProgram.h"
#import "TMTexturedGeometry.h"
#import "TMPosition.h"

NS_ASSUME_NONNULL_BEGIN

/// A pipeline object incharge of displaying the output of texture processing pipeline.
@interface TMTextureDisplay : NSObject

/// Initialize with the given \c frameBuffer, \c program, \c geometry, \c scale, \c x and \c y.
- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry;

/// Display the given \c TMTexture with translation and scale specified by the given
/// \c TMDisplayData.
- (void)displayTexture:(TMTexture *)texture displayData:(TMPosition *)displayData;

@end

NS_ASSUME_NONNULL_END
