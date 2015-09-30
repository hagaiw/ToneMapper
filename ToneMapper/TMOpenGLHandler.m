//
//  TMOpenGLHandler.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMOpenGLHandler.h"
#import "TMImageProgram.h"


@interface TMOpenGLHandler ()


@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLuint indexBuffer;
@property (nonatomic) TMImageProgram *program;

@end

@implementation TMOpenGLHandler

//typedef struct {
//  float Position[3];
//  float TexCoord[2]; // New
//} Vertex;
//
//// Add texture coordinates to Vertices as follows
//const Vertex Vertices[] = {
//  {{1, -1, -1}, {1, 0}},
//  {{1, 1, -1}, {1, 1}},
//  {{-1, 1, -1}, {0, 1}},
//  {{-1, -1, -1}, {0, 0}}
//};
//
//const GLubyte Indices[] = {
//  0, 1, 2,
//  2, 3, 0
//};
//
//- (void)initVBOs {
//  glGenBuffers(1, &_vertexBuffer);
//  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
//  glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
//  
//  glGenBuffers(1, &_indexBuffer);
//  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
//  
//  glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
//  glVertexAttribPointer(_textureSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
//}



@end
