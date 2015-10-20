//
//  TMDrawer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

#import "TMFrameBuffer.h"
#import "TMTexture.h"
#import "TMTextureProgram.h"
#import "TMTexturedGeometry.h"

NS_ASSUME_NONNULL_BEGIN

/// A helper class for performing openGL drawing.
@interface TMTextureDrawer : NSObject

/// Draws the scene defined by the given \c program, \c textureGeometry, \c texture and \c
/// projection to the given \c frameBuffer.
- (void)drawWithTextureProgram:(TMTextureProgram *)program
              texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                   frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                    projection:(GLKMatrix4)projection;

@end

NS_ASSUME_NONNULL_END
