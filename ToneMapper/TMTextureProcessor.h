//
//  TMTextureProcessor.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMTexture.h"

@interface TMTextureProcessor : NSObject

- (TMTexture *)process;
- (instancetype)initWithVertexShader:(NSString *)vertexShader
                      fragmentShader:(NSString *)fragmentShader
                             texture:(TMTexture *)texture;
- (TMTextureProcessor *)processorWithTexture:(TMTexture *)texture;

@end
