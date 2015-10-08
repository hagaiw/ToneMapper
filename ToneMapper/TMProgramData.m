//
//  TMProgramData.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProgramData.h"

@interface TMProgramData ()

@property (readwrite, strong, nonatomic) NSArray *attributes;
@property (readwrite, strong, nonatomic) NSArray *uniforms;
@property (readwrite, strong, nonatomic) NSString *vertexShaderName;
@property (readwrite, strong, nonatomic) NSString *fragmentShaderName;

@end

@implementation TMProgramData

- (instancetype)initWithAttributes:(NSArray *)attributes uniforms:(NSArray *)uniforms
                  vertexShaderName:(NSString *)vertexShaderName
                fragmentShaderName:(NSString *)fragmentShaderName {
  if (self = [super init]) {
    self.attributes = attributes;
    self.uniforms = uniforms;
    self.vertexShaderName = vertexShaderName;
    self.fragmentShaderName = fragmentShaderName;
  }
  return self;
}

@end
