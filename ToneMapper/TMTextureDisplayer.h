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
#import "TMProjection.h"
#import "TMTextureProgram.h"
#import "TMTexturedGeometry.h"

NS_ASSUME_NONNULL_BEGIN

/// A pipeline object incharge of displaying the output of texture processing pipeline.
@interface TMTextureDisplayer : NSObject

/// Initialize with a \c frameBuffer.
- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer;

/// Initialize with the given \c frameBuffer, \c program, \c geometry, \c scale, \c x and \c y.
- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry
                              scale:(GLfloat)scale
                                  x:(GLfloat)x
                                  y:(GLfloat)y;


/// A method for copying the exiting displayer with added \c x, \c y translation values.
- (TMTextureDisplayer *)displayerWithTranslationDeltaX:(GLfloat)x y:(GLfloat)y;

/// A method for copying the existing displayer with and added \c scale, and \c x, \c y scale
/// position.
- (TMTextureDisplayer *)displayerWithTranslationDeltaScale:(GLfloat)scale
                                            scalePositionX:(GLfloat)x
                                                         y:(GLfloat)y;

/// Display the given \c TMTexture.
- (void)displayTexture:(TMTexture *)texture;

@end

NS_ASSUME_NONNULL_END
