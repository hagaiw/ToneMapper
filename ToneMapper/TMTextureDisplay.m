//
//  TMTextureDisplayer.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureDisplay.h"
#import "TMProgramFactory.h"
#import "TMProjectionFactory.h"
#import "TMTexturedGeometry.h"
#import "TMQuadTexturedVertices.h"
#import "TMTextureDrawer.h"
#import "TMProjectionFactory.h"

@interface TMTextureDisplay ()

@property (strong, nonatomic) TMGLKViewFrameBuffer *frameBuffer;
@property (strong, nonatomic) TMTextureProgram *program;
@property (strong, nonatomic) TMTexturedGeometry *quadGeometry;
@property (strong, nonatomic) TMProjectionFactory *projectionFactory;
@property (strong, nonatomic) TMTextureDrawer *textureDrawer;

@end

@implementation TMTextureDisplay

- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry {
  if (self = [super init]) {
    self.frameBuffer = frameBuffer;
    self.program = program;
    self.quadGeometry = geometry;
    self.projectionFactory = [TMProjectionFactory new];
    self.textureDrawer = [TMTextureDrawer new];
  }
  return self;
}

- (void)displayTexture:(TMTexture *)texture
           displayData:(TMPosition *)displayData {
  
  GLKMatrix4 aspectFixProjection = [self.projectionFactory projectionFitSize:texture.size
                                                                      inSize:self.frameBuffer.size];
  
  GLKMatrix4 translationProjection = [self.projectionFactory
                                      translationProjectionWithX:displayData.tranlsation.x
                                      y:displayData.tranlsation.y];
  GLKMatrix4 scaleProjection = [self.projectionFactory scaleProjectionWithScale:displayData.scale];
  
  aspectFixProjection = [self.projectionFactory projectionByMultiplyingLeft:aspectFixProjection
                                                               right:scaleProjection];
  aspectFixProjection = [self.projectionFactory projectionByMultiplyingLeft:translationProjection
                                                                 right:aspectFixProjection];
  
  [self.textureDrawer drawWithTextureProgram:self.program texturedGeometry:self.quadGeometry
                                    frameBuffer:self.frameBuffer texture:texture
                                     projection:aspectFixProjection];
}

@end
