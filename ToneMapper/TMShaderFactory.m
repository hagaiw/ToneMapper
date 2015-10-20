//
//  TMShaderFactory.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMShaderFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TMShaderFactory

#pragma mark -
#pragma mark Initialization
#pragma mark -

- (TMShader *)shaderForShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType {
  return [[TMShader alloc] initWithShaderName:shaderName shaderType:shaderType];
}

@end

NS_ASSUME_NONNULL_END
