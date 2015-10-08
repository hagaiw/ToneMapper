//
//  TMProgramData.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMProgramData : NSObject

- (instancetype)initWithAttributes:(NSArray *)attributes uniforms:(NSArray *)uniforms
                  vertexShaderName:(NSString *)vertexShaderName
                fragmentShaderName:(NSString *)fragmentShaderName;

@property (readonly, strong, nonatomic) NSArray *attributes;
@property (readonly, strong, nonatomic) NSArray *uniforms;
@property (readonly, strong, nonatomic) NSString *vertexShaderName;
@property (readonly, strong, nonatomic) NSString *fragmentShaderName;

@end
