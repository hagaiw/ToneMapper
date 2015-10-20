//
//  TMTextureProcessor.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureProcessor.h"
#import "TMProgramFactory.h"
#import "TMTextureFrameBuffer.h"
#import "TMTextureDrawer.h"
#import "TMProjectionFactory.h"
#import "TMGeometryFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureProcessor ()

/// The program used when processing the given \c TMTexture.
@property (strong, nonatomic) TMTextureProgram *program;

/// The geometry used to draw and process the given \c TMTexture.
@property (strong, nonatomic) TMTexturedGeometry *geometry;

/// Factory object used to create \c GLKMAtrix4 projections.
@property (strong, nonatomic) TMProjectionFactory *projectionFactory;

/// Factory object used to create \c TMTextureGeometry.
@property (strong, nonatomic) TMGeometryFactory *geometryFactory;

/// The \c TMTextureFrameBuffer to which the given \c TMTexture is drawn while processing.
/// Will be reinitialized whenver the given \c TMTexture's size does not fit the \c frameBuffer's
/// size.
@property (strong, nonatomic) TMTextureFrameBuffer *frameBuffer;

@end

@implementation TMTextureProcessor

#pragma mark -
#pragma mark Initialize
#pragma mark -

- (instancetype)init {
  if (self = [super init]) {
    self.projectionFactory = [TMProjectionFactory new];
    self.geometryFactory = [TMGeometryFactory new];
  }
  return self;
}

- (instancetype)initWithProgram:(TMTextureProgram *)program {
  self = [self init];
  self.program = program;
  self.geometry = [self.geometryFactory quadGeometry];
  return self;
}

#pragma mark -
#pragma mark Processing
#pragma mark -

- (TMTexture *)processTexture:(TMTexture *)texture {
  return [self processTexture:texture
               withProjection:[self.projectionFactory identityProjection]];
}

- (TMTexture *)processAndFlipTexture:(TMTexture *)texture {
  return [self processTexture:texture
               withProjection:[self.projectionFactory verticalMirrorProjection]];
}

- (TMTexture *)processTexture:(TMTexture *)texture withProjection:(GLKMatrix4)projection{
  self.frameBuffer = [self frameBufferWithSize:texture.size];
  [[TMTextureDrawer new] drawWithTextureProgram:self.program
                               texturedGeometry:self.geometry
                                    frameBuffer:self.frameBuffer
                                        texture:texture
                                     projection:projection];
  return self.frameBuffer.texture;
}

#pragma mark -
#pragma mark Frame Buffer Handling
#pragma mark -

- (TMTextureFrameBuffer *)frameBufferWithSize:(CGSize)size {
  if (self.frameBuffer.size.height == size.height && self.frameBuffer.size.width == size.width) {
    return self.frameBuffer;
  }
  return [[TMTextureFrameBuffer alloc] initWithSize:size];
}

@end

NS_ASSUME_NONNULL_END
