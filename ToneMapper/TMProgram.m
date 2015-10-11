//
//  TMProgram.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProgram.h"


@interface TMProgram ()

@property (nonatomic) GLuint program;
@property (readwrite, strong, nonatomic) HandleDictionary *handlesForAttributes;
@property (readwrite, strong, nonatomic) HandleDictionary *handlesForUniforms;

@end

@implementation TMProgram

- (instancetype)initWithAttributes:(NSArray *)attributes uniforms:(NSArray *)uniforms
                  vertexShaderName:(NSString *)vertexShaderName
                fragmentShaderName:(NSString *)fragmentShaderName {
  if (self = [super init]) {
    
    TMShaderFactory *shaderFactory = [[TMShaderFactory alloc] init];
    
    GLuint vertexShaderHandle = [shaderFactory shaderForShaderName:vertexShaderName
                                                        shaderType:GL_VERTEX_SHADER];
    GLuint fragmentShaderHandle = [shaderFactory shaderForShaderName:fragmentShaderName
                                                          shaderType:GL_FRAGMENT_SHADER];
  
    self.program = glCreateProgram();
    glAttachShader(self.program, vertexShaderHandle);
    glAttachShader(self.program, fragmentShaderHandle);
    glLinkProgram(self.program);
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
    
    self.handlesForAttributes = [[HandleDictionary alloc] init];
    for (NSString *attribute in attributes) {
      GLuint handle = glGetAttribLocation(self.program, [attribute UTF8String]);
      glEnableVertexAttribArray(handle);
      [self.handlesForAttributes setHandle:handle forKey:attribute];
    }
    
    self.handlesForUniforms = [[HandleDictionary alloc] init];
    for (NSString *uniform in uniforms) {
      GLuint handle = glGetUniformLocation(self.program, [uniform UTF8String]);
      [self.handlesForUniforms setHandle:handle forKey:uniform];
    }
  }
  return self;
}

- (void)useProgram {
  glUseProgram(self.program);
}

@end
