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
@property (strong, nonatomic) TMTexture *texture;

@end

@implementation TMTextureProcessor

- (instancetype)initWithTexture:(TMTexture *)texture frameBuffer:(TMTextureFrameBuffer *)frameBuffer
                        program:(TMTextureProgram *)program
                   quadGeometry:(TMTexturedGeometry *)quadGeometry {
  if (self = [super init]) {
    self.texture = texture;
    self.textureFrameBuffer = frameBuffer;
    self.program = program;
    self.quadGeometry = quadGeometry;
  }
  return self;
}

- (instancetype)initWithVertexShader:(NSString *)vertexShader
                           fragmentShader:(NSString *)fragmentShader
                                  texture:(TMTexture *)texture {
  if (self = [super init]) {
    TMProgramFactory *programFactory = [TMProgramFactory new];
    self.program = [programFactory textureProgramWithVertexShaderName:vertexShader fragmentShaderName:fragmentShader textureUniformName:kTextureUniform projectionUniformName:kProjectionUniform positionAttributeName:kPositionAttribute textureCoordName:kTextureCoordinateAttribute];
    self.quadGeometry = [[TMTexturedGeometry alloc]
                         initWithTexturedVertices:[TMQuadTexturedVertices new]];
    self.textureFrameBuffer = [self frameBufferWithTexture:texture];
    self.texture = texture;
  }
  return self;
}

- (TMTexture *)process {
  [[TMTextureDrawer new] drawWithTextureProgram:self.program
                               texturedGeometry:self.quadGeometry
                                    frameBuffer:self.textureFrameBuffer
                                        texture:self.texture
                                     projection:[[TMProjectionFactory new] verticalFlipProjection]];
  return self.textureFrameBuffer.texture;
}

- (TMTextureFrameBuffer *)frameBufferWithTexture:(TMTexture *)texture {
  if (texture != self.texture) {
    return [[TMTextureFrameBuffer alloc] initWithSourceTexture:texture];
  }
  return self.textureFrameBuffer;
}

- (TMTextureProcessor *)processorWithTexture:(TMTexture *)texture {
  TMTextureFrameBuffer *frameBuffer = [self frameBufferWithTexture:(TMTexture *)texture];
  return [self initWithTexture:texture frameBuffer:frameBuffer program:self.program
                  quadGeometry:self.quadGeometry];

}

@end
