//
//  TMTextureProcessor.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMTexture.h"
#import "TMTextureProgram.h"

@interface TMTextureProcessor : NSObject

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithProgram:(TMTextureProgram *)program;

- (TMTexture *)processTexture:(TMTexture *)texture;
- (TMTexture *)processAndFlipTexture:(TMTexture *)texture;

@end
