//
//  TMProgamFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMProgram.h"
#import "TMTextureProgram.h"


@interface TMProgramFactory : NSObject

- (TMTextureProgram *)textureProgramWithVertexShaderName:(NSString *)vertexShader
                                    fragmentShaderName:(NSString *)fragmentShader
                                    textureUniformName:(NSString *)textureUniform
                                 projectionUniformName:(NSString *)projectionUniform
                                 positionAttributeName:(NSString *)positionAttribute
                                      textureCoordName:(NSString *)textureCoordAttribute;

@end
