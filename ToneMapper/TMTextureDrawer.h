//
//  TMDrawer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;
#import "TMTextureProgram.h"
#import "TMTexturedGeometry.h"
#import "TMFrameBuffer.h"
#import "TMTexture.h"
#import "TMProjection.h"

@interface TMTextureDrawer : NSObject

- (instancetype)initWithTextureProgram:(TMTextureProgram *)program
                      texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                           frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                            projection:(TMProjection *)projection;

- (void)draw;

- (void)drawWithTextureProgram:(TMTextureProgram *)program
              texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                   frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                    projection:(TMProjection *)projection;

@end
