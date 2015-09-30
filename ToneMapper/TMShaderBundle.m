//
//  TMShaderBundle.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMShaderBundle.h"


@interface TMShaderBundle ()

@property (readwrite, nonatomic) GLuint vertexShaderHandle;
@property (readwrite, nonatomic) GLuint fragmentShaderHandle;

@end

@implementation TMShaderBundle

- (instancetype)initWithVertexShader:(NSString *)vertexShaderPath
                      fragmentShader:(NSString *)fragmentShaderPath {
  
  if (self = [super init]) {
    self.vertexShaderHandle = [self compileShader:vertexShaderPath withType:GL_VERTEX_SHADER];
    self.fragmentShaderHandle = [self compileShader:fragmentShaderPath withType:GL_FRAGMENT_SHADER];
  }
  
  return self;
}


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
  int shaderStringLength = (int)[shaderString length];
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

@end
