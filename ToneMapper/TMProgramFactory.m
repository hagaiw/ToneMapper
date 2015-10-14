//
//  TMProgamFactory.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProgramFactory.h"

@implementation TMProgramFactory

- (TMTextureProgram *)textureProgramWithVertexShaderName:(NSString *)vertexShader
                                      fragmentShaderName:(NSString *)fragmentShader
                                      textureUniformName:(NSString *)textureUniform
                                   projectionUniformName:(NSString *)projectionUniform
                                   positionAttributeName:(NSString *)positionAttribute
                                        textureCoordName:(NSString *)textureCoordAttribute {
  NSArray *attributes = @[positionAttribute, textureCoordAttribute];
  NSArray *uniforms = @[textureUniform, projectionUniform];
  TMProgram *program = [[TMProgram alloc] initWithAttributes:attributes
                                                       uniforms:uniforms
                                               vertexShaderName:vertexShader
                                             fragmentShaderName:fragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program
                              textureUniformString:textureUniform
                           projectionUniformString:projectionUniform 
                       textureCoordAttributeString:textureCoordAttribute 
                           positionAttributeString:positionAttribute];
}

@end