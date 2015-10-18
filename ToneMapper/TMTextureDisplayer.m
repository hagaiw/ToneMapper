//
//  TMTextureDisplayer.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureDisplayer.h"
#import "TMProgramFactory.h"
#import "TMProjectionFactory.h"
#import "TMTexturedGeometry.h"
#import "TMQuadTexturedVertices.h"
#import "TMTextureDrawer.h"
#import "TMProjectionFactory.h"

@interface TMTextureDisplayer ()

@property (strong, nonatomic) TMGLKViewFrameBuffer *frameBuffer;
@property (strong, nonatomic) TMTextureProgram *program;
@property (strong, nonatomic) TMTexturedGeometry *quadGeometry;
@property (nonatomic) GLfloat scale;
@property (nonatomic) GLfloat x;
@property (nonatomic) GLfloat y;

@end

@implementation TMTextureDisplayer

static NSString * const kWorkspaceVertexShader = @"workspaceVertexShader";
static NSString * const kWorkspaceFragmentShader = @"workspaceFragmentShader";

- (instancetype)initWithFrameBuffer:(TMGLKViewFrameBuffer *)frameBuffer {
  if (self = [super init]) {
    self.frameBuffer = frameBuffer;
    
    self.program = [[TMProgramFactory new]
                    textureProgramWithVertexShaderName:kWorkspaceVertexShader
                                    fragmentShaderName:kWorkspaceFragmentShader
                                    textureUniformName:kTextureUniform
                                 projectionUniformName:kProjectionUniform
                                 positionAttributeName:kPositionAttribute
                                      textureCoordName:kTextureCoordinateAttribute];
    
    self.quadGeometry = [[TMTexturedGeometry alloc]
                                        initWithTexturedVertices:[TMQuadTexturedVertices new]];
    
    self.scale = 1.0;
    self.x = 0.0;
    self.y = 0.0;
    
  }
  return self;
}

- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry
                              scale:(GLfloat)scale
                                  x:(GLfloat)x
                                  y:(GLfloat)y {
  if (self = [super init]) {
    self.frameBuffer = frameBuffer;
    self.program = program;
    self.quadGeometry = geometry;
    self.scale = scale;
    self.x = x;
    self.y = y;
  }
  return self;
}

- (void)displayTexture:(TMTexture *)texture {
  
  TMProjectionFactory *projectionFactory = [TMProjectionFactory new];
  
  TMProjection *aspectFixProjection = [projectionFactory projectionFitSize:texture.size
                                                                            inSize:self.frameBuffer.size];
  
  TMProjection *translationProjection = [projectionFactory translationProjectionWithX:self.x y:self.y];
  TMProjection *scaleProjection = [projectionFactory scaleProjectionWithScale:self.scale];
  
  aspectFixProjection = [projectionFactory projectionByMultiplyingLeft:aspectFixProjection
                                                               right:scaleProjection];
  aspectFixProjection = [projectionFactory projectionByMultiplyingLeft:translationProjection
                                                                 right:aspectFixProjection];
  
  [[TMTextureDrawer new] drawWithTextureProgram:self.program texturedGeometry:self.quadGeometry frameBuffer:self.frameBuffer texture:texture projection:aspectFixProjection];
}

- (TMTextureDisplayer *)displayerWithTranslationDeltaX:(GLfloat)x y:(GLfloat)y {
  return [[TMTextureDisplayer alloc] initWithFrameBuffer:self.frameBuffer program:self.program geometry:self.quadGeometry scale:self.scale x:self.x+x y:self.y+y];
}

- (TMTextureDisplayer *)displayerWithTranslationDeltaScale:(GLfloat)scale scalePositionX:(GLfloat)x y:(GLfloat)y{
  
  GLfloat newScale = self.scale*scale;
  GLfloat newX = self.x;
  GLfloat newY = self.y;
  
  return [[TMTextureDisplayer alloc] initWithFrameBuffer:self.frameBuffer program:self.program geometry:self.quadGeometry scale:newScale x:newX y:newY];
}



@end
