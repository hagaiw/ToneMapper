//
//  TMShaderFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

#import "TMShader.h"

NS_ASSUME_NONNULL_BEGIN

/// A factory class that produces shaders.
@interface TMShaderFactory : NSObject

/// Compiles and creates a shader with \c shaderName and \c shadertype.
/// Returns the \c GLuint handle of the shader.
- (TMShader *)shaderForShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType;

@end

NS_ASSUME_NONNULL_END
