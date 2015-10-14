//
//  TMTextureProcessorFactory.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureProcessorFactory.h"

@implementation TMTextureProcessorFactory

static NSString * const kTextureVertexShader = @"textureVertexShader";
static NSString * const kTextureFragmentShader = @"textureFragmentShader";

- (TMTextureProcessor *)processorWithTexture:(TMTexture *)texture {
  return [[TMTextureProcessor alloc] initWithVertexShader:kTextureVertexShader
                                           fragmentShader:kTextureFragmentShader
                                                  texture:texture];
}

@end
