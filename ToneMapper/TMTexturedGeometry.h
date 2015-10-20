//
//  TMGeometry.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMVertices.h"

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Represents a textured geometry to be used with openGL.
@interface TMTexturedGeometry : NSObject

/// Initialize with \c TMTexturedVertices that represent the structure of the geometry and
/// generate the required Vertex Buffer Objects.
- (instancetype)initWithTexturedVertices:(id<TMTexturedVertices>)texturedVertices;

/// Binds the geometry using glBindBuffer.
- (void)bind;

/// Links the given position attribute to the position coordinates of the geometry by calling
/// glVertexAttribPointer.
- (void)linkPositionArrayToAttribute:(GLuint)positionHandle ;

/// Links the given texture attribute to the texture coordinates of the geometry by calling
/// glVertexAttribPointer.
- (void)linkTextureArrayToAttribute:(GLuint)textureHandle;

/// The number of indices, to be used when calling glDrawElements.
- (GLuint)numberOfIndices;

@end

NS_ASSUME_NONNULL_END
