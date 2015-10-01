//
//  TMImageProgram.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMImageProgram.h"


@interface TMImageProgram ()

@property (readwrite, nonatomic) GLuint positionSlot;
@property (readwrite, nonatomic) GLuint textureSlot;
@property (readwrite, nonatomic) GLuint projectionUniform;
@property (readwrite, nonatomic) GLuint textureUniform;

@end

@implementation TMImageProgram



- (instancetype)initWithShaderBundle:(TMShaderBundle *)shaderBundle image:(NSString *)imagePath{
  if (self = [super init]) {
    self.program = [self createProgramWithVertexShader:shaderBundle.vertexShaderHandle
                                        fragmentShader:shaderBundle.fragmentShaderHandle];
    glLinkProgram(self.program);
    
    self.positionSlot = glGetAttribLocation(self.program, "Position");
    self.textureSlot = glGetAttribLocation(self.program, "TexCoordIn");
    self.projectionUniform = glGetUniformLocation(self.program, "Projection");
    self.textureUniform = glGetUniformLocation(self.program, "Texture");
    
    // Check linkage success.
    GLint linkSuccess;
    glGetProgramiv(self.program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
      GLchar messages[256];
      glGetProgramInfoLog(self.program, sizeof(messages), 0, &messages[0]);
      NSString *messageString = [NSString stringWithUTF8String:messages];
      NSLog(@"%@", messageString);
      exit(1);
    }
  }
  [self initTextureImage:imagePath];
  
  return self;
}

- (GLuint)createProgramWithVertexShader:(GLuint)vertexShader
                         fragmentShader:(GLuint)fragmentShader {
  GLuint program = glCreateProgram();
  
  // create and link shaders
  glAttachShader(program, vertexShader);
  glAttachShader(program, fragmentShader);
  
  return program;

}

- (void)initTextureImage:(NSString *)imagePath {
  glActiveTexture(GL_TEXTURE0);
  GLKTextureInfo *spriteTexture;
  NSError *theError;
  NSString *filePath = [[NSBundle mainBundle] pathForResource:imagePath ofType:@"png"];
  NSLog(@"GL Error = %u", glGetError()); // Fixes an issue where GLKTextureLoader returns nil
  spriteTexture = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:&theError];
  glBindTexture(spriteTexture.target, spriteTexture.name);
  glEnable(spriteTexture.target);
  glUniform1i(_textureUniform, 0);
}

@end
