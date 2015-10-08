//
//  TMImageProgram.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/29/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TMProgram.h"

#import "HandleDictionary.h"

#import "TMShaderBundle.h"
#import <GLKit/GLKit.h>

@interface TMImageProgram : NSObject <TMProgram>

- (instancetype)initWithProgramHandle:(GLuint)programHandle
                 handlesForAttributes:(HandleDictionary *)handlesForAttributes
                   handlesForUniforms:(HandleDictionary *)handlesForUniforms;

@property (nonatomic) GLuint program;
@property (readonly, strong, nonatomic) HandleDictionary *handlesForAttributes;
@property (readonly, strong, nonatomic) HandleDictionary *handlesForUniforms;

@end
