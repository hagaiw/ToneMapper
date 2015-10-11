//
//  TMGeometry.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTexturedGeometry.h"


@interface TMTexturedGeometry ()

@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLuint indexBuffer;
@property (nonatomic) id<TMTexturedVertices> vertices;

@end

@implementation TMTexturedGeometry


- (instancetype)initWithTexturedVertices:(id<TMTexturedVertices>)texturedVertices {
  if (self = [super init]) {
    self.vertices = texturedVertices;
    glGenBuffers(1, &_vertexBuffer);
    glGenBuffers(1, &_indexBuffer);
    [self bind];
    glBufferData(GL_ARRAY_BUFFER, [self.vertices verticesArraySize], [self.vertices vertices], GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.vertices indicesArraySize], [self.vertices indices], GL_STATIC_DRAW);
  }
  return self;
}

- (void)bind {
  glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.indexBuffer);
}

- (void)linkPositionArrayToAttribute:(GLuint)positionHandle {
  glVertexAttribPointer(positionHandle, [self.vertices numOfPositionCoordinates], [self.vertices positionType], GL_FALSE, [self.vertices vertexSize], [self.vertices positionPointer]);
}

- (void)linkTextureArrayToAttribute:(GLuint)textureHandle {
  glVertexAttribPointer(textureHandle, [self.vertices numOfTextureCoordinates], [self.vertices textureType], GL_FALSE, [self.vertices vertexSize], [self.vertices texturePointer]);
}

- (void)drawElements {
  glDrawElements(GL_TRIANGLES, [self.vertices numOfIndices], GL_UNSIGNED_BYTE, 0);
}




@end
