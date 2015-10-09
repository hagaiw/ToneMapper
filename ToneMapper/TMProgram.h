//
//  TMProgram.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GLKit;

#import "TMShaderFactory.h"
#import "HandleDictionary.h"

@interface TMProgram : NSObject

@property (readonly, strong, nonatomic) HandleDictionary *handlesForAttributes;
@property (readonly, strong, nonatomic) HandleDictionary *handlesForUniforms;

- (instancetype)initWithAttributes:(NSArray *)attributes uniforms:(NSArray *)uniforms
                  vertexShaderName:(NSString *)vertexShaderName
                fragmentShaderName:(NSString *)fragmentShaderName;

- (void)useProgram;

@end
