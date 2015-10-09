//
//  TMQuadVertices.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMQuadVertices.h"

@implementation TMQuadVertices

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

- (NSUInteger)size {
  return 4;
}

- (GLsizei)sizeOfVertice {
  return sizeof(QuadVertex);
}

- (GLsizei)sizeOfIndex {
  return sizeof(GLubyte);
}

@end
