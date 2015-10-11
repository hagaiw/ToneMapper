//
//  TMDrawer.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMDrawer.h"

@interface TMDrawer ()

@property (strong, nonatomic) TMProgram *program;
@property (strong, nonatomic) TMTexturedGeometry *texturedGeometry;
@property (strong, nonatomic) id<TMFrameBuffer> frameBuffer;
@property (strong, nonatomic) TMTexture *texture;
@property (strong, nonatomic) id<TMProjection> projection;

@end

@implementation TMDrawer

- (instancetype)initWithProgram:(TMProgram *)program
               texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                    frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                     projection:(id<TMProjection>)projection{
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
  [self.program useProgram];
  [self.frameBuffer bind];
  [self.texture bind];
  
  [self.texturedGeometry bind];
  [self.texturedGeometry linkPositionArrayToAttribute:[self.program.handlesForAttributes handleForKey:@"Position"]];
  [self.texturedGeometry linkTextureArrayToAttribute:[self.program.handlesForAttributes handleForKey:@"TexCoordIn"]];
  
  glUniform1i([self.program.handlesForUniforms handleForKey:@"Texture"], 0);
  glUniformMatrix4fv([self.program.handlesForUniforms handleForKey:@"Projection"], 1, 0, self.projection.matrix.m);
  glViewport(0, 0, self.frameBuffer.width, self.frameBuffer.height);
  [self.texturedGeometry drawElements];
}

@end
