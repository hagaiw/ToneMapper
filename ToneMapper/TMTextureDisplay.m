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

NS_ASSUME_NONNULL_BEGIN

@interface TMTextureDisplay ()

/// The \c TMframeBuffer to which \c TMTextures will be drawn.
@property (strong, nonatomic) TMGLKViewFrameBuffer *frameBuffer;

/// The \c TMProgram used to when drawing \c TMTextures.
@property (strong, nonatomic) TMTextureProgram *program;

/// The \c TMGeometry used when drawing.
@property (strong, nonatomic) TMTexturedGeometry *geometry;

/// A factory class used to produce \c GLKMatrix4 projections.
@property (strong, nonatomic) TMProjectionFactory *projectionFactory;

/// A \c TMTextureDrawer that is used when drawing \c TMTextures.
@property (strong, nonatomic) TMTextureDrawer *textureDrawer;

@end

@implementation TMTextureDisplay

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry {
  if (self = [super init]) {
    self.frameBuffer = frameBuffer;
    self.program = program;
    self.geometry = geometry;
    self.projectionFactory = [TMProjectionFactory new];
    self.textureDrawer = [TMTextureDrawer new];
  }
  return self;
}

#pragma mark -
#pragma mark Texture Displaying
#pragma mark -

- (void)displayTexture:(TMTexture *)texture
           position:(TMPosition *)displayData {
  
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
  [self.textureDrawer drawWithTextureProgram:self.program texturedGeometry:self.geometry
                                    frameBuffer:self.frameBuffer texture:texture
                                     projection:aspectFixProjection];
}

@end

NS_ASSUME_NONNULL_END
