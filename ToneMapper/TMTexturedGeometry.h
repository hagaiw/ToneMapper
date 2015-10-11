//
//  TMGeometry.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TMVertices.h"

@import GLKit;


@interface TMTexturedGeometry : NSObject

- (instancetype)initWithTexturedVertices:(id<TMTexturedVertices>)texturedVertices;
- (void)bind;
- (void)linkPositionArrayToAttribute:(GLuint)positionHandle ;
- (void)linkTextureArrayToAttribute:(GLuint)textureHandle;
- (void)drawElements;
@end
