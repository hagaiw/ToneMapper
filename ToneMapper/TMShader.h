//
//  TMShader.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/18/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

NS_ASSUME_NONNULL_BEGIN

/// Wraps an openGL shader.
@interface TMShader : NSObject

/// Initialize with \c shaderName, \c shaderType and compile the shader.
- (instancetype)initWithShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType;

/// The handle of the wrapped shader.
@property (readonly, nonatomic) GLuint handle;

@end

NS_ASSUME_NONNULL_END
