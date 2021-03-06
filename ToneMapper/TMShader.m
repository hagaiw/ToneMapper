//
//  TMShader.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/18/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMShader.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMShader

/// The expected file extension for the given shader name.
static NSString * const kShaderFileExtension = @"glsl";

/// Error message to present in the case of a compilation error.
static NSString * const kShaderCompileErrorMessage = @"Error loading shader: %@";

#pragma mark -
#pragma mark Initialize
#pragma mark -

- (instancetype)initWithShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType {
  if (self = [super init]) {
    _handle = [self compileShader:shaderName withType:shaderType];
  }
  return self;
}

#pragma mark -
#pragma mark Compilation
#pragma mark -

/// Taken from: http://www.raywenderlich.com/3664/opengl-tutorial-for-ios-opengl-es-2-0
- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
  
  NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                         ofType:kShaderFileExtension];
  NSError* error;
  NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                     encoding:NSUTF8StringEncoding error:&error];
  if (!shaderString) {
    NSLog(kShaderCompileErrorMessage, error.localizedDescription);
    exit(1);
  }
  
  GLuint shaderHandle = glCreateShader(shaderType);
  
  const char * shaderStringUTF8 = [shaderString UTF8String];
  int shaderStringLength = (int)[shaderString length];
  glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
  
  glCompileShader(shaderHandle);
  
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

- (void)dealloc {
  glDeleteShader(self.handle);
}

@end

NS_ASSUME_NONNULL_END
