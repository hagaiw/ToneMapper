//
//  TMProgamFactory.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProgramFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMProgramFactory

static NSString * const kWorkspaceVertexShader = @"workspaceVertexShader";
static NSString * const kWorkspaceFragmentShader = @"workspaceFragmentShader";
static NSString * const kTextureVertexShader = @"textureVertexShader";
static NSString * const kTextureFragmentShader = @"textureFragmentShader";

#pragma mark -
#pragma mark Factory Methods
#pragma mark -

- (TMTextureProgram *)textureDisplayProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[self defaultUniforms]
                                            vertexShaderName:kWorkspaceVertexShader
                                          fragmentShaderName:kWorkspaceFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (TMTextureProgram *)textureProcessingProgram {
  TMProgram *program = [[TMProgram alloc] initWithAttributes:[self defaultAttributes]
                                                    uniforms:[self defaultUniforms]
                                            vertexShaderName:kTextureVertexShader
                                          fragmentShaderName:kTextureFragmentShader];
  return [[TMTextureProgram alloc] initWithProgram:program];
}

- (NSArray *)defaultAttributes {
  return @[kPositionAttribute, kTextureCoordinateAttribute];
}

- (NSArray *)defaultUniforms {
  return @[kTextureUniform, kProjectionUniform];
}

@end

NS_ASSUME_NONNULL_END
