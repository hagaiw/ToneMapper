//
//  handleDictionary.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "HandleDictionary.h"

@interface HandleDictionary ()

@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@implementation HandleDictionary

- (instancetype)init {
  if (self = [super init]) {
    self.dictionary = [NSMutableDictionary new];
  }
  return self;
}

- (void)setHandle:(GLuint)handle forKey:(NSString *)key {
  [self.dictionary setObject:[NSNumber numberWithUnsignedInteger:handle] forKey:key];
}

- (GLuint)handleForKey:(NSString *)key {
  NSNumber *value = [self.dictionary objectForKey:key];
  return (GLuint)[value unsignedIntegerValue];
}

@end
