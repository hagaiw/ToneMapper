//
//  TMGeometry.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMGeometry.h"


@interface TMGeometry ()

@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLuint indexBuffer;
@property (nonatomic) id<TMVertices> vertices;

@end

@implementation TMGeometry


- (instancetype)initGeometryWithVertices:(id<TMVertices>)vertices {
  if (self = [super init]) {
    self.vertices = vertices;
    glGenBuffers(1, &_vertexBuffer);
    glGenBuffers(1, &_indexBuffer);
    [self bindGeometry];
    glBufferData(GL_ARRAY_BUFFER, [self.vertices verticesArraySize], [self.vertices vertices], GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.vertices indicesArraySize], [self.vertices indices], GL_STATIC_DRAW);
  }
  return self;
}

- (void)bindGeometry {
  glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.indexBuffer);
}

- (void)linkGeometryToAttribute:(GLuint)attributeHandle size:(GLint)size
                   startPointer:(GLvoid *)startPointer
                         stride:(GLsizei)stride sizeOfVertex:(GLsizei)sizeOfVertex {
  glVertexAttribPointer(attributeHandle, size, GL_FLOAT, GL_FALSE, sizeOfVertex, startPointer);
}

- (void)linkPositionArrayToAttribute:(GLuint)positionHandle {
  glVertexAttribPointer(positionHandle, [self.vertices numOfPositionCoordinates], [self.vertices positionType], GL_FALSE, [self.vertices verticesArraySize], [self.vertices positionPointer]);
}

- (void)linkTextureArrayToAttribute:(GLuint)textureHandle {
  glVertexAttribPointer(textureHandle, [self.vertices numOfTextureCoordinates], [self.vertices textureType], GL_FALSE, [self.vertices verticesArraySize], [self.vertices texturePointer]);
}




@end
