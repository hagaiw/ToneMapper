//
//  TMOpenGLHandler.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMOpenGLHandler.h"


@interface TMOpenGLHandler ()

@property (readwrite, strong, nonatomic) EAGLContext *context;

@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLuint indexBuffer;
@property (readwrite, strong, nonatomic) TMImageProgram *imageProgram;

@property (nonatomic) GLuint positionSlot;
@property (nonatomic) GLuint textureSlot;
@property (nonatomic) GLuint projectionUniform;
@property (nonatomic) GLuint textureUniform;

@end

@implementation TMOpenGLHandler

typedef struct {
  float Position[3];
  float TexCoord[2]; // New
} Vertex2;

// Add texture coordinates to Vertices as follows
const Vertex2 Vertices2[] = {
  {{1, -1, -1}, {1, 0}},
  {{1, 1, -1}, {1, 1}},
  {{-1, 1, -1}, {0, 1}},
  {{-1, -1, -1}, {0, 0}}
};

const GLubyte Indices2[] = {
  0, 1, 2,
  2, 3, 0
};

- (void)initializeOpenGL {
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  [EAGLContext setCurrentContext:self.context];
  [self setupGL];
  glUseProgram(self.imageProgram.program);
}

- (void)setupGL {
  
  [self initVBOs];
  
  NSArray *attributeNames = @[@"Position", @"TexCoordIn"];
  TMShaderBundle *shaderBundle = [[TMShaderBundle alloc] initWithVertexShader:@"vertex" fragmentShader:@"fragment"];
  self.imageProgram = [[TMImageProgram alloc] initWithShaderBundle:shaderBundle attributeNames:attributeNames];

  _positionSlot = self.imageProgram.positionSlot;
  _textureSlot = self.imageProgram.textureSlot;
  _textureUniform = self.imageProgram.textureUniform;
  _projectionUniform = self.imageProgram.projectionUniform;
  
  self.program = self.imageProgram.program;
  
  glEnableVertexAttribArray(_positionSlot);
  glEnableVertexAttribArray(_textureSlot);
  glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex2), 0);
  glVertexAttribPointer(_textureSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex2), (GLvoid*) (sizeof(float) * 3));
}

- (void)initVBOs {
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices2), Vertices2, GL_STATIC_DRAW);
  
  glGenBuffers(1, &_indexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices2), Indices2, GL_STATIC_DRAW);
  
  glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex2), 0);
  glVertexAttribPointer(_textureSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex2), (GLvoid*) (sizeof(float) * 3));
}

- (void)drawInRect:(CGRect)rect {
  // BG Color
  glClearColor(0.5, 0.0, 0.5, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);
  
  // Projection matrix:
  float h = 4.0f * rect.size.height / rect.size.width;
  GLKMatrix4 projectionMatrix = GLKMatrix4MakeFrustum(-2, 2, h/2, -h/2, 1, 1);
  glUniformMatrix4fv(_projectionUniform, 1, 0, projectionMatrix.m);
  
  // Draw
  glDrawElements(GL_TRIANGLES, sizeof(Indices2)/sizeof(Indices2[0]), GL_UNSIGNED_BYTE, 0);
}



@end
