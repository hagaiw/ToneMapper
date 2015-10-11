//
//  TMQuadVertices.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMQuadTexturedVertices.h"

@implementation TMQuadTexturedVertices

typedef struct {
  float Position[3];
  float TexCoord[2];
} QuadVertex;

static const QuadVertex kQuadVertices[] = {
  {{1, -1, 0}, {1, 0}},
  {{1, 1, 0}, {1, 1}},
  {{-1, 1, 0}, {0, 1}},
  {{-1, -1, 0}, {0, 0}}
};

static const GLubyte kQuadIndices[] = {
  0, 1, 2,
  2, 3, 0
};

- (void *)vertices {
  return (void *)kQuadVertices;
}

- (GLubyte *)indices {
  return (GLubyte *)kQuadIndices;
}

- (GLsizei)numOfVertices {
  return 4;
}

- (GLsizei)numOfPositionCoordinates {
  return 3;
}

- (GLsizei)numOfTextureCoordinates {
  return 2;
}

- (GLsizei)numOfIndices {
  return 6;
}

- (GLenum)positionType {
  return GL_FLOAT;
}

- (GLenum)textureType {
  return GL_FLOAT;
}

- (GLuint)indexSize {
  return sizeof(GLubyte);
}

- (GLuint)verticesArraySize {
  return sizeof(kQuadVertices);
}

- (GLuint)indicesArraySize {
  return sizeof(kQuadIndices);
}

- (GLuint)vertexSize {
  return sizeof(QuadVertex);
}

- (GLvoid *)positionPointer {
  return 0;
}

- (GLvoid *)texturePointer {
  return (GLvoid *)(sizeof(float) * 3);
}




@end
