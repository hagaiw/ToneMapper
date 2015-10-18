//
//  TMShader.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/18/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface TMShader : NSObject

- (instancetype)initWithShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType;

@property (readonly, nonatomic) GLuint handle;

@end
