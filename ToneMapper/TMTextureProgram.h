//
//  TMTextureProgram.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/12/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProgram.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The name of the position attribute in the vertex shader.
static NSString * const kPositionAttribute = @"Position";

/// The name of the texture coordinate attribute in the fragment shader.
static NSString * const kTextureCoordinateAttribute = @"TexCoordIn";

/// The name of the texture uniform in the fragment shader.
static NSString * const kTextureUniform = @"Texture";

/// The name of the projection uniform in the vertex shader.
static NSString * const kProjectionUniform = @"Projection";

/// A \c TMProgram wrapper class that represents a texture-program, which displays a texture
/// and applies a projection matrix to its vertices.
/// \c Program's shaders are expected to include the "Position" and "TexCoordIn" attributes. They
/// are also expected to include the "Texture" and "Projection" uniforms.
@interface TMTextureProgram : NSObject

/// Initialize with \c TMProgram, \c textureUniform, \c projectionUniform, \c textureCoordAttribute
/// and \c positionAttribute.
- (instancetype)initWithProgram:(TMProgram *)program
           textureUniformString:(NSString *)textureUniform
        projectionUniformString:(NSString *)projectionUniform
    textureCoordAttributeString:(NSString *)textureCoordAttribute
        positionAttributeString:(NSString *)positionAttribute;

/// Binds the program using \c glUseProgram.
- (void)use;

/// The texture uniform handle of the program.
@property (readonly, nonatomic) GLuint textureUniform;

/// The projection uniform handle of the program.
@property (readonly, nonatomic) GLuint projectionUniform;

/// The texture coordinate attribute handle of the program.
@property (readonly, nonatomic) GLuint textureCoordAttribute;

/// The position attribute handler of the program.
@property (readonly, nonatomic) GLuint positionAttribute;

@end

NS_ASSUME_NONNULL_END
