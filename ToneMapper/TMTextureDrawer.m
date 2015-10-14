//
//  TMDrawer.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureDrawer.h"

@interface TMTextureDrawer ()

@property (strong, nonatomic) TMTextureProgram *program;
@property (strong, nonatomic) TMTexturedGeometry *texturedGeometry;
@property (strong, nonatomic) id<TMFrameBuffer> frameBuffer;
@property (strong, nonatomic) TMTexture *texture;
@property (strong, nonatomic) TMProjection *projection;

@end

@implementation TMTextureDrawer

- (instancetype)initWithTextureProgram:(TMTextureProgram *)program
                      texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                           frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                            projection:(TMProjection *)projection {
  if (self = [super init]) {
    self.program = program;
    self.texturedGeometry = texturedGeometry;
    self.frameBuffer = frameBuffer;
    self.texture = texture;
    self.projection = projection;
  }
  return self;
}

- (void)draw {
  [self.program use];
  [self.frameBuffer bind];
  [self.texture bind];
  
  [self.texturedGeometry bind];
  [self.texturedGeometry linkPositionArrayToAttribute:self.program.positionAttribute];
  [self.texturedGeometry linkTextureArrayToAttribute:self.program.textureCoordAttribute];
  
  glUniform1i(self.program.textureUniform, 0);
  glUniformMatrix4fv(self.program.projectionUniform, 1, 0, self.projection.matrix.m);
  glViewport(0, 0, self.frameBuffer.size.width, self.frameBuffer.size.height);
  [self.texturedGeometry drawElements];
}

- (void)drawWithTextureProgram:(TMTextureProgram *)program
              texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                   frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                    projection:(TMProjection *)projection {
  
  [program use];
  [frameBuffer bind];
  [texture bind];
  
  [texturedGeometry bind];
  [texturedGeometry linkPositionArrayToAttribute:program.positionAttribute];
  [texturedGeometry linkTextureArrayToAttribute:program.textureCoordAttribute];
  
  glUniform1i(program.textureUniform, 0);
  glUniformMatrix4fv(program.projectionUniform, 1, 0, projection.matrix.m);
  glViewport(0, 0, frameBuffer.size.width, frameBuffer.size.height);
  [texturedGeometry drawElements];
}


@end
