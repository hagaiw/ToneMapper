//
//  TMDrawer.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureDrawer.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMTextureDrawer

- (void)drawWithTextureProgram:(TMTextureProgram *)program
              texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                   frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                    projection:(GLKMatrix4)projection {
  [program use];
  [frameBuffer bind];
  [texture bind];
  [texturedGeometry bind];
  
  [texturedGeometry linkPositionArrayToAttribute:program.positionAttribute];
  [texturedGeometry linkTextureArrayToAttribute:program.textureCoordAttribute];
  
  glUniform1i(program.textureUniform, 0);
  glUniformMatrix4fv(program.projectionUniform, 1, 0, projection.m);
  
  glViewport(0, 0, frameBuffer.size.width, frameBuffer.size.height);
  glDrawElements(GL_TRIANGLES, [texturedGeometry numberOfIndices], GL_UNSIGNED_BYTE, 0);
}


@end

NS_ASSUME_NONNULL_END
