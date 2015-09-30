//
//  TMShaderVariables.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface TMShaderAttributes : NSObject

- (instancetype)initWithProgramHandle:(GLuint)programHandle attributes:(NSArray *)attributeNames;

- (GLuint)handleForName:(NSString *)name;

@property (readonly, strong, nonatomic) NSDictionary *attributeHandleFromName;


@end
