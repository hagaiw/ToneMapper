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

@interface TMTextureProcessor ()

@property (strong, nonatomic) TMTextureProgram *program;
@property (strong, nonatomic) TMTexturedGeometry *quadGeometry;
@property (strong, nonatomic) TMProjectionFactory *projectionFactory;
@property (strong, nonatomic) TMGeometryFactory *geometryFactory;

@end

@implementation TMTextureProcessor

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
  self.quadGeometry = [self.geometryFactory quadGeometry];
  return self;
}

- (TMTexture *)processTexture:(TMTexture *)texture {
  return [self processTexture:texture
               withProjection:[self.projectionFactory verticalMirrorProjection]];
}

- (TMTexture *)processAndFlipTexture:(TMTexture *)texture {
  return [self processTexture:texture
               withProjection:[self.projectionFactory verticalMirrorProjection]];
}

- (TMTexture *)processTexture:(TMTexture *)texture withProjection:(GLKMatrix4)projection{
  TMTextureFrameBuffer *textureFrameBuffer = [self frameBufferWithSize:texture.size];
  [[TMTextureDrawer new] drawWithTextureProgram:self.program
                               texturedGeometry:self.quadGeometry
                                    frameBuffer:textureFrameBuffer
                                        texture:texture
                                     projection:projection];
  return textureFrameBuffer.texture;
}

- (TMTextureFrameBuffer *)frameBufferWithSize:(CGSize)size {
  return [[TMTextureFrameBuffer alloc] initWithSize:size];
}

@end
