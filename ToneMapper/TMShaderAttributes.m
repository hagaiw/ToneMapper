//
//  TMShaderVariables.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMShaderAttributes.h"

@interface TMShaderAttributes ()

@property (readwrite, strong, nonatomic) NSDictionary *attributeHandleFromName;

@end


@implementation TMShaderAttributes

- (instancetype)initWithProgramHandle:(GLuint)programHandle attributes:(NSArray *)attributeNames {
  if (self = [super init]) {
    NSMutableDictionary *mutableAttributeHandleFromName = [[NSMutableDictionary alloc] init];
    NSUInteger handleCounter = 10;
    for (NSString *attributeName in attributeNames) {
      //glBindAttribLocation(programHandle, (uint)handleCounter, [attributeName UTF8String]) ; // TODO delete
      [mutableAttributeHandleFromName setValue:[NSNumber numberWithUnsignedLong:handleCounter]
                                        forKey:attributeName];
    }
    
    self.attributeHandleFromName = mutableAttributeHandleFromName;
  }
  return self;
}

- (GLuint)handleForName:(NSString *)name {
  NSNumber *handle = (NSNumber *)[self.attributeHandleFromName valueForKey:name];
  return (GLuint)[handle integerValue];
}

@end
