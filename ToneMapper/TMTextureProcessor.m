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
#import "TMTexturedGeometry.h"
#import "TMQuadTexturedVertices.h"
#import "TMProjectionFactory.h"

@interface TMTextureProcessor ()

@property (strong, nonatomic) TMTextureProgram *program;
@property (strong, nonatomic) TMTexturedGeometry *quadGeometry;
@property (strong, nonatomic) TMTextureFrameBuffer *textureFrameBuffer;
@property (weak, nonatomic) TMTexture *texture;

@end

@implementation TMTextureProcessor

- (instancetype)initWithFrameBuffer:(TMTextureFrameBuffer *)frameBuffer
                            program:(TMTextureProgram *)program
                       quadGeometry:(TMTexturedGeometry *)quadGeometry {
  if (self = [super init]) {
    self.textureFrameBuffer = frameBuffer;
    self.program = program;
    self.quadGeometry = quadGeometry;
  }
  return self;
}

- (instancetype)initWithProgram:(TMTextureProgram *)program {
  if (self = [super init]) {
    self.program = program;
    self.quadGeometry = [[TMTexturedGeometry alloc]
                         initWithTexturedVertices:[TMQuadTexturedVertices new]];
    
  }
  return self;
}

- (TMTexture *)processTexture:(TMTexture *)texture {
  return [self processTexture:texture
               withProjection:[[TMProjectionFactory new] identityProjection]];
}

- (TMTexture *)processAndFlipTexture:(TMTexture *)texture {
  return [self processTexture:texture
               withProjection:[[TMProjectionFactory new] verticalMirrorProjection]];
}

- (TMTexture *)processTexture:(TMTexture *)texture withProjection:(TMProjection *)projection{
  if (texture != self.texture) {
    self.textureFrameBuffer = [self frameBufferWithSize:texture.size];
    self.texture = texture;
  }
  [[TMTextureDrawer new] drawWithTextureProgram:self.program
                               texturedGeometry:self.quadGeometry
                                    frameBuffer:self.textureFrameBuffer
                                        texture:texture
                                     projection:projection];
  return self.textureFrameBuffer.texture;
}

- (TMTextureFrameBuffer *)frameBufferWithSize:(CGSize)size {
  return [[TMTextureFrameBuffer alloc] initWithSize:size];
}

@end
