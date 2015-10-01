//
//  TMShaderBundle.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>

@interface TMShaderBundle : NSObject

- (instancetype)initWithVertexShader:(NSString *)vertexShader
                      fragmentShader:(NSString *)fragmentShader attributes:(NSArray *)attributes uniforms:(NSArray *)uniforms;

@property (readonly, nonatomic) GLuint vertexShaderHandle;
@property (readonly, nonatomic) GLuint fragmentShaderHandle;

@end
