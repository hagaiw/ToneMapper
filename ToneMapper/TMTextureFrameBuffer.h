//
//  TMTextureFrameBuffer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TMTexture.h"
#import "TMFrameBuffer.h"
@import GLKit;

@interface TMTextureFrameBuffer : NSObject <TMFrameBuffer>

@property (readonly, strong, nonatomic) TMTexture *texture;
- (instancetype)initWithSourceTexture:(TMTexture *)sourceTexture;
- (void)bind;
- (void)destroy;
@end
