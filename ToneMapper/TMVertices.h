//
//  TMVertices.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@import GLKit;

/// A protocol for vertex buffer data wrapper objects.
@protocol TMTexturedVertices <NSObject>

/// A pointer to an array of vertices.
@property (readonly, nonatomic) void *vertices;

/// A pointer to an array of vertex indices.
@property (readonly, nonatomic) GLubyte *indices;

/// The number of vertices in the \c vertices array.
@property (readonly, nonatomic) GLsizei numOfVertices;

/// The number of position coordinates each vertex has.
@property (readonly, nonatomic) GLsizei numOfPositionCoordinates;

/// The number of texture coordinates each vertex has.
@property (readonly, nonatomic) GLsizei numOfTextureCoordinates;

/// The number of indices in the \c indices array.
@property (readonly, nonatomic) GLsizei numOfIndices;

/// The type of each position coordinate.
@property (readonly, nonatomic) GLenum positionType;

/// The type of each texture coordinate.
@property (readonly, nonatomic) GLenum textureType;

/// The size of each index.
@property (readonly, nonatomic) GLuint indexSize;

/// The size of each vertex.
@property (readonly, nonatomic) GLuint vertexSize;

/// The size of the \c vertices array.
@property (readonly, nonatomic) GLuint verticesArraySize;

/// The size pf the \c indices array.
@property (readonly, nonatomic) GLuint indicesArraySize;

/// A pointer to the first position coordinate.
@property (readonly, nonatomic) GLvoid *positionPointer;

// A pointer to the first texture coordinate.
@property (readonly, nonatomic) GLvoid *texturePointer;

@end

NS_ASSUME_NONNULL_END
