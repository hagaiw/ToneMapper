//
//  TMVertices.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GLKit;

@protocol TMVertices <NSObject>

@property (readonly, nonatomic) void *vertices;
@property (readonly, nonatomic) GLubyte *indices;
@property (readonly, nonatomic) GLsizei numOfVertices;
@property (readonly, nonatomic) GLsizei numOfPositionCoordinates;
@property (readonly, nonatomic) GLsizei numOfTextureCoordinates;
@property (readonly, nonatomic) GLenum positionType;
@property (readonly, nonatomic) GLenum textureType;
@property (readonly, nonatomic) GLuint indexSize;
@property (readonly, nonatomic) GLuint verticesArraySize;
@property (readonly, nonatomic) GLuint indicesArraySize;
@property (readonly, nonatomic) GLvoid *positionPointer;
@property (readonly, nonatomic) GLvoid *texturePointer;

@end
