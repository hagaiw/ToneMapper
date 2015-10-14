//
//  TMTextureProcessorFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMTextureProcessor.h"

@interface TMTextureProcessorFactory : NSObject

- (TMTextureProcessor *)processorWithTexture:(TMTexture *)texture;

@end
