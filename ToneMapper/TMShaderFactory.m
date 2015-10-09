//
//  TMShaderFactory.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMShaderFactory.h"



@implementation TMShaderFactory

- (GLuint)shaderForShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType {
  return [self compileShader:shaderName withType:shaderType];
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
