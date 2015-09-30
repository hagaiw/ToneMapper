//
//  TMImageProgram.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TMProgram.h"

#import "TMShaderBundle.h"
#import "TMShaderAttributes.h"
#import <GLKit/GLKit.h>

@interface TMImageProgram : NSObject <TMProgram>

- (instancetype)initWithShaderBundle:(TMShaderBundle *)shaderBundle attributeNames:(NSArray *)attributeNames;
@property (nonatomic) GLuint program;
@property (readonly, nonatomic) GLuint positionSlot;
@property (readonly, nonatomic) GLuint textureSlot;
@property (readonly, nonatomic) GLuint projectionUniform;
@property (readonly, nonatomic) GLuint textureUniform;

@end
