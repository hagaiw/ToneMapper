//
//  TMShaderFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

@import GLKit;

#import <Foundation/Foundation.h>

@interface TMShaderFactory : NSObject


- (GLuint)shaderForShaderName:(NSString *)shaderName shaderType:(GLenum)shaderType;



@end
