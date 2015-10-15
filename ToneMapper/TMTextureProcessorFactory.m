//
//  TMTextureProcessorFactory.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMTextureProcessorFactory.h"

@implementation TMTextureProcessorFactory



- (TMTextureProcessor *)processorWithProgram:(TMTextureProgram *)program {
  return [[TMTextureProcessor alloc] initWithProgram:program];
}

@end
