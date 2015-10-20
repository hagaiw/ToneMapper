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

/// A \c TMTexture displayer, to be used at the end of a \c TMTexture processing pipeline.
@interface TMTextureDisplay : NSObject

/// Initialize with the given \c TMFrameBuffer, \c TMTextureProgram, \c TMTexturedGeometry.
- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry;

/// Display the given \c TMTexture with translation and scale specified by the given
/// \c TMDisplayData.
- (void)displayTexture:(TMTexture *)texture position:(TMPosition *)displayData;

@end

NS_ASSUME_NONNULL_END
