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

@end

@implementation TMGeometry


- (instancetype)initGeometryWithVertices:(id<TMVertices>)vertices {
  if (self = [super init]) {
    glGenBuffers(1, &_vertexBuffer);
    glGenBuffers(1, &_indexBuffer);
    
    [self bindGeometry];
    
    glBufferData(GL_ARRAY_BUFFER, vertices.sizeOfVertice*vertices.size, vertices.vertices, GL_STATIC_DRAW);
    NSLog(@"%lu", vertices.sizeOfVertice*vertices.size);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, vertices.sizeOfIndex*6, vertices.indices, GL_STATIC_DRAW);
    NSLog(@"%d", vertices.sizeOfIndex*6);
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




@end
