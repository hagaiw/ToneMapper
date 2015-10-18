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

@end

@implementation TMTextureDisplay

static NSString * const kWorkspaceVertexShader = @"workspaceVertexShader";
static NSString * const kWorkspaceFragmentShader = @"workspaceFragmentShader";

- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry {
  if (self = [super init]) {
    self.frameBuffer = frameBuffer;
    self.program = program;
    self.quadGeometry = geometry;
  }
  return self;
}

- (void)displayTexture:(TMTexture *)texture
           displayData:(TMPosition *)displayData {
  
  TMProjectionFactory *projectionFactory = [TMProjectionFactory new];
  
  GLKMatrix4 aspectFixProjection = [projectionFactory projectionFitSize:texture.size
                                                                            inSize:self.frameBuffer.size];
  
  GLKMatrix4 translationProjection = [projectionFactory
                                         translationProjectionWithX:displayData.tranlsation.x
                                                                  y:displayData.tranlsation.y];
  GLKMatrix4 scaleProjection = [projectionFactory scaleProjectionWithScale:displayData.scale];
  
  aspectFixProjection = [projectionFactory projectionByMultiplyingLeft:aspectFixProjection
                                                               right:scaleProjection];
  aspectFixProjection = [projectionFactory projectionByMultiplyingLeft:translationProjection
                                                                 right:aspectFixProjection];
  
  [[TMTextureDrawer new] drawWithTextureProgram:self.program texturedGeometry:self.quadGeometry frameBuffer:self.frameBuffer texture:texture projection:aspectFixProjection];
}

@end
