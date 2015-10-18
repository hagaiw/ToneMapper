//
//  TMDrawer.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureDrawer.h"

@implementation TMTextureDrawer

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
