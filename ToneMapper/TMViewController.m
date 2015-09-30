//
//  TMViewController.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMViewController.h"

#import "TMImageProgram.h"

@interface TMViewController ()

@property (strong, nonatomic) EAGLContext *context;

@property (nonatomic) GLuint program;

@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLuint indexBuffer;

@property (nonatomic) GLuint positionSlot;
@property (nonatomic) GLuint textureSlot;

@property (nonatomic) GLuint projectionUniform;
@property (nonatomic) GLuint textureUniform;

@end

@implementation TMViewController


typedef struct {
  float Position[3];
  float TexCoord[2]; // New
} Vertex;

// Add texture coordinates to Vertices as follows
const Vertex Vertices[] = {
  {{1, -1, -1}, {1, 0}},
  {{1, 1, -1}, {1, 1}},
  {{-1, 1, -1}, {0, 1}},
  {{-1, -1, -1}, {0, 0}}
};

const GLubyte Indices[] = {
  0, 1, 2,
  2, 3, 0
};

- (void)viewDidLoad {
  
  
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  // Initialize context.
  [EAGLContext setCurrentContext:self.context];
  [self setupGL];
  glUseProgram(self.program);
  
  GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  view.context = self.context;
  view.delegate = self;
  self.view = view;
  
  
}

- (void)setupGL {
  
  
  
  [self initVBOs];
  
  NSArray *attributeNames = @[@"Position", @"TexCoordIn"];
  TMShaderBundle *shaderBundle = [[TMShaderBundle alloc] initWithVertexShader:@"vertex" fragmentShader:@"fragment"];
  TMImageProgram *imageProgram = [[TMImageProgram alloc] initWithShaderBundle:shaderBundle attributeNames:attributeNames];
  
  _positionSlot = imageProgram.positionSlot;
  _textureSlot = imageProgram.textureSlot;
  _textureUniform = imageProgram.textureUniform;
  _projectionUniform = imageProgram.projectionUniform;

  self.program = imageProgram.program;
  
  glEnableVertexAttribArray(_positionSlot);
  glEnableVertexAttribArray(_textureSlot);
  glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
  glVertexAttribPointer(_textureSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
  
}

- (void)initVBOs {
  glGenBuffers(1, &_vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
  
  glGenBuffers(1, &_indexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

  // BG Color
  glClearColor(0.5, 0.0, 0.5, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);

  // Projection matrix:
  float h = 4.0f * rect.size.height / rect.size.width;
  GLKMatrix4 projectionMatrix = GLKMatrix4MakeFrustum(-2, 2, h/2, -h/2, 1, 1);
  glUniformMatrix4fv(_projectionUniform, 1, 0, projectionMatrix.m);

  // Draw
  glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

@end
