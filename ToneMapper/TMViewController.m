//
//  TMViewController.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMViewController.h"

@interface TMViewController ()

@property (strong, nonatomic) EAGLContext *context;

@property (nonatomic) GLuint program;

@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) GLuint indexBuffer;

@property (nonatomic) GLuint positionSlot;
@property (nonatomic) GLuint colorSlot;
@property (nonatomic) GLuint textureSlot;

@property (nonatomic) GLuint projectionUniform;
@property (nonatomic) GLuint textureUniform;

@end

@implementation TMViewController


typedef struct {
  float Position[3];
  float Color[4];
  float TexCoord[2]; // New
} Vertex;

// Add texture coordinates to Vertices as follows
const Vertex Vertices[] = {
  {{1, -1, -1}, {1, 0, 0, 1}, {1, 0}},
  {{1, 1, -1}, {0, 1, 0, 1}, {1, 1}},
  {{-1, 1, -1}, {0, 0, 1, 1}, {0, 1}},
  {{-1, -1, -1}, {1, 1, 0, 1}, {0, 0}}
};

const GLubyte Indices[] = {
  0, 1, 2,
  2, 3, 0
};

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
  
  // 1
  NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                         ofType:@"glsl"];
  NSError* error;
  NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                     encoding:NSUTF8StringEncoding error:&error];
  if (!shaderString) {
    NSLog(@"Error loading shader: %@", error.localizedDescription);
    exit(1);
  }
  
  // 2
  GLuint shaderHandle = glCreateShader(shaderType);
  
  // 3
  const char * shaderStringUTF8 = [shaderString UTF8String];
  int shaderStringLength = [shaderString length];
  glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
  
  // 4
  glCompileShader(shaderHandle);
  
  // 5
  GLint compileSuccess;
  glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
  if (compileSuccess == GL_FALSE) {
    GLchar messages[256];
    glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
    NSString *messageString = [NSString stringWithUTF8String:messages];
    NSLog(@"%@", messageString);
    exit(1);
  }
  
  return shaderHandle;
  
}

- (void)viewDidLoad {
  
  self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if (!self.context) {
    NSLog(@"Failed to create ES context");
  }
  
  GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  view.context = self.context;
  view.delegate = self;
  self.view = view;
  
  [self setupGL];
  
  glUseProgram(self.program);
}


- (GLuint)createProgram {
  GLuint program = glCreateProgram();
  
  // create and link shaders
  GLuint vertexShader = [self compileShader:@"vertex" withType:GL_VERTEX_SHADER];
  GLuint fragmentShader = [self compileShader:@"fragment" withType:GL_FRAGMENT_SHADER];
  glAttachShader(program, vertexShader);
  glAttachShader(program, fragmentShader);
  glLinkProgram(program);
  
  // Check linkage success.
  GLint linkSuccess;
  glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
  if (linkSuccess == GL_FALSE) {
    GLchar messages[256];
    glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
    NSString *messageString = [NSString stringWithUTF8String:messages];
    NSLog(@"%@", messageString);
    exit(1);
  }
  
  // Get shader attribute locations.
  _positionSlot = glGetAttribLocation(program, "Position");
  _colorSlot = glGetAttribLocation(program, "SourceColor");
  _textureSlot = glGetAttribLocation(program, "TexCoordIn");

  // Get uniform locations:
  _projectionUniform = glGetUniformLocation(program, "Projection");
  _textureUniform = glGetUniformLocation(program, "Texture");
  
  return program;
}

- (void)setupGL {
  
  // Initialize context.
  [EAGLContext setCurrentContext:self.context];

  // Create program.
  self.program = [self createProgram];
  
  glEnableVertexAttribArray(_positionSlot);
  glEnableVertexAttribArray(_colorSlot);
  glEnableVertexAttribArray(_textureSlot);

  [self initTexture];
  [self initVBOs];
  
}

- (void)initTexture {
  GLKTextureInfo *spriteTexture;
  NSError *theError;
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lightricks" ofType:@"png"]; // 1
  spriteTexture = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:&theError]; // 2
  glBindTexture(spriteTexture.target, spriteTexture.name); // 3
  glEnable(spriteTexture.target); // 4
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
  
  glClearColor(1.0, 0.0, 0.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT);

  
  float h = 4.0f * self.view.frame.size.height / self.view.frame.size.width;
  GLKMatrix4 projectionMatrix = GLKMatrix4MakeFrustum(-2, 2, h/2, -h/2, 1, 1);
  glUniformMatrix4fv(_projectionUniform, 1, 0, projectionMatrix.m);
  
  glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
  glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
  glVertexAttribPointer(_textureSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
  
  glActiveTexture(GL_TEXTURE0);
  glUniform1i(_textureUniform, 0);
  
  
  // 3
  glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
  
  
}

@end
