//
//  TMTextureParameter.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/14/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface TMScalarProgramParameter : NSObject

- (instancetype)initWithName:(NSString *)name value:(GLfloat)value;

@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, nonatomic) GLfloat value;

@end
