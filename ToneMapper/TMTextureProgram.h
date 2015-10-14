//
//  TMTextureProgram.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/12/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMProgram.h"

static NSString * const kPositionAttribute = @"Position";
static NSString * const kTextureCoordinateAttribute = @"TexCoordIn";
static NSString * const kTextureUniform = @"Texture";
static NSString * const kProjectionUniform = @"Projection";

@interface TMTextureProgram : NSObject

- (instancetype)initWithProgram:(TMProgram *)program
           textureUniformString:(NSString *)textureUniform
        projectionUniformString:(NSString *)projectionUniform
    textureCoordAttributeString:(NSString *)textureCoordAttribute
        positionAttributeString:(NSString *)positionAttribute;

- (void)use;

@property (readonly, nonatomic) GLuint textureUniform;
@property (readonly, nonatomic) GLuint projectionUniform;
@property (readonly, nonatomic) GLuint textureCoordAttribute;
@property (readonly, nonatomic) GLuint positionAttribute;

@end
