//
//  TMTextureDisplayer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMTexture.h"
#import "TMGLKViewFrameBuffer.h"
#import "TMProjection.h"
#import "TMTextureProgram.h"
#import "TMTexturedGeometry.h"

@interface TMTextureDisplayer : NSObject

- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer;

- (TMTextureDisplayer *)displayerWithTranslationDeltaX:(GLfloat)x y:(GLfloat)y;

- (TMTextureDisplayer *)displayerWithTranslationDeltaScale:(GLfloat)scale
                                            scalePositionX:(GLfloat)x
                                                         y:(GLfloat)y;

- (void)displayTexture:(TMTexture *)texture;

- (instancetype)initWithFrameBuffer:(id<TMFrameBuffer>)frameBuffer
                            program:(TMTextureProgram *)program
                           geometry:(TMTexturedGeometry *)geometry
                              scale:(GLfloat)scale
                                  x:(GLfloat)x
                                  y:(GLfloat)y;

@end
